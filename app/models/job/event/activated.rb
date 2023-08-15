# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  type        :string           not null
#  object_type :string           not null
#  object_id   :integer          not null
#  date        :datetime
#  content     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Job::Event::Activated < ::Event

end
