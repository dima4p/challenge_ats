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
    it {is_expected.to have_many(:notes).order(created_at: :asc)}
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

      describe '.for_active_jobs' do
        subject(:for_active_jobs) {Application.for_active_jobs}

        let!(:application) {create :application}
        let!(:application1) {create :application}
        let!(:application2) {create :application}

        before do
          create :event, :job_activated, object: application.job
          create :event, :job_deactivated, object: application2.job
        end

        it 'returns an ActiveRecord::Relation' do
          is_expected.to be_an ActiveRecord::Relation
        end

        it 'returns the Relation with Application' do
          expect(subject.first).to be_an Application
        end

        it 'returns the applications those #job is activated' do
          is_expected.to eq [application]
        end
      end   # .for_active_jobs

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

      describe '.with_notes' do
        it 'includes :job' do
          expect(Application.with_notes).to eq Application.includes :notes
        end
      end
    end   # scopes
  end   # class methods

  describe '#interviews' do
    subject(:interviews) {application.interviews}

    let!(:interview1) {create :event, :application_interview, object: application}
    let!(:interview2) {create :event, :application_interview, object: application}

    it 'returns an ActiveRecord::Relation' do
      is_expected.to be_an ActiveRecord::Relation
    end

    it 'returns the Relation with Events' do
      expect(subject.first).to be_an Event
    end

    it 'returns all events of type Application::Event::Interview' do
      is_expected.to eq [Application::Event::Interview.find(interview1.id),
                         Application::Event::Interview.find(interview2.id)]
                        .sort_by &:date
      expect(interviews.count).to be 2
    end
  end

  describe '#notes' do
    subject(:notes) {application.notes}

    let!(:note1) {create :event, :application_note, object: application}
    let!(:note2) {create :event, :application_note, object: application}

    before do
      create :event, :application_interview, object: application
      create :event, :application_hired, object: application
    end

    it 'returns an ActiveRecord::Relation' do
      is_expected.to be_an ActiveRecord::Relation
    end

    it 'returns the Relation with Events' do
      expect(subject.first).to be_an Event
    end

    it 'returns all events of type Application::Event::Note' do
      is_expected.to eq [Application::Event::Note.find(note1.id),
                         Application::Event::Note.find(note2.id)]
      expect(notes.count).to be 2
    end
  end

  describe '#status' do
    subject(:status) {application.status}

    context 'if @status is defined' do
      before do
        application.instance_variable_set :@status, 'existing status'
      end

      it 'returns @status' do
        is_expected.to eq 'existing status'
      end
    end

    context 'if @status is not defined' do
      let(:respond_to_result) {true}
      let(:event_type) {}

      before do
        allow(application).to receive(:respond_to?).and_call_original
        allow(application).to receive(:respond_to?).with(:event_type, any_args)
            .and_return respond_to_result
      end

      it 'checks if attribute #event_type is defined' do
        allow(application).to receive(:event_type).and_return event_type
        expect(application).to receive(:respond_to?).with :event_type
        subject
      end

      context 'when application.respond_to? :event_type' do
        before do
          allow(application).to receive(:event_type).and_return event_type
        end

        it 'calls #event_type to use later as @status' do
          expect(application).to receive :event_type
          subject
        end

        it 'does not call #events' do
          expect(application).not_to receive :events
          subject
        end

        context 'when #event_type is blank' do
          it 'assigns "applied" to @status' do
            subject
            expect(application.instance_variable_get :@status).to eq 'applied'
          end

          it 'returns "applied"' do
            is_expected.to eq 'applied'
          end
        end
      end

      context 'when application does not respond_to? :event_type' do
        let(:respond_to_result) {false}

        let(:events) {application.events}
        let(:events_where) {events.where}
        let(:events_where_not) {events_where.not type: 'type'}
        let(:event) {}

        before do
          allow(application).to receive(:events).and_return events
          allow(events).to receive(:where).and_return events_where
          allow(events_where).to receive(:not).and_return events_where_not
          allow(events_where_not).to receive(:last).and_return event
        end

        it 'does not call #event_type to use later as @status' do
          true
        end

        it 'calls #events' do
          expect(application).to receive(:events).and_return events
          subject
        end

        describe 'with the #events' do
          it 'excluedes all events of type "Application::Event::Note"' do
            expect(events).to receive(:where).and_return events_where
            expect(events_where).to receive(:not)
                .with(type: 'Application::Event::Note')
                .and_return events_where_not
            subject
          end

          context 'when the resuling assosiation is empty' do
            it 'assigns "applied" to @status' do
              subject
              expect(application.instance_variable_get :@status).to eq 'applied'
            end

            it 'returns "applied"' do
              is_expected.to eq 'applied'
            end
          end

          context 'when the resuling assosiation is present' do
            let(:event) {create :event}

            it 'takes the last one' do
              expect(events_where_not).to receive(:last)
              subject
            end

            it 'assigns the last part of the event class downcased to @status' do
              subject
              expect(application.instance_variable_get :@status)
                  .to eq event.type.split('::').last.downcase
            end

            it 'returns the last part of the event class downcased' do
              is_expected.to eq event.type.split('::').last.downcase
            end
          end
        end
      end
    end
  end   #status
end
