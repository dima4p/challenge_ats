# == Schema Information
#
# Table name: applications
#
#  id             :integer          not null, primary key
#  candidate_name :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

describe Application, type: :model do

  subject(:application) { create :application }

  describe 'validations' do
    it { is_expected.to be_valid }
    it {is_expected.to validate_presence_of :candidate_name}
  end   # validations

  describe 'class methods' do
    describe 'scopes' do
      describe '.ordered' do
        it 'orders the records of Application by :candidate_name' do
          expect(Application.ordered).to eq Application.order(:candidate_name)
        end
      end   # .ordered
    end   # scopes
  end   # class methods

end
