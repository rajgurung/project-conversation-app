class AddStatusChangeFieldsToComments < ActiveRecord::Migration[8.0]
  def change
    add_column :comments, :from_status, :string
    add_column :comments, :to_status, :string
    add_column :comments, :reason, :text
  end
end
