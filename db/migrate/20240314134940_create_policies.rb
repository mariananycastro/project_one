class CreatePolicies < ActiveRecord::Migration[7.0]
  def change
    create_table :policies do |t|
      t.date :effective_from
      t.date :effective_until

      t.timestamps
    end
  end
end
