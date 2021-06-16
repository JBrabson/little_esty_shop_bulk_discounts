Merchant.destroy_all
Discount.destroy_all
Customer.destroy_all
Invoice.destroy_all
InvoiceItem.destroy_all

pupsfluffs = Merchant.create!(name: "Pups, Fluffs & Stuffs")

gas_gone = Item.create!(name: "Doggone Gas Be Gone", description: "Vanquish puppy flatulence before it banishes you.", unit_price: 15, merchant_id: pupsfluffs.id)
cat_nip = Item.create!(name: "Cat Road Trip Nip", description: "Give cat nip a run for its money with this feline road trip nip.", unit_price: 15, merchant_id: pupsfluffs.id)
donkey_doz = Item.create!(name: "Donkey Dozer", description: "Oversized, decor friendly pillow so your ridiculously cute baby donkey can sleep in the house by the fire.", unit_price: 30, merchant_id: pupsfluffs.id)

paws_deal = pupsfluffs.discounts.create!(name: "Pawsitively Pawsome Wags Away 50%", percentage_discount: 50, quantity_threshold: 4)
pur_deal = pupsfluffs.discounts.create!(name: "Purrrfect Pricepoint Pinches 20% Off", percentage_discount: 20, quantity_threshold: 7)
aqua_deal = pupsfluffs.discounts.create!(name: "Nothing Creative Because Fish Make No Noise... 15% Off", percentage_discount: 15, quantity_threshold: 10)
take_money = pupsfluffs.discounts.create!(name: "Take My Money", percentage_discount: 5, quantity_threshold: 50)

jen = Customer.create!(first_name: "Jennifer", last_name: "Mother of Drago Doggos",
    address: "123 More Pets for Me Lane", city: "Arvada", state: "CO", zip: 80003)

invoice1 = jen.invoices.create!(status: 2)

ii1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: gas_gone.id, quantity: 50, unit_price: 15, status: 2)
ii2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: cat_nip.id, quantity: 5, unit_price: 15, status: 2)
ii3 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: donkey_doz.id, quantity: 1, unit_price: 30, status: 2)
