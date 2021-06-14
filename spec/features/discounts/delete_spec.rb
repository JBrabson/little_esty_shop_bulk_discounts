require 'rails_helper'
RSpec.describe 'Merchant Bulk Discounts Index' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Pup Stuff')
    @discount1 = @merchant1.discounts.create!(name: "15%", percentage_discount: 15, quantity_threshold: 15)
    @discount2 = @merchant1.discounts.create!(name: "20%", percentage_discount: 20, quantity_threshold: 20)
    @discount3 = @merchant1.discounts.create!(name: "25%", percentage_discount: 25, quantity_threshold: 25)
    visit merchant_discounts_path(@merchant1)
  end

  describe 'Merchant Bulk Discount Delete' do
    it 'when clicked, will be redirected to discounts index where discount is no longer listed' do
      within("#discount-#{@discount1.id}") do
        click_link "Delete #{@discount1.name} Discount"
        expect(current_path).to eq(merchant_discounts_path(@merchant1))
        expect(page).to_not have_content(@discount1.name)
        expect(page).to have_content(@discount2.name)
        expect(page).to have_content(@discount3.name)
      end

      within("#discount-#{@discount2.id}") do
        click_link "Delete #{@discount2.name} Discount"
        expect(current_path).to eq(merchant_discounts_path(@merchant1))
        expect(page).to_not have_content(@discount2.name)
        expect(page).to have_content(@discount1.name)
        expect(page).to have_content(@discount3.name)
      end

      within("#discount-#{@discount3.id}") do
        click_link "Delete #{@discount3.name} Discount"
        expect(current_path).to eq(merchant_discounts_path(@merchant1))
        expect(page).to_not have_content(@discount3.name)
        expect(page).to have_content(@discount1.name)
        expect(page).to have_content(@discount2.name)
      end
    end
  end
end
