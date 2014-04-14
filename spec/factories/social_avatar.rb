FactoryGirl.define do
  factory :social_avatar do
    provider "twitter"
    account  "superman"
    provider_id 21
    avatar_url "http://my_url.com/image.png"
  end
end