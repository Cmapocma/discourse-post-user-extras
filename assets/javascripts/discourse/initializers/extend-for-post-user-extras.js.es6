import { withPluginApi } from "discourse/lib/plugin-api";
import RawHtml from "discourse/widgets/raw-html";

function attachPostUserExtras(api, controller) 
{
  api.includePostAttributes("post_user_extras");

  var elementname = controller.site.mobileView ? "poster-name:after" : "post-avatar:after";
  var divname = controller.site.mobileView ? "div.group-icon-widget-mobile" : "div.group-icon-widget";

  api.decorateWidget(elementname, dec => {
    if (!Ember.isEmpty(dec.attrs.post_user_extras)) 
    {
      const currentUser = api.getCurrentUser();
      if (currentUser) 
      {
        var array = getArrayIconGroupsAndBadges(currentUser, dec);
        return dec.h(divname, array);
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
          const result_no_smoking = post_user_extras.counter_no_smoking;
          const result_no_drink = post_user_extras.counter_no_drink;
          const result_proper_nutrition = post_user_extras.counter_proper_nutrition;
          const result_fitnes = post_user_extras.counter_fitnes;
          const result_clear_home = post_user_extras.counter_clear_home;
          const result_hobby = post_user_extras.counter_hobby;
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

export default 
{
  name: "extend-for-groups-icon",
  initialize(container) 
  {
    const siteSettings = container.lookup("site-settings:main");
    const controller = container.lookup("controller:application");
    if (siteSettings.post_user_extras_enabled) 
    {
      withPluginApi("0.1", api => attachPostUserExtras(api, controller));
    }
  }
};
