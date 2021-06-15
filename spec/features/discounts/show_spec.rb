require 'rails_helper'
RSpec.describe 'Merchant Bulk Discount Show Page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Pup Stuff')
    @discount1 = @merchant1.discounts.create!(name: "15%", percentage_discount: 15, quantity_threshold: 25)
    @discount2 = @merchant1.discounts.create!(name: "30%", percentage_discount: 30, quantity_threshold: 40)
    @discount3 = @merchant1.discounts.create!(name: "45%", percentage_discount: 45, quantity_threshold: 55)
    #how to specifically search for integer vs just number as string asserts all three is nubmer is same
    visit merchant_discount_path(@merchant1, @discount1)
  end

  it 'displays discount quantity threshold and percentage discount for this discount' do
    expect(page).to have_content(@discount1.quantity_threshold)
    expect(page).to have_content(@discount1.percentage_discount)
    expect(page).to_not have_content(@discount2.quantity_threshold)
    expect(page).to_not have_content(@discount2.percentage_discount)
    expect(page).to_not have_content(@discount3.quantity_threshold)
    expect(page).to_not have_content(@discount3.percentage_discount)
  end
end
