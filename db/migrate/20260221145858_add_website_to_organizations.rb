class AddWebsiteToOrganizations < ActiveRecord::Migration[8.1]
  def change
    add_column :organizations, :website, :string
  end
end
