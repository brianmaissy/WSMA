class UsersController < ApplicationController

  before_filter :authenticate, :except => [:login, :logout]
  before_filter :authorize_wsm, :except => [:login, :logout, :show, :myshift, :profile, :change_password]
  before_filter :authorize_user, :only => [:show, :change_password, :profile]

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
  
  # GET /users/find_by_name/a
  # GET /users/find_by_name/a.json
  def find_by_name
    @user = User.find_by_name(params[:name])

    respond_to do |format|
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
        redirect_to(uri || {:controller => :users, :action => :profile, :id => @user.to_param})
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

  # GET /user/profile
  def find_profile
    if @logged_user
      redirect_to({:controller => :users, :action => :profile, :id => @logged_user.to_param})
    else
      redirect_to_login
    end
  end

  # GET /1/profile
  def profile
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /1/forgot_password
  # POST /1/forgot_password
  def forgot_password
    #TODO implement this (iteration 3)
  end

  # GET /1/change_password
  # POST /1/change_password
  def change_password
    @user = User.find(params[:id])
    if request.post?
      if @logged_user.password != params[:current_password]
        flash[:notice] = "Incorrect password."
      elsif params[:new_password] != params[:confirm_new_password]
        flash[:notice] = "New passwords do not match."
      else
        @user.password = params[:new_password]
        respond_to do |format|
          if @user.save
            flash[:notice] = 'Password was successfully updated.'
            format.html { redirect_to :action => :profile }
          else
            format.html { render :action => :change_password }
          end
        end
      end
    end
  end

  # Get /manage
  def manage
    @user = User.find(session[:user_id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

 def complete

 end 

  def myshift
    @user = User.find(session[:user_id])
    @shifts = Shift.find_all_by_user_id(session[:user_id])
    @assignments = Assignment.find_all_by_user_id(session[:user_id])

    @chores = Chore.find_all_by_house_id(@user.house_id)
    @data = params[:assignment_ids]

    if params[:commit] == "Sign Out"
       @data.each do |datum|
		if datum == 1
    else
       # do something else
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @shifts }
    end
  end
end