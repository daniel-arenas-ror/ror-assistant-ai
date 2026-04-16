class OrdersController < ApplicationController
  def index
    @orders = current_company.orders.order(created_at: :desc)
  end
end
