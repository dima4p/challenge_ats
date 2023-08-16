# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  type        :string           not null
#  object_type :string           not null
#  object_id   :integer          not null
#  date        :datetime
#  content     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :event do
    type do
      %w[
        Application::Event::Hired
        Application::Event::Interview
        Application::Event::Note
        Application::Event::Rejected
        Job::Event::Activated
        Job::Event::Deactivated
      ].sample
    end
    association :object, factory: %w[application job].sample.to_sym

    trait :application_hired do
      type {'Application::Event::Hired'}
      date { Time.current - rand(1..200).hours }
    end

    trait :application_interview do
      type {'Application::Event::Interview'}
      date { Time.current - rand(1..200).hours }
    end

    trait :application_note do
      type {'Application::Event::Note'}
      sequence(:content) {|n| "Content#{format '%03d', n}" }
    end

    trait :application_rejected do
      type {'Application::Event::Rejected'}
    end

    trait :job_activated do
      type {'Job::Event::Activated'}
    end

    trait :job_deactivated do
      type {'Job::Event::Deactivated'}
    end
  end
end
