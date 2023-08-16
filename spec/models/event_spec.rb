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
require 'rails_helper'

describe Event, type: :model do

  subject(:event) { create :event }

  describe 'validations' do
    it { is_expected.to be_valid }
    it {is_expected.to validate_presence_of :type}
    it {is_expected.to validate_presence_of :object}
    it do
      is_expected.to validate_inclusion_of(:type).in_array(%w[
        Application::Event::Hired
        Application::Event::Interview
        Application::Event::Note
        Application::Event::Rejected
        Job::Event::Activated
        Job::Event::Deactivated
      ])
    end
    it {is_expected.to belong_to :object}
    #it do
      #is_expected.to validate_inclusion_of(:object_type).in_array(%w[
        #Application
        #Job
      #])
    #end
  end   # validations

  describe 'class methods' do
    describe 'scopes' do
      describe '.ordered' do
        it 'orders the records of Event by :type' do
          expect(Event.ordered).to eq Event.order(:type)
        end
      end   # .ordered
    end   # scopes
  end   # class methods

end
