class UsersController < ApplicationController

  before_filter :authenticate, :except => [:login, :logout]
  before_filter :authorize_admin, :except => [:login, :logout, :show]
  before_filter :authorize_user, :only => :show

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    if not params[:password].to_s.blank?
       @user.password=params[:password]
    end

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, :notice => 'User was successfully created.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if not params[:password].to_s.blank?
      @user.password=params[:password]
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end

  # GET /login
  # POST /login
  def login
    if request.post?
      @user = User.find_by_email(params[:email])
      if @user and @user.password == params[:password]
        session[:user_id] = @user.id
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || { :action => "show", :id => @user.id })
      else
        flash.now[:notice] = "Invalid email/password combination"
      end
    end
  end

  # GET /logout
  def logout
    session[:user_id] = nil
    @logged_user = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "login" )
  end

  # GET /forgot_password
  def forgot_password
    #TODO implement this
  end

  protected

  def authorize_admin
    unless @logged_user.access_level >= 2
      session[:original_uri] = request.url
      flash[:notice] = "Please log in to access administrative area"
      redirect_to :controller => :users, :action => :login
    end
  end

  def authorize_user
    unless @logged_user.access_level >= 2 or (@logged_user.access_level == 1 and params[:id].to_i == @logged_user.id)
      flash[:notice] = "You do not have the privileges to see another user's page"
        redirect_to(:action => "show", :id => @logged_user.id)
    end
  end
end