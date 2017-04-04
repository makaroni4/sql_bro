class Db::ConnectionsController < ApplicationController
  before_action :set_db_connection, only: [:show, :edit, :update, :destroy]

  def index
    @db_connections = Db::Connection.all
  end

  def tables
    @db_connection = Db::Connection.find(params[:connection_id])

    respond_to do |format|
      format.html
      format.json do
        render json: Db::Table.includes(schema: :connection).where(db_connections: { id: @db_connection.id }), each_serializer: DbTableSerializer
      end
    end
  end

  def refresh_tables
    @db_connection = Db::Connection.find(params[:connection_id])

    connector = @db_connection.connector

    connector.store_columns_info
    connector.download_table_sizes
    connector.download_table_row_counts

    render json: Db::Table.includes(schema: :connection).where(db_connections: { id: @db_connection.id }), each_serializer: DbTableSerializer
  end

  def show
  end

  def new
    @db_connection = Db::Connection.new
  end

  def edit
  end

  def create
    @db_connection = Db::Connection.new(db_connection_params)

    respond_to do |format|
      if @db_connection.save
        format.html { redirect_to action: :index, notice: 'Connection was successfully created.' }
        format.json { render :show, status: :created, location: @db_connection }
      else
        format.html { render :new }
        format.json { render json: @db_connection.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @db_connection.update(db_connection_params)
        format.html { redirect_to action: :index, notice: 'Connection was successfully updated.' }
        format.json { render :show, status: :ok, location: @db_connection }
      else
        format.html { render :edit }
        format.json { render json: @db_connection.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @db_connection.destroy
    respond_to do |format|
      format.html { redirect_to db_connections_url, notice: 'Connection was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_db_connection
      @db_connection = Db::Connection.find(params[:id])
    end

    def db_connection_params
      params.require(:db_connection).permit(:adapter, :user, :password, :host, :timeout, :database)
    end
end
