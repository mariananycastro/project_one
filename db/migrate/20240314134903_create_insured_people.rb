class CreateInsuredPeople < ActiveRecord::Migration[7.0]
  def change
    create_table :insured_people do |t|
      t.string :name
      t.string :document

      t.timestamps
    end
  end
end
