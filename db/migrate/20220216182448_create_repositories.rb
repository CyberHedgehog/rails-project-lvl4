class CreateRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table :repositories do |t|
      t.integer :github_id
      t.string :clone_url
      t.string :name
      t.string :full_name
      t.string :language
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
