require 'rails_helper'


describe "events/show.json.jbuilder", type: :view do
  let(:event) { create :event }

  before(:each) do
    assign :event, event
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

  it "renders the following attributes of event: #{attributes.join(', ')} as json" do
    hash = MultiJson.load rendered
    expect(hash.keys.sort).to eq attributes.sort
    expected = event.attributes.slice *attributes
    expected = MultiJson.load MultiJson.dump expected
    expected['url'] = event_url(event, format: 'json')
    expect(hash).to eq expected
  end
end
