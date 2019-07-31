import { withPluginApi } from "discourse/lib/plugin-api";
//import { iconNode, convertIconClass } from "discourse-common/lib/icon-library";
import RawHtml from "discourse/widgets/raw-html";

function attachPostUserExtras(api) 
{
  api.includePostAttributes("post_user_extras");

  api.decorateWidget("post-avatar:after", dec => {
    if (!Ember.isEmpty(dec.attrs.post_user_extras)) 
    {
      const currentUser = api.getCurrentUser();
      if (currentUser) 
      {
        var array = getArrayIconGroupsAndBadges(currentUser, dec);
        return dec.h("div.group-icon-widget", array);
      }
    }
  });

  api.decorateWidget('poster-name:after', dec => {
    if (!Ember.isEmpty(dec.attrs.post_user_extras)) 
    {
      const currentUser = api.getCurrentUser();
      if (currentUser) 
      {
        var array = getArrayIconGroupsAndBadges(currentUser, dec);
        return dec.h("div.group-icon-widget-mobile", array);
      }
    }
  });

  api.decorateWidget("post-contents:after-cooked", dec => {
    const post_user_extras = dec.attrs.post_user_extras;
    if (!Ember.isEmpty(post_user_extras)) 
    {
      const currentUser = api.getCurrentUser();
      if (currentUser) 
      {
        const enabled = currentUser.get("custom_fields.see_signatures");
        if (enabled) 
        {
          const result_no_smoking = setСounter(post_user_extras.signature_no_smoking, post_user_extras.signature_no_smoking_text, post_user_extras.img_signature_no_smoking);
          const result_no_drink = setСounter(post_user_extras.signature_no_drink, post_user_extras.signature_no_drink_text, post_user_extras.img_signature_no_drink);
          const result_proper_nutrition = setСounter(post_user_extras.signature_proper_nutrition, post_user_extras.signature_proper_nutrition_text, post_user_extras.img_signature_proper_nutrition);
          const result_fitnes = setСounter(post_user_extras.signature_fitnes, post_user_extras.signature_fitnes_text, post_user_extras.img_signature_fitnes);
          const result_clear_home = setСounter(post_user_extras.signature_clear_home, post_user_extras.signature_clear_home_text, post_user_extras.img_signature_clear_home);
          const result_hobby = setСounter(post_user_extras.signature_hobby,  post_user_extras.signature_hobby_text, post_user_extras.img_signature_hobby);
          const signature_cooked = post_user_extras.signature_cooked;
        
          if (result_no_smoking != '' || result_no_drink != '' || result_proper_nutrition != '' || result_fitnes != '' || result_clear_home != '' || result_hobby != '' || signature_cooked != '') 
          {
            return dec.h("div", new RawHtml({html: `<div class='user-signature'>${result_no_smoking} ${result_no_drink} ${result_proper_nutrition} ${result_fitnes} ${result_clear_home} ${result_hobby} ${signature_cooked}</div>`}));
          }
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
    groups.push(dec.h("div.user_trust_level_" + post_user_extras.trust_level, { title: post_user_extras.trust_level_title }));
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
          //const covertedIcon = convertIconClass(post_user_extras.groups[i].flair_url);
          //groups.push(dec.h("div.fa", { title: post_user_extras.groups[i].name, style: "background:#" + post_user_extras.groups[i].flair_bg_color + ";color:#" + post_user_extras.groups[i].flair_color }, [ iconNode(covertedIcon) ]));
        }
        else 
        {
          groups.push(dec.h("div", { title: post_user_extras.groups[i].name, style: "background-image:url(" + post_user_extras.groups[i].flair_url + ");" }));
        }
      }
    }
    array.push(groups);
  }

  const see_badges_icon = currentUser.get("custom_fields.see_badges_icon");
  if (see_badges_icon) 
  {
    var user_badges = post_user_extras.user_badges;
    if (user_badges != undefined && user_badges != '')
    {
      var userbadges = [];
      var badges = JSON.parse(user_badges);
      var j;
      for (j = 0; j < badges.length; j++)
      {
        userbadges.push(dec.h("div", { title: badges[j].name, style: "background-image:url(" + badges[j].image + ");" }));
      }
      array.push(userbadges);
    }
  }

  return array;
}

function setСounter(days, text, url)
{
  var result = '';
  if (days != undefined && days != null && days != '')
  {
    text = text != undefined && text != null ? text : '';
    var img = url != undefined && url != null && url.includes('/plugins/discourse-post-user-extras/images/') ? ('<img src="' + url + '" title="' + text + '" class="emoji" alt="' + text + '" />') : '';
    result = '<div class="signature-counter">' + img + ' <font size="2"><em>' + text + ' ' + days + '.</em></font></div>';
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
