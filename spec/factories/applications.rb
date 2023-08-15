# == Schema Information
#
# Table name: applications
#
#  id             :integer          not null, primary key
#  candidate_name :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :application do
    sequence(:candidate_name) {|n| "Candidate name#{format '%03d', n}" }
  end
end
