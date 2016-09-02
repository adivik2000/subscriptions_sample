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
  
  def show
    @user = User.find(params[:id])
  end
  
  
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email)
    end
  
end
