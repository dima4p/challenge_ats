# == Schema Information
#
# Table name: jobs
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :job do
    sequence(:title) {|n| "Title#{format '%03d', n}" }
    sequence(:description) {|n| "Description#{format '%03d', n}" }
  end
end
