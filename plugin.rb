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
DiscoursePluginRegistry.serialized_current_user_fields << "counter_no_smoking_img"
DiscoursePluginRegistry.serialized_current_user_fields << "counter_no_smoking_text"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_no_smoking"
DiscoursePluginRegistry.serialized_current_user_fields << "counter_no_drink_img"
DiscoursePluginRegistry.serialized_current_user_fields << "counter_no_drink_text"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_no_drink"
DiscoursePluginRegistry.serialized_current_user_fields << "counter_proper_nutrition_img"
DiscoursePluginRegistry.serialized_current_user_fields << "counter_proper_nutrition_text"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_proper_nutrition"
DiscoursePluginRegistry.serialized_current_user_fields << "counter_fitnes_img"
DiscoursePluginRegistry.serialized_current_user_fields << "counter_fitnes_text"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_fitnes"
DiscoursePluginRegistry.serialized_current_user_fields << "counter_clear_home_img"
DiscoursePluginRegistry.serialized_current_user_fields << "counter_clear_home_text"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_clear_home"
DiscoursePluginRegistry.serialized_current_user_fields << "counter_hobby_img"
DiscoursePluginRegistry.serialized_current_user_fields << "counter_hobby_text"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_hobby"

after_initialize do

  User.register_custom_field_type('see_groups_icon', :boolean)
  User.register_custom_field_type('see_badges_icon', :boolean)
  User.register_custom_field_type('see_signatures', :boolean)
  User.register_custom_field_type('signature_raw', :text)
  User.register_custom_field_type('counter_no_smoking_img', :text)
  User.register_custom_field_type('counter_no_smoking_text', :text)
  User.register_custom_field_type('signature_no_smoking', :text)
  User.register_custom_field_type('counter_no_drink_img', :text)
  User.register_custom_field_type('counter_no_drink_text', :text)
  User.register_custom_field_type('signature_no_drink', :text)
  User.register_custom_field_type('counter_proper_nutrition_img', :text)
  User.register_custom_field_type('counter_proper_nutrition_text', :text)
  User.register_custom_field_type('signature_proper_nutrition', :text)
  User.register_custom_field_type('counter_fitnes_img', :text)
  User.register_custom_field_type('counter_fitnes_text', :text)
  User.register_custom_field_type('signature_fitnes', :text)
  User.register_custom_field_type('counter_clear_home_img', :text)
  User.register_custom_field_type('counter_clear_home_text', :text)
  User.register_custom_field_type('signature_clear_home', :text)
  User.register_custom_field_type('counter_hobby_img', :text)
  User.register_custom_field_type('counter_hobby_text', :text)
  User.register_custom_field_type('signature_hobby', :text)

  register_editable_user_custom_field [:see_groups_icon, :see_badges_icon, :see_signatures, :signature_raw, :counter_no_smoking_img, :counter_no_smoking_text, :signature_no_smoking, :counter_no_drink_img, :counter_no_drink_text, :signature_no_drink, :counter_proper_nutrition_img, :counter_proper_nutrition_text, :signature_proper_nutrition, :counter_fitnes_img, :counter_fitnes_text, :signature_fitnes, :counter_clear_home_img, :counter_clear_home_text, :signature_clear_home, :counter_hobby_img, :counter_hobby_text, :signature_hobby]

  if SiteSetting.post_user_extras_enabled then
    add_to_serializer(:post, :post_user_extras, false) {
      if object.user == nil then
      {}
      else
        {
          trust_level: object.user.trust_level,
          trust_level_href: PostUserExtraUtils.get_trust_level_href(trust_level, object.user.username_lower),
          trust_level_title: PostUserExtraUtils.get_trust_level_title(object.user.trust_level),
          admin: object.user.admin,
          moderator: object.user.moderator,
          user_badges: object.user.custom_fields['user_badges'],
          signature_cooked: PostUserExtraUtils.get_signature_cooked(object.user.custom_fields['signature_cooked']),
          counter_no_smoking: PostUserExtraUtils.get_counter_no_smoking(object.user.custom_fields),
          counter_no_drink: PostUserExtraUtils.get_counter_no_drink(object.user.custom_fields),
          counter_proper_nutrition: PostUserExtraUtils.get_counter_proper_nutrition(object.user.custom_fields),
          counter_fitnes: PostUserExtraUtils.get_counter_fitnes(object.user.custom_fields),
          counter_clear_home: PostUserExtraUtils.get_counter_clear_home(object.user.custom_fields),
          counter_hobby: PostUserExtraUtils.get_counter_hobby(object.user.custom_fields)
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
      if user.custom_fields['signature_raw'] != nil then
        user.custom_fields['signature_cooked'] = PrettyText.cook(user.custom_fields['signature_raw'])
      end
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

  DiscourseEvent.on(:user_logged_out) do |user|
    if SiteSetting.post_user_extras_enabled then
      user.custom_fields['user_badges'] = DB.query_single("select '[' || string_agg('{\"id\":\"'|| b.id || '\", \"name\":\"' || b.name || '\", \"image\":\"' || b.image || '\"}', ',') || ']' from user_badges ub inner join badges b on b.id=ub.badge_id where ub.user_id=#{user_id} and b.enabled=true and b.image is not null and system=false").first
      user.save
    end
  end

  DiscourseEvent.on(:user_logged_in) do |user|
    if SiteSetting.post_user_extras_enabled then
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
  def self.get_signature_cooked(signature_cooked)
    return signature_cooked != nil ? signature_cooked : ""
  end

  def self.get_counter_no_smoking(custom_fields)
    counter = ""
    days = count_days(custom_fields['signature_no_smoking'])
    if days != "" then
      text = custom_fields['counter_no_smoking_text'] != nil && custom_fields['counter_no_smoking_text'] != "" ? custom_fields['counter_no_smoking_text'] : "Не курю"
      if custom_fields['counter_no_smoking_img'] == nil || custom_fields['counter_no_smoking_img'] == "" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/nosmoking.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      elsif custom_fields['counter_no_smoking_img'] == "1" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/cigarette.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      elsif custom_fields['counter_no_smoking_img'] == "2" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/no-smoking.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      elsif custom_fields['counter_no_smoking_img'] == "3" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/quit-smoking-1.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      elsif custom_fields['counter_no_smoking_img'] == "4" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/quit-smoking.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      elsif custom_fields['counter_no_smoking_img'] == "5" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/no_smoking3.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      else
        counter = "<div class=\"signature-counter\"><font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      end
    end
    return counter
  end
  
  def self.get_counter_no_drink(custom_fields)
    counter = ""
    days = count_days(custom_fields['signature_no_drink'])
    if days != "" then
      text = custom_fields['counter_no_drink_text'] != nil && custom_fields['counter_no_drink_text'] != "" ? custom_fields['counter_no_drink_text'] : "Не пью"
      if custom_fields['counter_no_drink_img'] == nil || custom_fields['counter_no_drink_img'] == "" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/nodrink.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      elsif custom_fields['counter_no_drink_img'] == "1" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/no-alcohol.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      elsif custom_fields['counter_no_drink_img'] == "2" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/no-drinking.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      elsif custom_fields['counter_no_drink_img'] == "3" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/no-drinks.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      else
        counter = "<div class=\"signature-counter\"><font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      end
    end
    return counter
  end
  
  def self.get_counter_proper_nutrition(custom_fields)
    counter = ""
    days = count_days(custom_fields['signature_proper_nutrition'])
    if days != "" then
      text = custom_fields['counter_proper_nutrition_text'] != nil && custom_fields['counter_proper_nutrition_text'] != "" ? custom_fields['counter_proper_nutrition_text'] : "На ПП"
      if custom_fields['counter_proper_nutrition_img'] == nil || custom_fields['counter_proper_nutrition_img'] == "" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/pp.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      elsif custom_fields['counter_proper_nutrition_img'] == "1" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/diet2.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      elsif custom_fields['counter_proper_nutrition_img'] == "2" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/salad.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      else
        counter = "<div class=\"signature-counter\"><font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      end
    end
    return counter
  end
  
  def self.get_counter_fitnes(custom_fields)
    counter = ""
    days = count_days(custom_fields['signature_fitnes'])
    if days != "" then
      text = custom_fields['counter_fitnes_text'] != nil && custom_fields['counter_fitnes_text'] != "" ? custom_fields['counter_fitnes_text'] : "На спорте"
      if custom_fields['counter_fitnes_img'] == nil || custom_fields['counter_fitnes_img'] == "" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/fit.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      elsif custom_fields['counter_fitnes_img'] == "1" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/strong.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      else
        counter = "<div class=\"signature-counter\"><font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      end
    end
    return counter
  end
  
  def self.get_counter_clear_home(custom_fields)
    counter = ""
    days = count_days(custom_fields['signature_clear_home'])
    if days != "" then
      text = custom_fields['counter_clear_home_text'] != nil && custom_fields['counter_clear_home_text'] != "" ? custom_fields['counter_clear_home_text'] : "В доме чисто"
      if custom_fields['counter_clear_home_img'] == nil || custom_fields['counter_clear_home_img'] == "" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/home.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      elsif custom_fields['counter_clear_home_img'] == "1" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/home2.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      elsif custom_fields['counter_clear_home_img'] == "2" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/house.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      else
        counter = "<div class=\"signature-counter\"><font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      end
    end
    return counter
  end
  
  def self.get_counter_hobby(custom_fields)
    counter = ""
    days = count_days(custom_fields['signature_hobby'])
    if days != "" then
      text = custom_fields['counter_hobby_text'] != nil && custom_fields['counter_hobby_text'] != "" ? custom_fields['counter_hobby_text'] : "С хобби"
      if custom_fields['counter_hobby_img'] == nil || custom_fields['counter_clear_home_img'] == "" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/hobby.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      elsif custom_fields['counter_clear_home_img'] == "1" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/puzzle.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      elsif custom_fields['counter_clear_home_img'] == "2" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/jigsaw.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      elsif custom_fields['counter_clear_home_img'] == "3" then
        counter = "<div class=\"signature-counter\"><img src=\"/plugins/discourse-post-user-extras/images/hiking.png\" title=\"#{text}\" class=\"emoji\" alt=\"#{text}\" /> <font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      else
        counter = "<div class=\"signature-counter\"><font size=\"2\"><em>#{text} #{days}.</em></font></div>"
      end
    end
    return counter
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
        days = time.to_s
        last = days[days.length - 1]
        last2 = days.length > 1 ? days[days.length - 2, 2] : days
        result = days + ' ' + (last == '1' && last2 != '11' ? 'день' : (last == '2' || last == '3' || last == '4') && last2 != '12' && last2 != '13' && last2 != '14' ? 'дня' : 'дней')
      end
    end
    return result
  end

  def self.get_trust_level_title(trust_level)
    return trust_level == 0 ? "новичок" : trust_level == 1 ? "участник" : trust_level == 2 ? "участник +" : trust_level == 3 ? "постоялец" : trust_level == 4 ? "лидер" : ""
  end

  def self.get_trust_level_href(trust_level, name)
    return trust_level == 0 ? ("/u/#{name}/summary") : ("/badges/#{trust_level.to_s}/badge")
  end
end
