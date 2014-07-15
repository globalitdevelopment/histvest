class UsersController < ApplicationController
  load_and_authorize_resource
  
  before_action :set_user, only: [:destroy, :edit, :show, :update]

  # GET /users
  # GET /users.json
  def index    
    if params[:user_report] && params[:user_report][:descending] == "false"
      @flag = true
    else
      @flag = false
    end  
    @user_report = UserReport.new(params[:user_report])      
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create    
    @user = User.new(params[:user])    
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: I18n.t("users.create_flash") }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    if current_user.admin? and params[:user][:password].blank?
      @user.novalidate = true
    end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: I18n.t("users.update_flash") }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def batch_actions
    user_ids = params["user_ids"].split(",")
    users = User.find(user_ids)
    users.each do |user|
      (params["batch_action"] == "delet") ?
          user.destroy :
          user.update_attribute(:role, params["batch_action"])
    end
    flash[:notice] = "#{users.length} user(s) have been marked as #{params["batch_action"]}" 
    redirect_to users_url
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
