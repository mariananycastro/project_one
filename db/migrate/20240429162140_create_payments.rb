class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.string :external_id
      t.string :link
      t.integer :status, default:0
      t.decimal :price
      t.references :policy, null: false, foreign_key: true

      t.timestamps
    end
  end
end
