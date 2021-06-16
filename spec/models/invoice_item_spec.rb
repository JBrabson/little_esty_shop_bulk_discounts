require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end

  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_one(:merchant).through(:item) }
    it { should have_many(:discounts).through(:merchant) }
  end

  describe 'class methods' do
    describe '.incomplete_invoices' do
      it "returns incomplete invoices" do
        merchant1 = Merchant.create!(name: 'Hair Care')
        item_1 = merchant1.items.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10)
        item_2 = merchant1.items.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8)

        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoice_1 = customer_1.invoices.create!(status: 2)
        invoice_2 = customer_1.invoices.create!(status: 2)

        ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 9, unit_price: 10, status: 2, created_at: "2012-03-27 14:54:09")
        ii_2 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 1, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")

        expect(InvoiceItem.incomplete_invoices).to eq([invoice_2])
      end
    end
  end

  describe 'Instance Methods' do
    describe 'Test all discount examples using #discount_applied' do

      it "Example 1: no bulk discounts should be applied." do
        merchant1 = Merchant.create!(name: 'Hair Care')
        item_1 = merchant1.items.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10)
        item_2 = merchant1.items.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8)
        discount_1 = merchant1.discounts.create!(name: "20%", percentage_discount: 20, quantity_threshold: 10 )
        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoice_1 = customer_1.invoices.create!(status: 2)
        ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 5, unit_price: 10, status: 2, created_at: "2012-03-27 14:54:09")
        ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 5, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")

        expect(ii_1.discount_applied).to eq(nil)
        expect(ii_2.discount_applied).to eq(nil)
      end

      it "Example 2: Item A should be discounted at 20% off. Item B should not be discounted." do
        merchant1 = Merchant.create!(name: 'Hair Care')
        item_1 = merchant1.items.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10)
        item_2 = merchant1.items.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8)
        discount_1 = merchant1.discounts.create!(name: "20%", percentage_discount: 20, quantity_threshold: 10 )
        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoice_1 = customer_1.invoices.create!(status: 2)
        ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 10, unit_price: 10, status: 2, created_at: "2012-03-27 14:54:09")
        ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 5, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")

        expect(ii_1.discount_applied).to eq(discount_1)
        expect(ii_2.discount_applied).to eq(nil)
      end

      it "Example 3: Item A should discounted at 20% off, and Item B should discounted at 30% off." do
        merchant1 = Merchant.create!(name: 'Hair Care')
        item_1 = merchant1.items.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10)
        item_2 = merchant1.items.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8)
        discount_1 = merchant1.discounts.create!(name: "20%", percentage_discount: 20, quantity_threshold: 10 )
        discount_2 = merchant1.discounts.create!(name: "30%", percentage_discount: 30, quantity_threshold: 15 )
        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoice_1 = customer_1.invoices.create!(status: 2)
        ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 12, unit_price: 10, status: 2, created_at: "2012-03-27 14:54:09")
        ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 15, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")

        expect(ii_1.discount_applied).to eq(discount_1)
        expect(ii_2.discount_applied).to eq(discount_2)
      end

      it "Exampled 4: Both Item A and Item B should discounted at 20% off. Additionally, there is no scenario where Bulk Discount B can ever be applied." do
        merchant1 = Merchant.create!(name: 'Hair Care')
        item_1 = merchant1.items.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10)
        item_2 = merchant1.items.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8)
        discount_1 = merchant1.discounts.create!(name: "20%", percentage_discount: 20, quantity_threshold: 10 )
        discount_2 = merchant1.discounts.create!(name: "15%", percentage_discount: 15, quantity_threshold: 15 )
        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoice_1 = customer_1.invoices.create!(status: 2)
        ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 12, unit_price: 10, status: 2, created_at: "2012-03-27 14:54:09")
        ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 15, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")

        expect(ii_1.discount_applied).to eq(discount_1)
        expect(ii_2.discount_applied).to eq(discount_1)
      end

      it "Example 5: Item A1 should discounted at 20% off, and Item A2 should be discounted at 30% off. Item B should not be discounted." do
        merchant1 = Merchant.create!(name: 'Hair Care')
        item_1 = merchant1.items.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10)
        item_2 = merchant1.items.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8)
        discount_1 = merchant1.discounts.create!(name: "20%", percentage_discount: 20, quantity_threshold: 10 )
        discount_2 = merchant1.discounts.create!(name: "30%", percentage_discount: 30, quantity_threshold: 15 )
        merchant2 = Merchant.create!(name: 'Random Care...care?')
        item_3 = merchant2.items.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3)
        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoice_1 = customer_1.invoices.create!(status: 2)
        ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 12, unit_price: 10, status: 2, created_at: "2012-03-27 14:54:09")
        ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 15, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")
        ii_3 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_3.id, quantity: 15, unit_price: 10, status: 0, created_at: "2012-03-30 14:54:09")

        expect(ii_1.discount_applied).to eq(discount_1)
        expect(ii_2.discount_applied).to eq(discount_2)
        expect(ii_3.discount_applied).to eq(nil)
      end
    end

    it '#total_revenue' do
      merchant1 = Merchant.create!(name: 'Hair Care')
      item_1 = merchant1.items.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10)
      item_2 = merchant1.items.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8)
      item_3 = merchant1.items.create!(name: "Hot Oil Treatment", description: "Deep conditions hair", unit_price: 8)
      discount_1 = merchant1.discounts.create!(name: "20%", percentage_discount: 20, quantity_threshold: 10 )
      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      invoice_1 = customer_1.invoices.create!(status: 2)
      ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 5, unit_price: 10, status: 2, created_at: "2012-03-27 14:54:09")
      ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 5, unit_price: 8, status: 0, created_at: "2012-03-29 14:54:09")
      ii_3 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_3.id, quantity: 10, unit_price: 8, status: 0, created_at: "2012-03-29 14:54:09")

      expect(ii_1.total_revenue).to eq(50)
      expect(ii_2.total_revenue).to eq(40)
      expect(ii_3.total_revenue).to eq(80)
    end

    it "#discount" do
      merchant1 = Merchant.create!(name: 'Hair Care')
      item_1 = merchant1.items.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10)
      item_2 = merchant1.items.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8)
      item_3 = merchant1.items.create!(name: "Hot Oil Treatment", description: "Deep conditions hair", unit_price: 8)
      discount_1 = merchant1.discounts.create!(name: "20%", percentage_discount: 20, quantity_threshold: 10 )
      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      invoice_1 = customer_1.invoices.create!(status: 2)
      ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 12, unit_price: 10, status: 2, created_at: "2012-03-27 14:54:09")
      ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 15, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")
      ii_3 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_3.id, quantity: 9, unit_price: 8, status: 0, created_at: "2012-03-29 14:54:09")

      expect(ii_1.discount).to eq(24)
      expect(ii_2.discount).to eq(30)
      expect{ii_3.discount}.to raise_error(NoMethodError)
    end

    describe 'final revenue with discount applied and without discount applied' do

      it "#final_revenue with discount" do
        merchant1 = Merchant.create!(name: 'Hair Care')
        item_1 = merchant1.items.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10)
        item_2 = merchant1.items.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8)
        discount_1 = merchant1.discounts.create!(name: "20%", percentage_discount: 20, quantity_threshold: 10 )
        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoice_1 = customer_1.invoices.create!(status: 2)
        ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 12, unit_price: 10, status: 2, created_at: "2012-03-27 14:54:09")
        ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 15, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")

        expect(ii_1.total_revenue).to eq(120)
        expect(ii_1.discount).to eq(24)
        expect(ii_1.final_revenue).to eq(96)
        expect(ii_2.total_revenue).to eq(150)
        expect(ii_2.discount).to eq(30)
        expect(ii_2.final_revenue).to eq(120)
      end

      it "#final_revenue without discount" do
        merchant1 = Merchant.create!(name: 'Hair Care')
        item_1 = merchant1.items.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10)
        item_2 = merchant1.items.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8)
        discount_1 = merchant1.discounts.create!(name: "20%", percentage_discount: 20, quantity_threshold: 15 )
        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoice_1 = customer_1.invoices.create!(status: 2)
        ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 10, unit_price: 10, status: 2, created_at: "2012-03-27 14:54:09")
        ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 12, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")

        expect(ii_1.total_revenue).to eq(100)
        expect{ii_1.discount}.to raise_error(NoMethodError)
        expect(ii_1.final_revenue).to eq(100)
        expect(ii_2.total_revenue).to eq(120)
        expect{ii_2.discount}.to raise_error(NoMethodError)
        expect(ii_2.final_revenue).to eq(120)
      end
    end
  end
end
