require 'rails_helper'


describe "jobs/show.json.jbuilder", type: :view do
  let(:job) { create :job }

  before(:each) do
    assign :job, job
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

  it "renders the following attributes of job: #{attributes.join(', ')} as json" do
    hash = MultiJson.load rendered
    expect(hash.keys.sort).to eq attributes.sort
    expected = job.attributes.slice *attributes
    expected = MultiJson.load MultiJson.dump expected
    expected['status'] = 'deactivated'
    expected['hired_count'] = 0
    expected['rejected_count'] = 0
    expected['ongoing_count'] = 0
    expected['url'] = job_url(job, format: 'json')
    expect(hash).to eq expected
  end
end
