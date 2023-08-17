require 'rails_helper'


describe "applications/show.json.jbuilder", type: :view do
  let(:application) { create :application }
  let(:interview) {create :event, :application_interview, object: application}

  before(:each) do
    assign :application, application
    interview
    create :event, :application_note, object: application
    render
  end

  attributes = %w[
    id
    candidate_name
    job_title
    status
    number_of_notes
    date_of_first_interview
    created_at
    updated_at
    url
  ]

  it "renders the following attributes of application: #{attributes.join(', ')} as json" do
    hash = MultiJson.load rendered
    expect(hash.keys.sort).to eq attributes.sort
    expected = application.attributes.slice *attributes
    expected = MultiJson.load MultiJson.dump expected
    expected['job_title'] = application.job.title
    expected['status'] = 'interview'
    expected['number_of_notes'] = 1
    expected['date_of_first_interview'] = interview.date.to_json.gsub('"', '')
    expected['url'] = application_url(application, format: 'json')
    expect(hash).to eq expected
  end
end
