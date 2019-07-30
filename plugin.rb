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
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_no_smoking_1"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_no_smoking_2"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_no_smoking_3"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_no_smoking_4"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_no_smoking_5"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_no_smoking_text_check"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_no_smoking_text"
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
  User.register_custom_field_type('img_signature_no_smoking_1', :boolean)
  User.register_custom_field_type('img_signature_no_smoking_2', :boolean)
  User.register_custom_field_type('img_signature_no_smoking_3', :boolean)
  User.register_custom_field_type('img_signature_no_smoking_4', :boolean)
  User.register_custom_field_type('img_signature_no_smoking_5', :boolean)
  User.register_custom_field_type('signature_no_smoking_text_check', :boolean)
  User.register_custom_field_type('signature_no_smoking_text', :text)
  User.register_custom_field_type('signature_no_smoking', :text)
  User.register_custom_field_type('signature_no_drink', :text)
  User.register_custom_field_type('signature_proper_nutrition', :text)
  User.register_custom_field_type('signature_fitnes', :text)
  User.register_custom_field_type('signature_clear_home', :text)
  User.register_custom_field_type('signature_hobby', :text)

  register_editable_user_custom_field [:see_groups_icon, :see_badges_icon, :see_signatures, :signature_raw, :img_signature_no_smoking_1, :img_signature_no_smoking_2, :img_signature_no_smoking_3, :img_signature_no_smoking_4, :img_signature_no_smoking_5, :signature_no_smoking_text_check, :signature_no_smoking_text, :signature_no_smoking, :signature_no_drink, :signature_proper_nutrition, :signature_fitnes, :signature_clear_home, :signature_hobby]

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
          user_badges: object.user.custom_fields['user_badges'],
          signature_cooked: object.user.custom_fields['signature_cooked'],
          img_signature_no_smoking: PostUserExtraUtils.get_img_signature_no_smoking(object.user.custom_fields),
          signature_no_smoking_text: PostUserExtraUtils.get_signature_no_smoking_text(object.user.custom_fields),
          signature_no_smoking: object.user.custom_fields['signature_no_smoking'],
          signature_no_drink: object.user.custom_fields['signature_no_drink'],
          signature_proper_nutrition: object.user.custom_fields['signature_proper_nutrition'],
          signature_fitnes: object.user.custom_fields['signature_fitnes'],
          signature_clear_home: object.user.custom_fields['signature_clear_home'],
          signature_hobby: object.user.custom_fields['signature_hobby']
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
    if SiteSetting.post_user_extras_enabled then
      user.custom_fields['signature_cooked'] = PrettyText.cook(user.custom_fields['signature_raw'])
      user.custom_fields['user_badges'] = DB.query_single("select '[' || string_agg('{\"id\":\"'|| b.id || '\", \"name\":\"' || b.name || '\", \"image\":\"' || b.image || '\"}', ',') || ']' from user_badges ub inner join badges b on b.id=ub.badge_id where ub.user_id=#{user.id} and b.enabled=true and b.image is not null and system=false").first
      user.save
    end
  end

  DiscourseEvent.on(:user_badge_granted) do |badge_id, user_id|
    if SiteSetting.post_user_extras_enabled then
      user = User.where(id: user_id).first
      user.custom_fields['user_badges'] = DB.query_single("select '[' || string_agg('{\"id\":\"'|| b.id || '\", \"name\":\"' || b.name || '\", \"image\":\"' || b.image || '\"}', ',') || ']' from user_badges ub inner join badges b on b.id=ub.badge_id where ub.user_id=#{user_id} and b.enabled=true and b.image is not null and system=false").first
      user.save
    end
  end

  DiscourseEvent.on(:user_badge_removed) do |badge_id, user_id|
    if SiteSetting.post_user_extras_enabled then
      user = User.where(id: user_id).first
      user.custom_fields['user_badges'] = DB.query_single("select '[' || string_agg('{\"id\":\"'|| b.id || '\", \"name\":\"' || b.name || '\", \"image\":\"' || b.image || '\"}', ',') || ']' from user_badges ub inner join badges b on b.id=ub.badge_id where ub.user_id=#{user_id} and b.enabled=true and b.image is not null and system=false").first
      user.save
    end
  end
end

register_asset "javascripts/discourse/templates/connectors/user-custom-preferences/post-user-extras-preferences.hbs"
register_asset "stylesheets/common/post-user-extras.scss"
register_asset "stylesheets/desktop/post-user-extras.scss", :desktop
register_asset "stylesheets/mobile/post-user-extras.scss", :mobile

class PostUserExtraUtils
  def self.get_img_signature_no_smoking(custom_fields)
    img_signature_no_smoking = ""
    if custom_fields['img_signature_no_smoking_1'] then
      img_signature_no_smoking = "/plugins/discourse-post-user-extras/images/nosmoking.png"
    elsif custom_fields['img_signature_no_smoking_2'] then
      img_signature_no_smoking = "/plugins/discourse-post-user-extras/images/cigarette.png"
    elsif custom_fields['img_signature_no_smoking_3'] then
      img_signature_no_smoking = "/plugins/discourse-post-user-extras/images/no-smoking.png"
    elsif custom_fields['img_signature_no_smoking_4'] then
      img_signature_no_smoking = "/plugins/discourse-post-user-extras/images/quit-smoking-1.png"
    elsif custom_fields['img_signature_no_smoking_5'] then
      img_signature_no_smoking = "/plugins/discourse-post-user-extras/images/quit-smoking.png"
    end
    return img_signature_no_smoking
  end

  def self.get_signature_no_smoking_text(custom_fields)
    signature_no_smoking_text = ""
    if custom_fields['signature_no_smoking_text_check'] then
      signature_no_smoking_text = custom_fields['signature_no_smoking_text']
    else 
      signature_no_smoking_text = "Не курю"
    end
    return signature_no_smoking_text
  end
end
