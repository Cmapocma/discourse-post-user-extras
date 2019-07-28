import { withPluginApi } from "discourse/lib/plugin-api";
import { iconNode, convertIconClass } from "discourse-common/lib/icon-library";
import RawHtml from "discourse/widgets/raw-html";

function attachPostUserExtras(api) 
{
  api.includePostAttributes("post_user_extras");

  api.decorateWidget("post-avatar:after", dec => {
    const attrs = dec.attrs;
    if (Ember.isEmpty(attrs.post_user_extras)) 
    {
      return;
    }

    const currentUser = api.getCurrentUser();
    if (currentUser) 
    {
      var array = [];
      const see_groups_icon = currentUser.get("custom_fields.see_groups_icon");
      if (see_groups_icon) 
      {
        var groups = [];
        var user_trust_level = attrs.post_user_extras.trust_level == 0 ? "новый" : attrs.post_user_extras.trust_level == 1 ? "базовый" : attrs.post_user_extras.trust_level == 2 ? "участник" : attrs.post_user_extras.trust_level == 3 ? "обычный" : attrs.post_user_extras.trust_level == 4 ? "лидер" : "";
        groups.push(dec.h("div.user_trust_level_" + attrs.post_user_extras.trust_level, { title: user_trust_level }));
        if (attrs.post_user_extras.admin)
        {
          groups.push(dec.h("div.user_admin", { title: "администратор" }));
        }
        else if (attrs.post_user_extras.moderator)
        {
          groups.push(dec.h("div.user_moderator", { title: "модератор" }));
        }
        var i;
        for (i = 0; i < attrs.post_user_extras.groups.length; i++)
        {
          if (attrs.post_user_extras.groups[i].flair_url != null)
          {
            if (attrs.post_user_extras.groups[i].flair_url.includes("fa-")) 
            {
              const covertedIcon = convertIconClass(attrs.post_user_extras.groups[i].flair_url);
              groups.push(dec.h("div.fa", { title: attrs.post_user_extras.groups[i].name, style: "background:#" + attrs.post_user_extras.groups[i].flair_bg_color + ";color:#" + attrs.post_user_extras.groups[i].flair_color }, [ iconNode(covertedIcon) ]));
            }
            else 
            {
              groups.push(dec.h("div.img", { title: attrs.post_user_extras.groups[i].name, style: "background-image:url(" + attrs.post_user_extras.groups[i].flair_url + ");" }));
            }
          }
        }
        array.push(groups);
      }

      const see_badges_icon = currentUser.get("custom_fields.see_badges_icon");
      if (see_badges_icon) 
      {
        var badges = [];
        var j;
        for (j = 0; j < attrs.post_user_extras.badges.length; j++)
        {
          badges.push(dec.h("div.badge.badge_" + attrs.post_user_extras.badges[j].badge_id));
        }
        array.push(badges);
      }

      return dec.h("div.group-icon-widget", array);
    }
  });

  api.decorateWidget("post-contents:after-cooked", dec => {
    const attrs = dec.attrs;
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
        const result_no_smoking = setСounter(attrs.post_user_extras.custom_fields['signature_no_smoking'], "Не курю", "/uploads/default/original/signature/nosmoking.png");
        const result_no_drink = setСounter(attrs.post_user_extras.custom_fields['signature_no_drink'], "Не пью", "/uploads/default/original/signature/nodrink.png");
        const result_proper_nutrition = setСounter(attrs.post_user_extras.custom_fields['signature_proper_nutrition'], "На ПП", "/uploads/default/original/signature/pp.png");
        const result_fitnes = setСounter(attrs.post_user_extras.custom_fields['signature_fitnes'], "На спорте", "/uploads/default/original/signature/fit.png");
        const result_clear_home = setСounter(attrs.post_user_extras.custom_fields['signature_clear_home'], "В доме чисто", "/uploads/default/original/signature/home.png");
        const result_hobby = setСounter(attrs.post_user_extras.custom_fields['signature_hobby'], "С хобби", "/uploads/default/original/signature/hobby.png");
        const signature_cooked = parseSignature(attrs.post_user_extras.custom_fields['signature_cooked']);
        
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

function setСounter(date, text, url)
{
  var result = '';
  if (date != undefined && date != null && date.indexOf('-') > 0)
  {
    var days = parseDateSignature(date);
    if (days != '')
    {
      result = '<div class="signature-counter"><img src="'+url+'" title="'+text+'" class="emoji" alt="'+text+'"> <font size="2"><em>'+text+' ' + days + '.</em></font></div>';
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
