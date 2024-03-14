class AddInsuredPersonRefToPolicy < ActiveRecord::Migration[7.0]
  def change
    add_reference :policies, :insured_person, null: false, foreign_key: true
  end
end
