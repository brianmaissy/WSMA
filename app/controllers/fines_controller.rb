class FinesController < ApplicationController
  layout 'scaffold'

  # GET /fines
  # GET /fines.json
  def index
    @fines = Fine.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @fines }
    end
  end

  # GET /fines/1
  # GET /fines/1.json
  def show
    @fine = Fine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @fine }
    end
  end

  # GET /fines/new
  # GET /fines/new.json
  def new
    @fine = Fine.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @fine }
    end
  end

  # GET /fines/1/edit
  def edit
    @fine = Fine.find(params[:id])
  end

  # POST /fines
  # POST /fines.json
  def create
    @fine = Fine.new(params[:fine])

    respond_to do |format|
      if @fine.save
        format.html { redirect_to @fine, :notice => 'Fine was successfully created.' }
        format.json { render :json => @fine, :status => :created, :location => @fine }
      else
        format.html { render :action => "new" }
        format.json { render :json => @fine.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /fines/1
  # PUT /fines/1.json
  def update
    @fine = Fine.find(params[:id])

    respond_to do |format|
      if @fine.update_attributes(params[:fine])
        format.html { redirect_to @fine, :notice => 'Fine was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @fine.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /fines/1
  # DELETE /fines/1.json
  def destroy
    @fine = Fine.find(params[:id])
    @fine.destroy

    respond_to do |format|
      format.html { redirect_to fines_url }
      format.json { head :ok }
    end
  end
end
