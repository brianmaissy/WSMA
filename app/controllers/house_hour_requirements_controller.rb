class HouseHourRequirementsController < ApplicationController

  # GET /house_hour_requirements
  # GET /house_hour_requirements.json
  def index
    @house_hour_requirements = HouseHourRequirement.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @house_hour_requirements }
    end
  end

  # GET /house_hour_requirements/1
  # GET /house_hour_requirements/1.json
  def show
    @house_hour_requirement = HouseHourRequirement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @house_hour_requirement }
    end
  end

  # GET /house_hour_requirements/new
  # GET /house_hour_requirements/new.json
  def new
    @house_hour_requirement = HouseHourRequirement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @house_hour_requirement }
    end
  end

  # GET /house_hour_requirements/1/edit
  def edit
    @house_hour_requirement = HouseHourRequirement.find(params[:id])
  end

  # POST /house_hour_requirements
  # POST /house_hour_requirements.json
  def create
    @house_hour_requirement = HouseHourRequirement.new(params[:house_hour_requirement])

    respond_to do |format|
      if @house_hour_requirement.save
        format.html { redirect_to @house_hour_requirement, :notice => 'House hour requirement was successfully created.' }
        format.json { render :json => @house_hour_requirement, :status => :created, :location => @house_hour_requirement }
      else
        format.html { render :action => "new" }
        format.json { render :json => @house_hour_requirement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /house_hour_requirements/1
  # PUT /house_hour_requirements/1.json
  def update
    @house_hour_requirement = HouseHourRequirement.find(params[:id])

    respond_to do |format|
      if @house_hour_requirement.update_attributes(params[:house_hour_requirement])
        format.html { redirect_to @house_hour_requirement, :notice => 'House hour requirement was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @house_hour_requirement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /house_hour_requirements/1
  # DELETE /house_hour_requirements/1.json
  def destroy
    @house_hour_requirement = HouseHourRequirement.find(params[:id])
    @house_hour_requirement.destroy

    respond_to do |format|
      format.html { redirect_to house_hour_requirements_url }
      format.json { head :ok }
    end
  end
end
