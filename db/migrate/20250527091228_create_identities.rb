class CreateIdentities < ActiveRecord::Migration[8.0]
  def change
    create_table :identities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :access_token
      t.string :refresh_token
      t.datetime :expires_at
      t.datetime :refresh_token_invalidated_at
      t.jsonb :payload

      t.timestamps
    end

    add_index :identities, [:uid, :provider], unique: true
    add_index :identities, :refresh_token_invalidated_at
  end
end
