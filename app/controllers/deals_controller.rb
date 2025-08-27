class DealsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_deal, only: [:show, :edit, :update, :destroy]

  def index
    # Bad practice: no proper filtering or pagination
    @deals = current_user.deals.all
  end

  def show
    # Bad practice: no proper error handling
  end

  def new
    @deal = Deal.new
    # Bad practice: no proper customer selection
    @customers = current_user.customers.all
  end

  def create
    @deal = current_user.deals.build(deal_params)
    
    # Bad practice: no proper error handling
    if @deal.save
      redirect_to @deal, notice: 'Deal was successfully created.'
    else
      @customers = current_user.customers.all
      render :new
    end
  end

  def edit
    # Bad practice: no proper error handling
    @customers = current_user.customers.all
  end

  def update
    # Bad practice: no proper error handling
    if @deal.update(deal_params)
      redirect_to @deal, notice: 'Deal was successfully updated.'
    else
      @customers = current_user.customers.all
      render :edit
    end
  end

  def destroy
    # Bad practice: no proper error handling
    @deal.destroy
    redirect_to deals_url, notice: 'Deal was successfully destroyed.'
  end

  private

  def set_deal
    # Bad practice: no proper error handling
    @deal = current_user.deals.find(params[:id])
  end

  def deal_params
    # Bad practice: no proper parameter filtering
    params.require(:deal).permit(:title, :amount, :stage, :customer_id, :description)
  end
end
