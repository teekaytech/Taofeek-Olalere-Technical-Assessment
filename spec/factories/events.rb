FactoryBot.define do
  factory :event do
    user
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    status { Event.statuses.keys.sample }
    category { Event.categories.keys.sample }
    start_date { Faker::Date.between(from: 2.days.from_now, to: 5.days.from_now) }
    end_date { Faker::Date.between(from: 6.days.from_now, to: 10.days.from_now) }
  end
end
