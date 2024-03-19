class ChangeInsuredPerson < ActiveRecord::Migration[7.0]
  def change
    add_index :insured_people, :document, unique: true
  end
end
