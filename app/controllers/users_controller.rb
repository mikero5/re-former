class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def new
    @user = User.new
  end

  def create
    #  @user = User.new(username: params[:username], email: params[:email], password: params[:password])
    @user = User.new(user_params)
    
    if @user.save
      redirect_to new_user_path
    else
      render :new
    end
  end

  def edit
    logger.debug "edit: user: #{@user.inspect}"
  end
  
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    logger.debug "update: user: #{@user.inspect}"
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
    logger.debug "set_user: user: #{@user.inspect}"
  end
    
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  end
