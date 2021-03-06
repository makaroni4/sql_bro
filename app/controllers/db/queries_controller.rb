class Db::QueriesController < ApplicationController
  serialization_scope :view_context

  before_action :check_db_connection_exist, only: [:index, :new]
  before_action :set_db_query, only: [:show, :edit, :update, :destroy]

  def index
    @db_queries = Db::Query.order(created_at: :desc).page(params[:page])
    @db_queries_serialization = ActiveModel::SerializableResource.new(
      @db_queries,
      each_serializer: QueryResultSerializer
    )
  end

  def show
    respond_to do |format|
      format.html do
        @db_query_serializer = QueryResultSerializer.new(@db_query)
      end

      format.csv do
        exporter = QueryToCsvExporter.new(params[:id])
        send_data exporter.data, filename: exporter.filename
      end
    end
  end

  def new
    @db_query = init_or_clone_query(params[:query_id])
  end

  def edit
  end

  def create
    @db_query = Db::Query.new(db_query_params)

    respond_to do |format|
      if @db_query.run
        format.html { redirect_to action: :index, notice: 'Query was successfully created.' }
        format.json { redirect_to :show, status: :created, location: @db_query }
      else
        format.html { render :new }
        format.json { render json: @db_query.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @db_query.update(db_query_params)
        format.html { redirect_to @db_query, notice: 'Query was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :edit }
        format.json { render json: @db_query.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @db_query.destroy
    respond_to do |format|
      format.html { redirect_to db_queries_url, notice: 'Query was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    queries = Db::Query.where("description LIKE ?", "%#{params[:q]}%").order(created_at: :desc).limit(5)

    respond_to do |format|
      format.json do
        render json: queries, each_serializer: QuerySearchSerializer
      end
    end
  end

  def autocomplete
    autocomplete = QueryAutocomplete.new(params[:db_connection_id])

    respond_to do |format|
      format.json do
        render json: autocomplete.suggest(params[:q]).to_json
      end
    end
  end

  def setup_autocomplete
    connection = Db::Connection.find(params[:db_connection_id])
    connection.connector.store_columns_info

    respond_to do |format|
      format.json do
        head :ok
      end
    end
  end

  def cancel
    connection = Db::Connection.find(db_query_params[:db_connection_id])
    connection.connector.cancel_query(db_query_params[:body])

    respond_to do |format|
      format.json do
        head :ok
      end
    end
  end

  private
    def set_db_query
      @db_query = Db::Query.find(params[:id])
    end

    def db_query_params
      params.require(:db_query).permit(:body, :db_connection_id, :description)
    end

    def check_db_connection_exist
      redirect_to new_db_connection_path unless Db::Connection.any?
    end

    def init_or_clone_query(query_id)
      if query_id.present?
        parent_query = Db::Query.find(query_id)
        Db::Query.new(parent_query.attributes.slice("db_connection_id", "body", "description"))
      else
        db_connection = Db::Connection.first
        db_connection.queries.build
      end
    end
end
