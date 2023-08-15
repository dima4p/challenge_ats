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
        Application::Event::Inerview
        Application::Event::Note
        Application::Event::Rejected
        Job::Event::Activated
        Job::Event::Deactivated
      ].sample
    end
    association :object, factory: %w[application job].sample.to_sym
    date { Time.current - rand(1..200).hours }
    sequence(:content) {|n| "Content#{format '%03d', n}" }
  end
end
