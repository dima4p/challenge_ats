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
      describe '.aplied' do
        subject(:aplied) {Application.aplied}
        let!(:application) {create :application}
        let!(:application1) {create :application}
        let!(:application2) {create :application}
        let!(:application3) {create :application}

        before do
          create :event, :application_hired, object: application3
          create :event, :application_interview, object: application1
          create :event, :application_rejected, object: application2
          create :event, :application_note, object: application
        end

        it 'returns the Relation with Application' do
          expect(subject.first).to be_an Application
        end

        it 'returns an ActiveRecord::Relation' do
          is_expected.to be_an ActiveRecord::Relation
        end

        it 'returns the applications that do not have events besides Note' do
          is_expected.to eq [application]
        end
      end   # .aplied

      describe '.interview' do
        subject(:interview) {Application.interview}
        let!(:application) {create :application}
        let!(:application1) {create :application}
        let!(:application2) {create :application}
        let!(:application3) {create :application}

        before do
          create :event, :application_hired, object: application3
          create :event, :application_interview, object: application1
          create :event, :application_rejected, object: application2
          create :event, :application_note, object: application1
        end

        it 'returns the Relation with Application' do
          expect(subject.first).to be_an Application
        end

        it 'returns an ActiveRecord::Relation' do
          is_expected.to be_an ActiveRecord::Relation
        end

        it 'returns the applications that do not have events besides Note' do
          is_expected.to eq [application1]
        end
      end   # .interview

      describe '.hired' do
        subject(:hired) {Application.hired}
        let!(:application) {create :application}
        let!(:application1) {create :application}
        let!(:application2) {create :application}
        let!(:application3) {create :application}

        before do
          create :event, :application_hired, object: application3
          create :event, :application_interview, object: application1
          create :event, :application_rejected, object: application2
          create :event, :application_note, object: application3
        end

        it 'returns the Relation with Application' do
          expect(subject.first).to be_an Application
        end

        it 'returns an ActiveRecord::Relation' do
          is_expected.to be_an ActiveRecord::Relation
        end

        it 'returns the applications that do not have events besides Note' do
          is_expected.to eq [application3]
        end
      end   # .hired

      describe '.rejected' do
        subject(:rejected) {Application.rejected}
        let!(:application) {create :application}
        let!(:application1) {create :application}
        let!(:application2) {create :application}
        let!(:application3) {create :application}

        before do
          create :event, :application_hired, object: application3
          create :event, :application_interview, object: application1
          create :event, :application_rejected, object: application2
          create :event, :application_note, object: application2
        end

        it 'returns the Relation with Application' do
          expect(subject.first).to be_an Application
        end

        it 'returns an ActiveRecord::Relation' do
          is_expected.to be_an ActiveRecord::Relation
        end

        it 'returns the applications that do not have events besides Note' do
          is_expected.to eq [application2]
        end
      end   # .rejected

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

      describe '.with_last_event' do
        subject(:with_last_event) {Application.with_last_event}
        let!(:application) {create :application}
        let!(:application1) {create :application}
        let!(:application2) {create :application}
        let!(:application3) {create :application}

        before do
          create :event, :application_hired, object: application3
          create :event, :application_interview, object: application1
          create :event, :application_rejected, object: application2
          create :event, :application_note, object: application2
        end

        it 'returns the Relation with Application' do
          expect(subject.first).to be_an Application
        end

        it 'returns an ActiveRecord::Relation' do
          is_expected.to be_an ActiveRecord::Relation
        end

        it 'adds attribute #event_type to Application' do
          expect(subject.map{|r| [r.candidate_name, r.event_type]})
              .to eq [
                [application.candidate_name, nil],
                [application1.candidate_name, 'Application::Event::Interview'],
                [application2.candidate_name, 'Application::Event::Rejected'],
                [application3.candidate_name, 'Application::Event::Hired'],
              ]
        end
      end   # .with_last_event
    end   # scopes
  end   # class methods

end
