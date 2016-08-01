FactoryGirl.define do
  factory :push_notification_token do
    
  end
  factory :push_notification_ do
    
  end
  sequence :name do |n|
    "topic#{n}"
  end

  factory :topic do
    name { generate :name }
  end

  factory :user do
    first_name "abjkjc"
    last_name "defji"
    sequence(:email) { |n| "aafbb#{n}@hh.de" }
    password "111111"
    password_confirmation "111111"
    verified_at Time.current - 1.week
    credit_balance 5
  end

  factory :question do
    sequence(:title) { |n| "sample title #{n}"}
    content "sample content for question."
    published true
    published_at Time.now
    user
  end

  factory :commentable, parent: :question do
  end

  factory :comment do
    comment "Sample comment"
    user
    commentable
  end

  factory :vote do
    upvote true
    user
    votable
  end

  factory :votable, parent: :comment do
  end

  factory :invalid_user, parent: :user do
    password "ds"
  end

  factory :user_with_topic, parent: :user do
    after(:build) do |user|
      user.topics << create(:topic)
    end
  end

end
