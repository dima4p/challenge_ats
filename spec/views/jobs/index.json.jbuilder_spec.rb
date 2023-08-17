require 'rails_helper'


describe "jobs/index.json.jbuilder", type: :view do
  let!(:job) { create :job }
  let!(:application1) {create :application, job: job}
  let!(:application2) {create :application, job: job}
  let!(:application3) {create :application, job: job}
  let!(:application4) {create :application, job: job}
  let!(:application5) {create :application, job: job}
  let!(:application6) {create :application, job: job}

  before(:each) do
    assign :jobs, [job, job]
    create :event, :job_activated, object: job
    create :event, :application_hired, object: application1
    create :event, :application_hired, object: application2
    create :event, :application_rejected, object: application3
    create :event, :application_interview, object: application4
    render
  end

  attributes = %w[
    id
    title
    description
    status
    hired_count
    rejected_count
    ongoing_count
    created_at
    updated_at
    url
  ]

  it "renders a list of jobs as json with following attributes: #{attributes.join(', ')}" do
    hash = MultiJson.load rendered
    expect(hash.first).to eq(hash = hash.last)
    expect(hash.keys.sort).to eq attributes.sort
    expected = job.attributes.slice *attributes
    expected = MultiJson.load MultiJson.dump expected
    expected['status'] = 'activated'
    expected['hired_count'] = 2
    expected['rejected_count'] = 1
    expected['ongoing_count'] = 3
    expected['url'] = job_url(job, format: 'json')
    expect(hash).to eq expected
  end
end
