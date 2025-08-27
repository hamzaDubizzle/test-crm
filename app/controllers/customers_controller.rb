class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # Bad practice: no proper error handling
  def index
    @customers = current_user.customers.all
  end

  def show
    # Bad practice: no proper error handling
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = current_user.customers.build(customer_params)
    
    # Bad practice: no proper error handling
    if @customer.save
      redirect_to @customer, notice: 'Customer was successfully created.'
    else
      render :new
    end
  end

  def edit
    # Bad practice: no proper error handling
  end

  def update
    # Bad practice: no proper error handling
    if @customer.update(customer_params)
      redirect_to @customer, notice: 'Customer was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    # Bad practice: no proper error handling
    @customer.destroy
    redirect_to customers_url, notice: 'Customer was successfully destroyed.'
  end

  private

  def set_customer
    # Bad practice: no proper error handling
    @customer = current_user.customers.find(params[:id])
  end

  def customer_params
    # Bad practice: no proper parameter filtering
    params.require(:customer).permit(:name, :email, :phone, :company, :status)
  end
end
