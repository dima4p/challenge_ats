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
require 'rails_helper'

describe Application, type: :model do

  subject(:application) { create :application }

  describe 'validations' do
    it { is_expected.to be_valid }
    it {is_expected.to validate_presence_of :candidate_name}
    it {is_expected.to have_many(:events).order(created_at: :asc)}
    it {is_expected.to belong_to :job}
  end   # validations

  describe 'class methods' do
    describe 'scopes' do
      describe '.ordered' do
        it 'orders the records of Application by :candidate_name' do
          expect(Application.ordered).to eq Application.order(:candidate_name)
        end
      end   # .ordered

      describe '.with_job' do
        it 'includes :job' do
          expect(Application.with_job).to eq Application.includes :job
        end
      end
    end   # scopes
  end   # class methods

end
