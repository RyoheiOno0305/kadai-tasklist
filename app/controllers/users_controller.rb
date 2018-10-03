class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show]
  before_action :correct_user, only: [ :show ,:edit, :update,  :destroy]
  
  include SessionsHelper
  
  
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def block
    @user = User.find(params[:user_id])
    if current_user == @user
      return
    else
      redirect_to root_url
    end 
  end
  
  def correct_user
    @user = User.find_by(id: params[:id])
    unless current_user == @user
      redirect_to root_url
    end
  end
  
end
