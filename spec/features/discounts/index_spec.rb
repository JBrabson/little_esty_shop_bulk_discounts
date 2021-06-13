require 'rails_helper'
RSpec.describe 'Merchant Bulk Discounts Index' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Pup Stuff')
    @discount1 = @merchant1.discounts.create!(name: "15%", percentage_discount: 15, quantity_threshold: 15)
    @discount2 = @merchant1.discounts.create!(name: "20%", percentage_discount: 20, quantity_threshold: 20)
    @discount3 = @merchant1.discounts.create!(name: "25%", percentage_discount: 25, quantity_threshold: 25)
    visit merchant_discounts_path(@merchant1)
  end

  it 'displays all merchant discounts and their attributes' do
    expect(current_path).to eq(merchant_discounts_path(@merchant1))

      within("#discount-#{@discount1.id}") do
        expect(page).to have_content(@discount1.name)
        expect(page).to have_content(@discount1.percentage_discount)
        expect(page).to have_content(@discount1.quantity_threshold)
        expect(page).to_not have_content(@discount2.name)
      end

      within("#discount-#{@discount2.id}") do
        expect(page).to have_content(@discount2.name)
        expect(page).to have_content(@discount2.percentage_discount)
        expect(page).to have_content(@discount2.quantity_threshold)
        expect(page).to_not have_content(@discount3.quantity_threshold)
      end

      within("#discount-#{@discount3.id}") do
        expect(page).to have_content(@discount3.name)
        expect(page).to have_content(@discount3.percentage_discount)
        expect(page).to have_content(@discount3.quantity_threshold)
        expect(page).to_not have_content(@discount2.quantity_threshold)
      end
  end

  it 'displays link to show page for each discount' do
    within("#discount-#{@discount1.id}") do
      expect(page).to have_link("#{@discount1.name} Discount")
    end

    within("#discount-#{@discount2.id}") do
      expect(page).to have_link("#{@discount2.name} Discount")
    end

    within("#discount-#{@discount3.id}") do
      expect(page).to have_link("#{@discount3.name} Discount")
    end
  end
end
