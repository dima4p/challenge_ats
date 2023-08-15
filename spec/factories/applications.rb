# == Schema Information
#
# Table name: applications
#
#  id             :integer          not null, primary key
#  candidate_name :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  job_id         :integer          not null
#
# Indexes
#
#  index_applications_on_job_id  (job_id)
#
FactoryBot.define do
  factory :application do
    association :job
    sequence(:candidate_name) {|n| "Candidate name#{format '%03d', n}" }
  end
end
