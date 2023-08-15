require 'rails_helper'


describe "events/index.json.jbuilder", type: :view do
  let(:event) { create :event }

  before(:each) do
    assign :events, [event, event]
    render
  end

  attributes = %w[
    id
    type
    object_type
    object_id
    date
    content
    created_at
    updated_at
    url
  ]

  it "renders a list of events as json with following attributes: #{attributes.join(', ')}" do
    hash = MultiJson.load rendered
    expect(hash.first).to eq(hash = hash.last)
    expect(hash.keys.sort).to eq attributes.sort
    expected = event.attributes.slice *attributes
    expected = MultiJson.load MultiJson.dump expected
    expected['url'] = event_url(event, format: 'json')
    expect(hash).to eq expected
  end
end
