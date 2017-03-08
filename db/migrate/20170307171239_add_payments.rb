class AddPayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.belongs_to :loan, index: true
      t.decimal :payment_amount, precision: 8, scale: 2, null: false
      t.date :payment_date, null: false
      t.timestamps null: false
    end
  end
end
