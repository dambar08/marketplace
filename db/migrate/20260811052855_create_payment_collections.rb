class CreatePaymentCollections < ActiveRecord::Migration[8.1]
  def change
    create_table :payment_collections do |t|
      t.decimal :amount, null: false, precision: 10, scale: 2
      t.decimal :authorized_amount, precision: 10, scale: 2
      t.decimal :captured_amount, precision: 10, scale: 2
      t.decimal :refunded_amount, precision: 10, scale: 2
      t.string :currency_code, null: false
      t.string :status, null: false
      t.datetime :completed_at
      t.timestamps
    end
  end
end
