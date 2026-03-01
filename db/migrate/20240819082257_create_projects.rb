class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.references :organization, null: false, foreign_key: true
      t.text :description
      t.string :status, default: "planning"
      t.string :priority, default: "medium"
      t.string :category
      t.string :color
      t.integer :completion_percentage
      t.boolean :is_active, default: true
      t.date :start_date
      t.date :due_date
      t.time :start_time
      t.datetime :scheduled_at
      t.decimal :price, precision: 10, scale: 2
      t.decimal :cost, precision: 10, scale: 2
      t.decimal :budget, precision: 10, scale: 2
      t.string :contact_email
      t.string :phone_number
      t.string :website_url
      t.string :secret_token
      t.string :search_keywords
      t.text :tags, array: true, default: []

      t.timestamps
    end

    add_index :projects, [:name, :organization_id], unique: true
  end
end
