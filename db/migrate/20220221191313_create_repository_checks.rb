class CreateRepositoryChecks < ActiveRecord::Migration[6.1]
  def change
    create_table :repository_checks do |t|
      t.string :aasm_state
      t.string :commit
      t.boolean :passed, default: false
      t.string :result
      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
