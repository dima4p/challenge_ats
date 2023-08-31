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
    it {is_expected.to have_many(:events).order(id: :asc)}
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

      describe 'with_applications' do
        subject(:with_applications) {Job.with_applications}

        let!(:application1) {create :application, job: job}
        let!(:application2) {create :application, job: job}
        let!(:hired) {create :event, :application_hired, object: application2}

        it 'includes :applications' do
          expect(subject.first.applications_with_state.last.event_type)
              .to eq 'Application::Event::Hired'
        end
      end   # .with_applications

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

        it 'doeds not add sattribute #event_type to Job' do
          expect(subject.last).not_to respond_to :event_type
        end

        it 'doeds not add sattribute #activated to Job' do
          expect(subject.last).not_to respond_to :activated
        end
      end   # .with_last_event

      describe '.with_last_event_type' do
        subject(:with_last_event_type) {Job.with_last_event_type}
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
      end   # .with_last_event_type
    end   # scopes
  end   # class methods

  describe '#applications' do
    subject(:applications) {job.applications}

    let!(:application1) {create :application, job: job}
    let!(:application2) {create :application, job: job}
    let!(:hired) {create :event, :application_hired, object: application2}

    it 'returns the assosiation of Application' do
      is_expected.to eq [application1, application2]
      expect(subject.size).to be 2
    end

    it 'returns the assosiation that accepts :count' do
      expect(subject.count).to eq 2
    end
  end   #applications

  describe '#applications_with_state' do
    subject(:applications_with_state) {job.applications_with_state}

    let!(:application1) {create :application, job: job}
    let!(:application2) {create :application, job: job}
    let!(:hired) {create :event, :application_hired, object: application2}

    it 'returns the assosiation of Application' do
      is_expected.to eq [application1, application2]
      expect(subject.size).to be 2
    end

    it 'returns the assosiation that accepts :count' do
      expect(subject.count(:all)).to eq 2
    end

    describe 'each member of the assosiation' do
      subject(:item) {applications_with_state.last}

      it 'has attribute #event_type' do
        is_expected.to respond_to :event_type
        expect(item.event_type).to eq 'Application::Event::Hired'
      end
    end
  end   #applications_with_state

  describe '#hired_count' do
    subject(:hired_count) {job.hired_count}

    let!(:application1) {create :application, job: job}
    let!(:application2) {create :application, job: job}
    let!(:hired) {create :event, :application_hired, object: application2}

    it 'returns the number of application that were accepted' do
      is_expected.to be 1
    end
  end   #hired_count

  describe '#ongoing_count' do
    subject(:ongoing_count) {job.ongoing_count}

    let!(:application1) {create :application, job: job}
    let!(:application2) {create :application, job: job}
    let!(:application3) {create :application, job: job}
    let!(:hired) {create :event, :application_hired, object: application2}
    let!(:rejected) {create :event, :application_rejected, object: application3}

    it 'returns the number of application that were not accepted nor rejected' do
      is_expected.to be 1
    end
  end   #ongoing_count

  describe '#rejected_count' do
    subject(:rejected_count) {job.rejected_count}

    let!(:application1) {create :application, job: job}
    let!(:application2) {create :application, job: job}
    let!(:rejected) {create :event, :application_rejected, object: application2}

    it 'returns the number of application that were rejected' do
      is_expected.to be 1
    end
  end   #rejected_count

  describe '#status' do
    subject(:status) {job.status}

    context 'if @status is defined' do
      before do
        job.instance_variable_set :@status, 'existing status'
      end

      it 'returns @status' do
        is_expected.to eq 'existing status'
      end
    end

    context 'if @status is not defined' do
      let(:respond_to_result) {true}
      let(:event_type) {}

      before do
        allow(job).to receive(:respond_to?).and_call_original
        allow(job).to receive(:respond_to?).with(:event_type, any_args)
            .and_return respond_to_result
      end

      it 'checks if attribute #event_type is defined' do
        allow(job).to receive(:event_type).and_return event_type
        expect(job).to receive(:respond_to?).with :event_type
        subject
      end

      context 'when job.respond_to? :event_type' do
        before do
          allow(job).to receive(:event_type).and_return event_type
        end

        it 'calls #event_type to use later as @status' do
          expect(job).to receive :event_type
          subject
        end

        it 'does not call #events' do
          expect(job).not_to receive :events
          subject
        end

        context 'when #event_type is blank' do
          it 'assigns "deactivated" to @status' do
            subject
            expect(job.instance_variable_get :@status).to eq 'deactivated'
          end

          it 'returns "deactivated"' do
            is_expected.to eq 'deactivated'
          end
        end
      end

      context 'when job does not respond_to? :event_type' do
        let(:respond_to_result) {false}

        let(:events) {job.events}
        let(:event) {}

        before do
          allow(job).to receive(:events).and_return events
          allow(events).to receive(:last).and_return event
        end

        it 'does not call #event_type to use later as @status' do
          true
        end

        it 'calls #events' do
          expect(job).to receive(:events).and_return events
          subject
        end

        describe 'with the #events' do
          context 'when the assosiation #events is empty' do
            it 'assigns "deactivated" to @status' do
              subject
              expect(job.instance_variable_get :@status).to eq 'deactivated'
            end

            it 'returns "deactivated"' do
              is_expected.to eq 'deactivated'
            end
          end

          context 'when the assosiation #events is present' do
            let(:event) {create :event}

            it 'takes the last one' do
              expect(events).to receive(:last)
              subject
            end

            it 'assigns the last part of the event class downcased to @status' do
              subject
              expect(job.instance_variable_get :@status)
                  .to eq event.type.split('::').last.downcase
            end

            it 'returns the last part of the event class downcased' do
              is_expected.to eq event.type.split('::').last.downcase
            end
          end
        end
      end   # when job does not respond_to? :event_type
    end   # if @status is not defined
  end   #status
end
