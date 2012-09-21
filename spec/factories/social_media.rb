FactoryGirl.define do
  factory :social_media do
    provider "twitter"
    account  "factory_girl"
    provider_id 21
		content "<p>@SpecialFriend I luv Thoughtbot!!!</p>"
		provider_created_datetime Date.today
  end
end