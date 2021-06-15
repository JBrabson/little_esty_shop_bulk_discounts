class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :discounts, through: :merchant

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def discount_applied
    discounts
    .where('quantity_threshold <= ?', quantity)
    .order(percentage_discount: :desc)
    .first
  end

  def total_revenue
    (quantity * unit_price)
  end

  def discount
    (total_revenue * discount_applied.percentage_discount / 100)
  end

  def final_revenue
    if discount_applied == nil
      total_revenue
    else
      total_revenue - discount
    end
  end
end
