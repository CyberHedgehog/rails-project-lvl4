class CreateRepositoryChecks < ActiveRecord::Migration[6.1]
  def change
    create_table :repository_checks do |t|
      t.string :aasm_state
      t.string :commit
      t.boolean :check_passed
      t.string :result
      t.references :repository

      t.timestamps
    end
  end
end
