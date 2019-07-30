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
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_no_smoking_6"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_no_smoking_text_check"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_no_smoking_text"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_no_smoking"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_no_drink_1"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_no_drink_2"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_no_drink_3"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_no_drink_4"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_no_drink_text_check"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_no_drink_text"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_no_drink"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_proper_nutrition_1"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_proper_nutrition_2"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_proper_nutrition_3"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_proper_nutrition_text_check"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_proper_nutrition_text"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_proper_nutrition"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_fitnes_1"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_fitnes_2"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_fitnes_text_check"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_fitnes_text"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_fitnes"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_clear_home_1"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_clear_home_2"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_clear_home_3"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_clear_home_text_check"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_clear_home_text"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_clear_home"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_hobby_1"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_hobby_2"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_hobby_3"
DiscoursePluginRegistry.serialized_current_user_fields << "img_signature_hobby_4"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_hobby_text_check"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_hobby_text"
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
  User.register_custom_field_type('img_signature_no_smoking_6', :boolean)
  User.register_custom_field_type('signature_no_smoking_text_check', :boolean)
  User.register_custom_field_type('signature_no_smoking_text', :text)
  User.register_custom_field_type('signature_no_smoking', :text)
  User.register_custom_field_type('img_signature_no_drink_1', :boolean)
  User.register_custom_field_type('img_signature_no_drink_2', :boolean)
  User.register_custom_field_type('img_signature_no_drink_3', :boolean)
  User.register_custom_field_type('img_signature_no_drink_4', :boolean)
  User.register_custom_field_type('signature_no_drink_text_check', :boolean)
  User.register_custom_field_type('signature_no_drink_text', :text)
  User.register_custom_field_type('signature_no_drink', :text)
  User.register_custom_field_type('img_signature_proper_nutrition_1', :boolean)
  User.register_custom_field_type('img_signature_proper_nutrition_2', :boolean)
  User.register_custom_field_type('img_signature_proper_nutrition_3', :boolean)
  User.register_custom_field_type('signature_proper_nutrition_text_check', :boolean)
  User.register_custom_field_type('signature_proper_nutrition_text', :text)
  User.register_custom_field_type('signature_proper_nutrition', :text)
  User.register_custom_field_type('img_signature_fitnes_1', :boolean)
  User.register_custom_field_type('img_signature_fitnes_2', :boolean)
  User.register_custom_field_type('signature_fitnes_text_check', :boolean)
  User.register_custom_field_type('signature_fitnes_text', :text)
  User.register_custom_field_type('signature_fitnes', :text)
  User.register_custom_field_type('img_signature_clear_home_1', :boolean)
  User.register_custom_field_type('img_signature_clear_home_2', :boolean)
  User.register_custom_field_type('img_signature_clear_home_3', :boolean)
  User.register_custom_field_type('signature_clear_home_text_check', :boolean)
  User.register_custom_field_type('signature_clear_home_text', :text)
  User.register_custom_field_type('signature_clear_home', :text)
  User.register_custom_field_type('img_signature_hobby_1', :boolean)
  User.register_custom_field_type('img_signature_hobby_2', :boolean)
  User.register_custom_field_type('img_signature_hobby_3', :boolean)
  User.register_custom_field_type('img_signature_hobby_4', :boolean)
  User.register_custom_field_type('signature_hobby_text_check', :boolean)
  User.register_custom_field_type('signature_hobby_text', :text)
  User.register_custom_field_type('signature_hobby', :text)

  register_editable_user_custom_field [:see_groups_icon, :see_badges_icon, :see_signatures, :signature_raw, :img_signature_no_smoking_1, :img_signature_no_smoking_2, :img_signature_no_smoking_3, :img_signature_no_smoking_4, :img_signature_no_smoking_5, :img_signature_no_smoking_6, :signature_no_smoking_text_check, :signature_no_smoking_text, :signature_no_smoking, :img_signature_no_drink_1, :img_signature_no_drink_2, :img_signature_no_drink_3, :img_signature_no_drink_4, :signature_no_drink_text_check, :signature_no_drink_text, :signature_no_drink, :img_signature_proper_nutrition_1, :img_signature_proper_nutrition_2, :img_signature_proper_nutrition_3, :signature_proper_nutrition_text_check, :signature_proper_nutrition_text, :signature_proper_nutrition, :img_signature_fitnes_1, :img_signature_fitnes_2, :signature_fitnes_text_check, :signature_fitnes_text, :signature_fitnes, :img_signature_clear_home_1, :img_signature_clear_home_2, :img_signature_clear_home_3, :signature_clear_home_text_check, :signature_clear_home_text, :signature_clear_home, :img_signature_hobby_1, :img_signature_hobby_2, :img_signature_hobby_3, :img_signature_hobby_4, :signature_hobby_text_check, :signature_hobby_text, :signature_hobby]

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
          signature_no_smoking: PostUserExtraUtils.count_days(object.user.custom_fields['signature_no_smoking']),
          img_signature_no_drink: PostUserExtraUtils.get_img_signature_no_drink(object.user.custom_fields),
          signature_no_drink_text: PostUserExtraUtils.get_signature_no_drink_text(object.user.custom_fields),
          signature_no_drink: PostUserExtraUtils.count_days(object.user.custom_fields['signature_no_drink']),
          img_signature_proper_nutrition: PostUserExtraUtils.get_img_signature_proper_nutrition(object.user.custom_fields),
          signature_proper_nutrition_text: PostUserExtraUtils.get_signature_proper_nutrition_text(object.user.custom_fields),
          signature_proper_nutrition: PostUserExtraUtils.count_days(object.user.custom_fields['signature_proper_nutrition']),
          img_signature_fitnes: PostUserExtraUtils.get_img_signature_fitnes(object.user.custom_fields),
          signature_fitnes_text: PostUserExtraUtils.get_signature_fitnes_text(object.user.custom_fields),
          signature_fitnes: PostUserExtraUtils.count_days(object.user.custom_fields['signature_fitnes']),
          img_signature_clear_home: PostUserExtraUtils.get_img_signature_clear_home(object.user.custom_fields),
          signature_clear_home_text: PostUserExtraUtils.get_signature_clear_home_text(object.user.custom_fields),
          signature_clear_home: PostUserExtraUtils.count_days(object.user.custom_fields['signature_clear_home']),
          img_signature_hobby: PostUserExtraUtils.get_img_signature_hobby(object.user.custom_fields),
          signature_hobby_text: PostUserExtraUtils.get_signature_hobby_text(object.user.custom_fields),
          signature_hobby: PostUserExtraUtils.count_days(object.user.custom_fields['signature_hobby'])
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
    elsif custom_fields['img_signature_no_smoking_6'] then
      img_signature_no_smoking = "/plugins/discourse-post-user-extras/images/no_smoking3.png"
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
  
  def self.get_img_signature_no_drink(custom_fields)
    img_signature_no_drink = ""
    if custom_fields['img_signature_no_drink_1'] then
      img_signature_no_drink = "/plugins/discourse-post-user-extras/images/nodrink.png"
    elsif custom_fields['img_signature_no_drink_2'] then
      img_signature_no_drink = "/plugins/discourse-post-user-extras/images/no-alcohol.png"
    elsif custom_fields['img_signature_no_drink_3'] then
      img_signature_no_drink = "/plugins/discourse-post-user-extras/images/no-drinking.png"
    elsif custom_fields['img_signature_no_drink_4'] then
      img_signature_no_drink = "/plugins/discourse-post-user-extras/images/no-drinks.png"
    end
    return img_signature_no_drink
  end

  def self.get_signature_no_drink_text(custom_fields)
    signature_no_drink_text = ""
    if custom_fields['signature_no_drink_text_check'] then
      signature_no_drink_text = custom_fields['signature_no_drink_text']
    else 
      signature_no_drink_text = "Не пью"
    end
    return signature_no_drink_text
  end
  
  def self.get_img_signature_proper_nutrition(custom_fields)
    img_signature_proper_nutrition = ""
    if custom_fields['img_signature_proper_nutrition_1'] then
      img_signature_proper_nutrition = "/plugins/discourse-post-user-extras/images/pp.png"
    elsif custom_fields['img_signature_proper_nutrition_2'] then
      img_signature_proper_nutrition = "/plugins/discourse-post-user-extras/images/diet.png"
    elsif custom_fields['img_signature_proper_nutrition_3'] then
      img_signature_proper_nutrition = "/plugins/discourse-post-user-extras/images/salad.png"
    end
    return img_signature_proper_nutrition
  end

  def self.get_signature_proper_nutrition_text(custom_fields)
    signature_proper_nutrition_text = ""
    if custom_fields['signature_proper_nutrition_text_check'] then
      signature_proper_nutrition_text = custom_fields['signature_proper_nutrition_text']
    else 
      signature_proper_nutrition_text = "На ПП"
    end
    return signature_proper_nutrition_text
  end
  
  def self.get_img_signature_fitnes(custom_fields)
    img_signature_fitnes = ""
    if custom_fields['img_signature_fitnes_1'] then
      img_signature_fitnes = "/plugins/discourse-post-user-extras/images/fit.png"
    elsif custom_fields['img_signature_fitnes_2'] then
      img_signature_fitnes = "/plugins/discourse-post-user-extras/images/strong.png"
    end
    return img_signature_fitnes
  end

  def self.get_signature_fitnes_text(custom_fields)
    signature_fitnes_text = ""
    if custom_fields['signature_fitnes_text_check'] then
      signature_fitnes_text = custom_fields['signature_fitnes_text']
    else 
      signature_fitnes_text = "На спорте"
    end
    return signature_fitnes_text
  end
  
  def self.get_img_signature_clear_home(custom_fields)
    img_signature_clear_home = ""
    if custom_fields['img_signature_clear_home_1'] then
      img_signature_clear_home = "/plugins/discourse-post-user-extras/images/home.png"
    elsif custom_fields['img_signature_clear_home_2'] then
      img_signature_clear_home = "/plugins/discourse-post-user-extras/images/home2.png"
    elsif custom_fields['img_signature_clear_home_3'] then
      img_signature_clear_home = "/plugins/discourse-post-user-extras/images/house.png"
    end
    return img_signature_clear_home
  end

  def self.get_signature_clear_home_text(custom_fields)
    signature_clear_home_text = ""
    if custom_fields['signature_clear_home_text_check'] then
      signature_clear_home_text = custom_fields['signature_clear_home_text']
    else 
      signature_clear_home_text = "В доме чисто"
    end
    return signature_clear_home_text
  end
  
  def self.get_img_signature_hobby(custom_fields)
    img_signature_hobby = ""
    if custom_fields['img_signature_hobby_1'] then
      img_signature_hobby = "/plugins/discourse-post-user-extras/images/hobby.png"
    elsif custom_fields['img_signature_hobby_2'] then
      img_signature_hobby = "/plugins/discourse-post-user-extras/images/puzzle.png"
    elsif custom_fields['img_signature_hobby_3'] then
      img_signature_hobby = "/plugins/discourse-post-user-extras/images/jigsaw.png"
    elsif custom_fields['img_signature_hobby_4'] then
      img_signature_hobby = "/plugins/discourse-post-user-extras/images/hiking.png"
    end
    return img_signature_hobby
  end

  def self.get_signature_hobby_text(custom_fields)
    signature_hobby_text = ""
    if custom_fields['signature_hobby_text_check'] then
      signature_hobby_text = custom_fields['signature_hobby_text']
    else 
      signature_hobby_text = "Не курю"
    end
    return signature_hobby_text
  end

  def self.count_days(date)
    result = ""
    if date != nil && date != "" then
      past = Time.parse(date)
      if past != nil then
        now = Time.new
        diff = now - past 
        time = diff.round
        sec = time % 60
        time /= 60
        mins = time % 60
        time /= 60
        hrs = time % 24
        time /= 24
        days = "" + time
        last = days[days.length - 1];
        last2 = days.length > 1 ? days[days.length - 2, 2] : days;
        result = days + ' ' + (last == '1' && last2 != '11' ? 'день' : (last == '2' || last == '3' || last == '4') && last2 != '12' && last2 != '13' && last2 != '14' ? 'дня' : 'дней');
      end
    end
    return result
   end
end
