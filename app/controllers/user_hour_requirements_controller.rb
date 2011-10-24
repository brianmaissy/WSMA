class UserHourRequirementsController < ApplicationController

  # GET /user_hour_requirements
  # GET /user_hour_requirements.json
  def index
    @user_hour_requirements = UserHourRequirement.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @user_hour_requirements }
    end
  end

  # GET /user_hour_requirements/1
  # GET /user_hour_requirements/1.json
  def show
    @user_hour_requirement = UserHourRequirement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user_hour_requirement }
    end
  end

  # GET /user_hour_requirements/new
  # GET /user_hour_requirements/new.json
  def new
    @user_hour_requirement = UserHourRequirement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user_hour_requirement }
    end
  end

  # GET /user_hour_requirements/1/edit
  def edit
    @user_hour_requirement = UserHourRequirement.find(params[:id])
  end

  # POST /user_hour_requirements
  # POST /user_hour_requirements.json
  def create
    @user_hour_requirement = UserHourRequirement.new(params[:user_hour_requirement])

    respond_to do |format|
      if @user_hour_requirement.save
        format.html { redirect_to @user_hour_requirement, :notice => 'User hour requirement was successfully created.' }
        format.json { render :json => @user_hour_requirement, :status => :created, :location => @user_hour_requirement }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user_hour_requirement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_hour_requirements/1
  # PUT /user_hour_requirements/1.json
  def update
    @user_hour_requirement = UserHourRequirement.find(params[:id])

    respond_to do |format|
      if @user_hour_requirement.update_attributes(params[:user_hour_requirement])
        format.html { redirect_to @user_hour_requirement, :notice => 'User hour requirement was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user_hour_requirement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_hour_requirements/1
  # DELETE /user_hour_requirements/1.json
  def destroy
    @user_hour_requirement = UserHourRequirement.find(params[:id])
    @user_hour_requirement.destroy

    respond_to do |format|
      format.html { redirect_to user_hour_requirements_url }
      format.json { head :ok }
    end
  end
end
