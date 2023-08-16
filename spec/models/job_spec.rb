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
    it {is_expected.to have_many(:events).order(created_at: :asc)}
    it {is_expected.to have_many :applications}
  end   # validations

  describe 'class methods' do
    describe 'scopes' do
      describe '.activated' do
        subject(:activated) {Job.activated}
        let!(:job) {create :job}
        let!(:job1) {create :job}
        let!(:job2) {create :job}

        before do
          create :event, :job_activated, object: job
          create :event, :job_activated, object: job1
          create :event, :job_deactivated, object: job1
        end

        it 'returns only activated Jobs' do
          is_expected.to eq [job]
        end
      end   # .activated

      describe '.ordered' do
        it 'orders the records of Job by :title' do
          expect(Job.ordered).to eq Job.order(:title)
        end
      end   # .ordered

      describe '.with_last_event' do
        subject(:with_last_event) {Job.with_last_event}
        let!(:job) {create :job}
        let!(:job1) {create :job}
        let!(:job2) {create :job}

        before do
          create :event, :job_activated, object: job
          create :event, :job_activated, object: job1
          create :event, :job_deactivated, object: job1
        end

        it 'returns the Relation with Job' do
          expect(subject.first).to eq job
        end

        it 'returns an ActiveRecord::Relation' do
          is_expected.to be_an ActiveRecord::Relation
        end

        it 'adds attributes #event_type and #activated to Job' do
          expect(subject.map{|r| [r.title, r.event_type, r.activated.to_bool]})
              .to eq [[job.title, 'Job::Event::Activated', true],
                      [job1.title, 'Job::Event::Deactivated', false],
                      [job2.title, nil, false]]
        end
      end   # .with_last_event
    end   # scopes
  end   # class methods

end
