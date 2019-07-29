import { withPluginApi } from "discourse/lib/plugin-api";
import { iconNode, convertIconClass } from "discourse-common/lib/icon-library";
import RawHtml from "discourse/widgets/raw-html";

function attachPostUserExtras(api) 
{
  api.includePostAttributes("post_user_extras");

  api.decorateWidget("post-avatar:after", dec => {
    if (Ember.isEmpty(dec.attrs.post_user_extras)) 
    {
      return;
    }

    const currentUser = api.getCurrentUser();
    if (currentUser) 
    {
      var array = getArrayIconGroupsAndBadges(currentUser, dec);
      return dec.h("div.group-icon-widget", array);
    }
  });

  api.decorateWidget('poster-name:after', dec => {
    if (Ember.isEmpty(dec.attrs.post_user_extras)) 
    {
      return;
    }

    const currentUser = api.getCurrentUser();
    if (currentUser) 
    {
      var array = getArrayIconGroupsAndBadges(currentUser, dec);
      return dec.h("div.group-icon-widget-mobile", array);
    }
  });

  api.decorateWidget("post-contents:after-cooked", dec => {
    const post_user_extras = dec.attrs.post_user_extras;
    if (Ember.isEmpty(attrs.post_user_extras)) 
    {
      return;
    }

    const currentUser = api.getCurrentUser();
    if (currentUser) 
    {
      const enabled = currentUser.get("custom_fields.see_signatures");
      if (enabled) 
      {
        var signature_no_smoking_text = (post_user_extras.signature_no_smoking_text != undefined && post_user_extras.signature_no_smoking_text != '') ? post_user_extras.signature_no_smoking_text : "Не курю";
        var img_signature_no_smoking = post_user_extras.img_signature_no_smoking_1 ? "nosmoking.png" : post_user_extras.img_signature_no_smoking_2 ? "cigarette.png" : post_user_extras.img_signature_no_smoking_3 ? "no-smoking.png" : post_user_extras.img_signature_no_smoking_4 ? "quit-smoking-1.png" : post_user_extras.img_signature_no_smoking_5 ? "quit-smoking.png" : "";
        const result_no_smoking = setСounter(post_user_extras.signature_no_smoking, signature_no_smoking_text, '/plugins/discourse-post-user-extras/images/' + img_signature_no_smoking);
        const result_no_drink = setСounter(post_user_extras.signature_no_drink, "Не пью", "/plugins/discourse-post-user-extras/images/nodrink.png");
        const result_proper_nutrition = setСounter(post_user_extras.signature_proper_nutrition, "На ПП", "/plugins/discourse-post-user-extras/images/pp.png");
        const result_fitnes = setСounter(post_user_extras.signature_fitnes, "На спорте", "/plugins/discourse-post-user-extras/images/fit.png");
        const result_clear_home = setСounter(post_user_extras.signature_clear_home, "В доме чисто", "/plugins/discourse-post-user-extras/images/home.png");
        const result_hobby = setСounter(post_user_extras.signature_hobby, "С хобби", "/plugins/discourse-post-user-extras/images/hobby.png");
        const signature_cooked = parseSignature(post_user_extras.signature_cooked);
        
        if (result_no_smoking != '' || result_no_drink != '' || result_proper_nutrition != '' || result_fitnes != '' || result_clear_home != '' || result_hobby != '' || signature_cooked != '') 
        {
          return [
            dec.h("hr"),
            dec.h("div", new RawHtml({html: `<div class='user-signature'>${result_no_smoking} ${result_no_drink} ${result_proper_nutrition} ${result_fitnes} ${result_clear_home} ${result_hobby} ${signature_cooked}</div>`}))
          ];
        }
      }
    }
  });
}

