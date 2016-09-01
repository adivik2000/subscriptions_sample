class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.subscribe(customer: {:first_name => params[:user][:name], :email => params[:user][:email]})

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, success: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def cancel_subscription
    @user = User.find_by(chargebee_id: params[:id])    
    @user.subscription.cancel({ end_of_term: params[:end_of_term] })
    redirect_to customers_path
  end
  
  def change_subscription
    @user = User.find(params[:customer][:id])
    @user.update_subscription(plan_id: params[:plan_id], coupon: params[:coupon_id])
    redirect_to customers_path
  end
  
  
  
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email)
    end
  
end
