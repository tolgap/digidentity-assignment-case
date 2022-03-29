class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :amount_cents, unsigned: true, nullable: false, default: 0
      t.string :currency, nullable: false

      t.string :transaction_type, nullable: false, index: true

      t.references :receiver, nullable: false, foreign_key: { to_table: :customers }
      t.references :sender, foreign_key: { to_table: :customers }

      t.timestamps
    end
  end
end
