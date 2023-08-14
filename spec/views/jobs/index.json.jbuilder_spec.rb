require 'rails_helper'


describe "jobs/index.json.jbuilder", type: :view do
  let(:job) { create :job }

  before(:each) do
    assign :jobs, [job, job]
    render
  end

  attributes = %w[
    id
    title
    description
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
    expected['url'] = job_url(job, format: 'json')
    expect(hash).to eq expected
  end
end
