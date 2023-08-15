require 'rails_helper'


describe "applications/index.json.jbuilder", type: :view do
  let(:application) { create :application }

  before(:each) do
    assign :applications, [application, application]
    render
  end

  attributes = %w[
    id
    candidate_name
    created_at
    updated_at
    url
  ]

  it "renders a list of applications as json with following attributes: #{attributes.join(', ')}" do
    hash = MultiJson.load rendered
    expect(hash.first).to eq(hash = hash.last)
    expect(hash.keys.sort).to eq attributes.sort
    expected = application.attributes.slice *attributes
    expected = MultiJson.load MultiJson.dump expected
    expected['url'] = application_url(application, format: 'json')
    expect(hash).to eq expected
  end
end
