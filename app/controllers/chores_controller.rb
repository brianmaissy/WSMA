class ChoresController < ApplicationController

  before_filter :authenticate, :except => [:login, :logout]
  before_filter :authorize_wsm, :except => [:login, :logout, :show]

  # GET /chores
  # GET /chores.json
  def index
    @chores = Chore.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @chores }
    end
  end

  # GET /chores/1
  # GET /chores/1.json
  def show
    @chore = Chore.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @chore }
    end
  end

  # GET /chores/new
  # GET /chores/new.json
  def new
    @chore = Chore.new
    @chores = Chore.all
    @shift = Shift.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @chore }
    end
  end

  # GET /chores/1/edit
  def edit
    @chore = Chore.find(params[:id])
  end

  # POST /chores
  # POST /chores.json
  def create
    chore_params = params[:chore]
    @user = User.find(session[:user_id])
    chore_params[:house_id] = @user.house_id
    @chore = Chore.new(chore_params)
    @chores = Chore.find_all_by_house_id(@user.house_id)
    @shift = Shift.new
    respond_to do |format|
      if @chore.save

        format.html { redirect_to '/createChore', :notice => 'Chore was successfully created.' }
        format.json { render :json => @chore, :status => :created, :location => @chore }

      else
        format.html { render :action => 'createChore' }
        format.json { render :json => @chore.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /chores/1
  # PUT /chores/1.json
  def update
    @chore = Chore.find(params[:id])

    respond_to do |format|
      if @chore.update_attributes(params[:chore])
        format.html { redirect_to '/createChore', :notice => 'Chore was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @chore.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /chores/1
  # DELETE /chores/1.json
  def destroy
    @chore = Chore.find(params[:id])
    @chore.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :ok }
    end
  end

  def createChore
    @chore = Chore.new
    @user = User.find(session[:user_id])
    @chores = Chore.find_all_by_house_id(@user.house_id)
    @shift = Shift.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @chore }
    end
  end
end
