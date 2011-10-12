class EncryptedConnectionsController < ApplicationController
  # GET /encrypted_connections
  # GET /encrypted_connections.json
  def index
    @encrypted_connections = EncryptedConnection.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @encrypted_connections }
    end
  end

  # GET /encrypted_connections/new
  # GET /encrypted_connections/new.json
  def new
    @encrypted_connection = EncryptedConnection.new
    @encrypted_connection.save
    flash[:notice] = @encrypted_connection.errors.full_messages
    redirect_to :action => :index
  end

  # DELETE /encrypted_connections/1
  # DELETE /encrypted_connections/1.json
  def destroy
    @encrypted_connection = EncryptedConnection.find(params[:id])
    @encrypted_connection.destroy

    respond_to do |format|
      format.html { redirect_to encrypted_connections_url }
      format.json { head :ok }
    end
  end
end
