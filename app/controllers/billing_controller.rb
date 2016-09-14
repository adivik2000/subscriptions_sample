class BillingController < ApplicationController
  def show
    @user = User.find(params[:id])
    @subscriber = @customer.as_chargebee_customer
  end

  
  def cancel_subscription
    @user = User.find_by(chargebee_id: params[:id])    
    @user.subscription.cancel({ end_of_term: params[:end_of_term] })
    redirect_to customers_path
  end
  
  def change_subscription
    @user = User.find(params[:id])
    @user.update_subscription(plan_id: params[:plan_id], coupon: params[:coupon_id])
    redirect_to customers_path
  end
  
  def add_card
    @user = User.find(params[:id])
    result = ChargeBee::Card.update_card_for_customer(@user.chargebee_id, {
      :gateway => "chargebee", 
      :first_name => "Richard", 
      :last_name => "Fox", 
      :number => "4012888888881881", 
      :expiry_month => 10, 
      :expiry_year => 2022, 
      :cvv => "999"
    })
    @user = result.customer
  end
  
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email)
    end
    
end
