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
require 'rails_helper'

describe Job, type: :model do

  subject(:job) { create :job }

  describe 'validations' do
    it { is_expected.to be_valid }
    it {is_expected.to validate_presence_of :title}
    it {is_expected.to validate_presence_of :description}
    it {is_expected.to have_many :events}
    it {is_expected.to have_many :applications}
  end   # validations

  describe 'class methods' do
    describe 'scopes' do
      describe '.ordered' do
        it 'orders the records of Job by :title' do
          expect(Job.ordered).to eq Job.order(:title)
        end
      end   # .ordered
    end   # scopes
  end   # class methods

end
