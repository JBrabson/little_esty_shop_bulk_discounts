require 'rails_helper'
RSpec.describe 'Merchant Bulk Discount New' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Pup Stuff')
    visit new_merchant_discount_path(@merchant1)
  end

  it 'after form is completed with valid data and submitted, will redirect to discount index' do
    expect(current_path).to eq(new_merchant_discount_path(@merchant1))
    expect(page).to have_field('Name')
    expect(page).to have_field('Percentage discount')
    expect(page).to have_field('Quantity threshold')

    fill_in 'Name', with: '50%'
    fill_in 'Percentage discount', with: 50
    fill_in 'Quantity threshold', with: 50
    click_on 'Create Discount'

    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    expect(page).to have_content("50%")
  end
end