function getArrayIconGroupsAndBadges(currentUser, dec)
{
  var post_user_extras = dec.attrs.post_user_extras;
  var array = [];
  const see_groups_icon = currentUser.get("custom_fields.see_groups_icon");
  if (see_groups_icon) 
  {
    var groups = [];
    var user_trust_level = post_user_extras.trust_level == 0 ? "новый" : post_user_extras.trust_level == 1 ? "базовый" : post_user_extras.trust_level == 2 ? "участник" : post_user_extras.trust_level == 3 ? "обычный" : post_user_extras.trust_level == 4 ? "лидер" : "";
    groups.push(dec.h("div.user_trust_level_" + post_user_extras.trust_level, { title: user_trust_level }));
    if (post_user_extras.admin)
    {
      groups.push(dec.h("div.user_admin", { title: "администратор" }));
    }
    else if (post_user_extras.moderator)
    {
      groups.push(dec.h("div.user_moderator", { title: "модератор" }));
    }
    var i;
    for (i = 0; i < post_user_extras.groups.length; i++)
    {
      if (post_user_extras.groups[i].flair_url != null && post_user_extras.groups[i].flair_url != '')
      {
        if (post_user_extras.groups[i].flair_url.includes("fa-")) 
        {
          const covertedIcon = convertIconClass(post_user_extras.groups[i].flair_url);
          groups.push(dec.h("div.fa", { title: post_user_extras.groups[i].name, style: "background:#" + post_user_extras.groups[i].flair_bg_color + ";color:#" + post_user_extras.groups[i].flair_color }, [ iconNode(covertedIcon) ]));
        }
        else 
        {
          groups.push(dec.h("div.img", { title: post_user_extras.groups[i].name, style: "background-image:url(" + post_user_extras.groups[i].flair_url + ");" }));
        }
      }
    }
    array.push(groups);
  }

  const see_badges_icon = currentUser.get("custom_fields.see_badges_icon");
  if (see_badges_icon) 
  {
    var user_badges = post_user_extras.custom_fields['user_badges'];
    if (user_badges != undefined && user_badges != '')
    {
      var userbadges = [];
      var badges = JSON.parse(user_badges);
      var j;
      for (j = 0; j < badges.length; j++)
      {
        userbadges.push(dec.h("div.img", { title: badges[j].name, style: "background-image:url(" + badges[j].image + ");" }));
      }
      array.push(userbadges);
    }
  }

  return array;
}

function setСounter(date, text, url)
{
  var result = '';
  if (date != undefined && date != null && date.indexOf('-') > 0)
  {
    var days = parseDateSignature(date);
    if (days != '')
    {
      var img = url != '/plugins/discourse-post-user-extras/images/' ? ('<img src="' + url + '" title="' + text + '" class="emoji" alt="' + text + '" />') : '';
      result = '<div class="signature-counter">' + img + '<font size="2"><em>' + text + ' ' + days + '.</em></font></div>';
    }
  }
  return result;
}

function parseSignature(item)
{
  var result='';
  if (item != undefined && item != null)
  {
    while (item.includes('<span data-date'))
    {
      result += item.substring(0, item.indexOf('<span data-date'));
      item = item.substring(item.indexOf('UTC">') + 5);

      var indexLast = item.indexOf('</span>');
      var date = item.substring(0, indexLast);

      result += parseDateSignature(date);
      item = item.substring(indexLast + 7);
    }
    result += item;
  }
  return result;
}

function parseDateSignature(date)
{ 
  var result = '';
  var start = new Date(date);
  if(!isNaN(start)){
    var end = new Date();
    var diff = new Date(end - start);
    var days = (Math.floor(diff/1000/60/60/24)).toString();
    var last = days.substr(days.length - 1);
    var last2 = days.length > 1 ? days.substr(days.length - 2) : days;
    result = days + ' ' + (last == '1' && last2 != '11' ? 'день' : (last == '2' || last == '3' || last == '4') && last2 != '12' && last2 != '13' && last2 != '14' ? 'дня' : 'дней');
  }
  return result;
}

export default 
{
  name: "extend-for-groups-icon",
  initialize(container) 
  {
    const siteSettings = container.lookup("site-settings:main");
    if (siteSettings.post_user_extras_enabled) 
    {
      withPluginApi("0.1", api => attachPostUserExtras(api));
    }
  }
};
