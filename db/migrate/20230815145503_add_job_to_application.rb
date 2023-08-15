class AddJobToApplication < ActiveRecord::Migration[7.0]
  def change
    add_reference :applications, :job, null: false, foreign_key: true
  end
end
