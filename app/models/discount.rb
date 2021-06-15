class Discount < ApplicationRecord
  validates :name, :percentage_discount, :quantity_threshold, presence: true
  validates :percentage_discount, :quantity_threshold, numericality: true

  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items

end
