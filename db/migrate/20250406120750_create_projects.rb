class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.references :tenant, null: false, foreign_key: true
      t.string :name
      t.string :status

      t.timestamps
    end
  end
end
