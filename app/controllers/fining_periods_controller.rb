class FiningPeriodsController < ApplicationController

  # GET /fining_periods
  # GET /fining_periods.json
  def index
    @fining_periods = FiningPeriod.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @fining_periods }
    end
  end

  # GET /fining_periods/1
  # GET /fining_periods/1.json
  def show
    @fining_period = FiningPeriod.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @fining_period }
    end
  end

  # GET /fining_periods/new
  # GET /fining_periods/new.json
  def new
    @fining_period = FiningPeriod.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @fining_period }
    end
  end

  # GET /fining_periods/1/edit
  def edit
    @fining_period = FiningPeriod.find(params[:id])
  end

  # POST /fining_periods
  # POST /fining_periods.json
  def create
    @fining_period = FiningPeriod.new(params[:fining_period])

    respond_to do |format|
      if @fining_period.save
        format.html { redirect_to @fining_period, :notice => 'Fining period was successfully created.' }
        format.json { render :json => @fining_period, :status => :created, :location => @fining_period }
      else
        format.html { render :action => "new" }
        format.json { render :json => @fining_period.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /fining_periods/1
  # PUT /fining_periods/1.json
  def update
    @fining_period = FiningPeriod.find(params[:id])

    respond_to do |format|
      if @fining_period.update_attributes(params[:fining_period])
        format.html { redirect_to @fining_period, :notice => 'Fining period was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @fining_period.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /fining_periods/1
  # DELETE /fining_periods/1.json
  def destroy
    @fining_period = FiningPeriod.find(params[:id])
    @fining_period.destroy

    respond_to do |format|
      format.html { redirect_to fining_periods_url }
      format.json { head :ok }
    end
  end
end
