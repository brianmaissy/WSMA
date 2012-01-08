class AssignmentsController < ApplicationController
  before_filter :authenticate, :except => [:login, :logout]
  before_filter :authorize_wsm, :except => [:login, :logout, :show]
  # GET /assignments
  # GET /assignments.json
  def index
    @assignments = Assignment.all
	@users = User.all
	
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @assignments }
    end
  end

  # GET /assignments/1
  # GET /assignments/1.json
  def show
    @assignment = Assignment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @assignment }
    end
  end
  
  # GET /assignments/find/1/1
  # GET /assignments/find/1/1.json
  def find
    @assignment = Assignment.find_by_shift_id_and_user_id(params[:shift_id], params[:user_id])

    respond_to do |format|
      format.json { render :json => @assignment }
    end
  end

  # GET /assignments/new
  # GET /assignments/new.json
  def new
    @assignment = Assignment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @assignment }
    end
  end

  # GET /assignments/1/edit
  def edit
    @assignment = Assignment.find(params[:id])
  end

  # POST /assignments
  # POST /assignments.json
  def create
    @assignment = Assignment.new(params[:assignment])

    respond_to do |format|
      if @assignment.save
        format.html { redirect_to @assignment, :notice => 'Assignment was successfully created.' }
        format.json { render :json => @assignment, :status => :created, :location => @assignment }
      else
        format.html { render :action => "new" }
        format.json { render :json => @assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assignments/1
  # PUT /assignments/1.json
  def update
    @assignment = Assignment.find(params[:id])

    respond_to do |format|
      if @assignment.update_attributes(params[:assignment])
        format.html { redirect_to @assignment, :notice => 'Assignment was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.json
  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy

    respond_to do |format|
      format.html { redirect_to assignments_url }
      format.json { head :ok }
    end
  end

  def quickcreate
    @assignment = Assignment.new
    @user = User.find(session[:user_id])
    @chores = Chore.find_all_by_house_id(@user.house_id)
    @users = User.find_all_by_house_id(@user.house_id)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @assignment }
    end
  end

  def update_assign_menu
   @house = House.find(params[:search][:house])
   @chores = Chore.find_all_by_house_id(@house.id)
   @users = User.find_all_by_house_id(@house.id)
   render :layout => false
  end

  def sign_out

  end
end
