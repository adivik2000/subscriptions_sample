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
        log_in @user
        format.html { redirect_to @user, success: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def show
    @user = User.find(params[:id])
    @subscriber = @user.as_chargebee_customer
  end
  
  def activate_subscription
    hosted_page = ChargeBee::HostedPage.retrieve(params[:hosted_page_id]).hosted_page
    @user = User.find_by(chargebee_id: hosted_page.content.customer.id)
    @user.update_subscription_via_hosted_page(hosted_page)
    redirect_to users_path
  end
  
  def hosted_page_checkout_existing
    @user = User.find(params[:id])
    hosted_page = ChargeBee::HostedPage.checkout_existing(
      subscription: { id: @user.subscription.chargebee_id, plan_id: @user.subscription.plan.plan_id, trial_end: 0 },
      card: {gateway: "chargebee"},
      embed: true,
      iframe_messaging: true 
    ).hosted_page
    render json: {
      url: hosted_page.url,
      hosted_page_id: hosted_page.id,
      site_name: ENV["CHARGEBEE_SITE"]
    }
  end
  
  def invoice_pdf
    @pdf = ChargeBee::Invoice.pdf(params[:id])
    data = open(@pdf.download.download_url) 
    send_data data.read, 
              filename: "NAME YOU WANT.pdf",
              type: "application/pdf",
              disposition: 'inline',
              stream: 'true',
              buffer_size: '4096'
  end
  
  def checkout_existing
    @user = User.find(params[:id])
    @subscriber = @user.as_chargebee_customer
    tmp_token = params[:payment_gateway] == "stripe" ? params[:stripeToken] : params[:braintreeToken]
    @user.update_subscription(card: { gateway: params[:payment_gateway], tmp_token: tmp_token })
    render json: {success: true, forward: request.base_url+users_path}
  end
  
  def cancel_subscription
    @user = User.find_by(chargebee_id: params[:id])    
    @user.subscription.cancel({ end_of_term: params[:end_of_term] })
    redirect_to root_path
  end

  def add_plan
    @user = User.find(params[:id])
    @subscriber = @user.as_chargebee_customer
    @coupon_list = ChargeBee::Coupon.list(status: 'active')
    subscription = @user.subscription.as_chargebee_subscription
    @coupons = subscription.coupons if subscription.present? && subscription.coupons.present?
  end

  def estimation
    @user = User.find(params[:customer_id])
    estimate = Subscription.estimate_changes(
      subscription: { 
        id: @user.subscription.chargebee_id, 
        plan_id: params[:plan_id], 
        coupon_id: params[:coupon_id]
    })
    render json: { subscription_estimate: estimate.subscription_estimate, invoice_estimate: estimate.invoice_estimate, next_invoice_estimate: estimate.next_invoice_estimate }
  end
  
  def change_subscription
    @user = User.find(params[:user][:id])
    @user.update_subscription(plan_id: params[:plan_id], coupon: params[:coupon_id])
    redirect_to users_path
  end
  
  def reactivate_subscription
    @user = User.find_by(chargebee_id: params[:id])
    ChargeBee::Subscription.reactivate(@user.chargebee_id)
    redirect_to users_path
  end
  
  
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email)
    end
  
end
