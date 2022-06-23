class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :load_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update)

  def show
    @pagy, @microposts = pagy(@user.microposts.all,
                              items: Settings.paging.posts_per_page)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".create_noti"
      redirect_to @user
    else
      flash[:danger] = t ".create_failed"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t ".update_successed"
      redirect_to @user
    else
      flash[:danger] = t ".update_failed"
      render :edit
    end
  end

  def index
    @pagy, @users = pagy(User.all)
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".delete_successed"
      redirect_to users_path
    else
      flash[:danger] = t ".delete_failed"
      render users_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email,
                                 :password, :password_confirmation)
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".login_required"
    redirect_to login_url
  end

  def correct_user
    redirect_to(root_path) unless @user == current_user
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t(".find_failed")
    redirect_to root_path
  end
end
