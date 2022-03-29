class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  has_many :received_transactions,
           class_name: "Transaction",
           inverse_of: :receiver,
           foreign_key: :receiver_id

  has_many :sent_transactions,
           class_name: "Transaction",
           inverse_of: :sender,
           foreign_key: :sender_id

  validates :balance_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  monetize :balance_cents

  def recalculate_balance!
    lock!
    self.balance_cents = received_transactions.sum(:amount_cents) -
                         sent_transactions.sum(:amount_cents)
    save!
  end
end
