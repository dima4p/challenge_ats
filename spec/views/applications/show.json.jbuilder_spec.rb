require 'rails_helper'


describe "applications/show.json.jbuilder", type: :view do
  let(:application) { create :application }

  before(:each) do
    assign :application, application
    render
  end

  attributes = %w[
    id
    candidate_name
    created_at
    updated_at
    url
    job_title
  ]

  it "renders the following attributes of application: #{attributes.join(', ')} as json" do
    hash = MultiJson.load rendered
    expect(hash.keys.sort).to eq attributes.sort
    expected = application.attributes.slice *attributes
    expected = MultiJson.load MultiJson.dump expected
    expected['url'] = application_url(application, format: 'json')
    expected['job_title'] = application.job.title
    expect(hash).to eq expected
  end
end
