class OrdersController < ApplicationController
  def index
    @orders = current_company.orders.includes(:lead).order(created_at: :desc)
  end
end
