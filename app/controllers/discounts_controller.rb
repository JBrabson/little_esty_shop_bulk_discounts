class DiscountsController < ApplicationController
  before_action :search_merchant_and_discount, only: [:show, :edit, :update]
  before_action :search_merchant, except: [:show, :edit, :update, :destroy]

  def index
    @discounts = Discount.all
    @upcoming_holidays = UpcomingHoliday.new.upcoming_holidays
  end

  def show
  end


  def new
  end

  def edit
  end

  def update
  end

  def create
    @discount = @merchant.discounts.new(discount_params)
    @discount.save!

    redirect_to merchant_discounts_path(@merchant)
  end

  private
  def discount_params
    params.permit(:name, :percentage_discount, :quantity_threshold)
  end

  def search_merchant_and_discount
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.find(params[:id])
  end

  def search_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end