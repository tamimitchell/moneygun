class AddMissingInputFieldsToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :contact_email, :string
    add_column :projects, :website_url, :string
    add_column :projects, :phone_number, :string
    add_column :projects, :start_time, :time
    add_column :projects, :completion_percentage, :integer
    add_column :projects, :color, :string
    add_column :projects, :search_keywords, :string
    add_column :projects, :secret_token, :string
    add_column :projects, :price, :decimal, precision: 10, scale: 2
    add_column :projects, :cost, :decimal, precision: 10, scale: 2
  end
end
