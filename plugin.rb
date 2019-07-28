# frozen_string_literal: true

# name: discourse-post-user-extras
# about: A plugin to get groups icon after avatar, badges and signature
# version: 1.0.0
# author: O.S.
# url: https://github.com/stuhin/discourse-post-user-extras

enabled_site_setting :post_user_extras_enabled

DiscoursePluginRegistry.serialized_current_user_fields << "see_groups_icon"
DiscoursePluginRegistry.serialized_current_user_fields << "see_badges_icon"
DiscoursePluginRegistry.serialized_current_user_fields << "see_signatures"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_raw"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_no_smoking"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_no_drink"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_proper_nutrition"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_fitnes"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_clear_home"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_hobby"

after_initialize do

  User.register_custom_field_type('see_groups_icon', :boolean)
  User.register_custom_field_type('see_badges_icon', :boolean)
  User.register_custom_field_type('see_signatures', :boolean)
  User.register_custom_field_type('signature_raw', :text)
  User.register_custom_field_type('signature_no_smoking', :text)
  User.register_custom_field_type('signature_no_drink', :text)
  User.register_custom_field_type('signature_proper_nutrition', :text)
  User.register_custom_field_type('signature_fitnes', :text)
  User.register_custom_field_type('signature_clear_home', :text)
  User.register_custom_field_type('signature_hobby', :text)

  register_editable_user_custom_field [:see_groups_icon, :see_badges_icon, :see_signatures, :signature_raw, :signature_no_smoking, :signature_no_drink, :signature_proper_nutrition, :signature_fitnes, :signature_clear_home, :signature_hobby]

  if SiteSetting.post_user_extras_enabled then
    add_to_serializer(:post, :post_user_extras, false) {
      if object.user == nil then
        {}
      else
        {
          groups: object.user.groups, 
          trust_level: object.user.trust_level, 
          admin: object.user.admin, 
          moderator: object.user.moderator, 
          badges: object.user.featured_user_badges,
          custom_fields: object.user.custom_fields
        }
      end
    }

    add_to_serializer(:user, :custom_fields, false) {
      if object.custom_fields == nil then
        {}
      else
        object.custom_fields
      end
    }
  end

  DiscourseEvent.on(:user_updated) do |user|
    if SiteSetting.post_user_extras_enabled
      user.custom_fields['signature_cooked'] = PrettyText.cook(user.custom_fields['signature_raw'])
      user.save
    end
  end

  #DiscourseEvent.on(:user_badge_granted) do |badge_id, user_id|
  #  if SiteSetting.post_user_extras_enabled
  #    user.custom_fields['signature_cooked'] = PrettyText.cook(user.custom_fields['signature_raw'])
  #  end
  #end

  #DiscourseEvent.on(:user_badge_removed) do |badge_id, user_id|
  #  if SiteSetting.post_user_extras_enabled
  #    user.custom_fields['signature_cooked'] = PrettyText.cook(user.custom_fields['signature_raw'])
  #  end
  #end

end

register_asset "javascripts/discourse/templates/connectors/user-custom-preferences/post-user-extras-preferences.hbs"
register_asset "stylesheets/common/post-user-extras.scss"
