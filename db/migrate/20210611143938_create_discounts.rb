class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.string :name
      t.integer :percentage_discount
      t.integer :quantity_threshold
      t.string :merchant_references

      t.timestamps
    end
  end
end
