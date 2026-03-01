class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :website
      t.string :privacy_setting, null: false, default: "private"
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :organizations, :name
  end
end
