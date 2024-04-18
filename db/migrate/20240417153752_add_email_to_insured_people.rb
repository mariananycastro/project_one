class AddEmailToInsuredPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :insured_people, :email, :string
  end
end
