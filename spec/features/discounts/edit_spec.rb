require 'rails_helper'
RSpec.describe 'Merchant Bulk Discount Edit' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Pup Stuff')
    @discount1 = @merchant1.discounts.create!(name: "15%", percentage_discount: 15, quantity_threshold: 25)
    visit edit_merchant_discount_path(@merchant1, @discount1)
  end

  it 'I can edit this discount using the form pre-populated with this discounts information' do
    expect(current_path).to eq(edit_merchant_discount_path(@merchant1, @discount1))
    expect(page).to have_field('Name', with: "15%")
    expect(page).to have_field('Percentage discount', with: 15)
    expect(page).to have_field('Quantity threshold', with: 25)
    expect(page).to have_button('Update Discount')

    fill_in 'Name', with: '20%'
    fill_in 'Percentage discount', with: 20
    fill_in 'Quantity threshold', with: 10
    click_on 'Update Discount'

    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount1))
    expect(page).to have_content("20%")
  end
end
