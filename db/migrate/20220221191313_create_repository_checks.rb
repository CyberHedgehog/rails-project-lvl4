class CreateRepositoryChecks < ActiveRecord::Migration[6.1]
  def change
    create_table :repository_checks do |t|
      t.string :state
      t.string :reference
      t.boolean :check_passed
      t.string :result

      t.timestamps
    end
  end
end
