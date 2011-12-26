class UsersController < ApplicationController
  respond_to :html, :json
  # Pages available without login
  public_pages = [:login, :logout, :forgot_password, :reset_password, :find_profile]
  # Pages available to anyone logged in
  authenticated_pages = [:myshift]
  # Pages available only to the logged in user, must take a :id param
  user_pages = [:show, :profile, :change_password]
  # All other pages will only be available to wsms and admins

  before_filter :authenticate, :except => public_pages
  before_filter :authorize_user, :only => user_pages
  before_filter :authorize_wsm, :except => public_pages + authenticated_pages + user_pages

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

  def register
    @email = User.find_by_email(params[:text2])
    @user = User.find_by_name(params[:text1])

    if request.post?
     
	if @email and @user
		flash.now[:notice] = "Valid user, email sent"
          	render :action => :reset_password
	else
		flash.now[:notice] = "User does not exist"
	end
     
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

  # GET /forgot_password
  # POST /forgot_password
  def forgot_password
    if request.post?
      @user = User.find_by_email(params[:email])
      if @user
        if @user.send_reset_password_email
          flash.now[:notice] = "An email has been sent to you with a password reset token. Enter that token here along with a new password."
          render :action => :reset_password
        else
          flash.now[:notice] = "There was an error sending email to #{params[:email]}, please contact your system administrator."
        end
      else
        flash.now[:notice] = "User with email #{params[:email]} not found"
      end
    end
  end

  # GET /1/reset_password
  # POST /1/reset_password
  def reset_password
    if request.post?
      @user = User.find_by_password_reset_token(params[:password_reset_token])
      if params[:password_reset_token].blank? or @user.nil?
        flash.now[:notice] = "Invalid password reset token."
      elsif TimeProvider.now > @user.token_expiration
        flash.now[:notice] = "Password reset token has expired. Click 'Resend Email' to generate a new one."
      elsif params[:new_password] != params[:confirm_new_password]
        flash.now[:notice] = "New passwords do not match."
      else
        @user.password = params[:new_password]
        respond_to do |format|
          if @user.save
            flash[:notice] = 'Password was successfully changed.'
            #manually expire the reset token, we don't want anyone using it again
            @user.token_expiration = TimeProvider.now
            @user.save!
            format.html { redirect_to :action => :login }
          else
            format.html { render :action => :reset_password }
          end
        end
      end
    end
  end

  # GET /1/change_password
  # POST /1/change_password
  def change_password
    @user = User.find(params[:id])
    if request.post?
      if @logged_user.password != params[:current_password]
        flash.now[:notice] = "Incorrect password."
      elsif params[:new_password] != params[:confirm_new_password]
        flash.now[:notice] = "New passwords do not match."
      else
        @user.password = params[:new_password]
        respond_to do |format|
          if @user.save
            flash[:notice] = 'Password was successfully changed.'
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

  def myshift
    @user = User.find(session[:user_id])
    @shifts = Shift.find_all_by_user_id(session[:user_id])
    @assignments = Assignment.find_all_by_user_id(session[:user_id])

    @chores = Chore.find_all_by_house_id(@user.house_id)

    if request.post?
	if params[:assignments] == '0'
		@assign = Assignment.find(params[:assignment_ids])
    		if params[:commit] == "Sign Out"
			@assign.sign_out
			flash.now[:notice] = "Successfully Signed Out"
   		elsif
			@assign.sign_off(params[:user_id]) 
			flash.now[:notice] = "Successfully Signed Off"
		end
	end
    end


    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @shifts }
    end
  end
end
