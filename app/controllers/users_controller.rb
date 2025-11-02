class UsersController < ApplicationController
  def index
    @users = current_company.users
  end  
end
