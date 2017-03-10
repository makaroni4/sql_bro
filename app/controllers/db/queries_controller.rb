class Db::QueriesController < ApplicationController
  before_action :set_db_query, only: [:show, :edit, :update, :destroy]

  def index
    @db_queries = Db::Query.all
  end

  def show
  end

  def new
    @db_query = Db::Query.new
  end

  def edit
  end

  def create
    @db_query = Db::Query.new(db_query_params)

    respond_to do |format|
      if @db_query.run
        format.html { redirect_to @db_query, notice: 'Query was successfully created.' }
        format.json { render :show, status: :created, location: @db_query }
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
        format.json { render :show, status: :ok, location: @db_query }
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

  private
    def set_db_query
      @db_query = Db::Query.find(params[:id])
    end

    def db_query_params
      params.require(:db_query).permit(:body, :db_connection_id, :description)
    end
end