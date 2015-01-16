class RequestsController < ApplicationController

  before_action :get_request, only: [:edit, :show, :update, :destroy]

  def index
    session[:page_flag] = 'home_page'
    @requests = Request.all.order("done ASC").paginate(page: params[:page], per_page: 5)
  end

  def create
    session[:page_flag] = 'new_page'
    @request = Request.new get_request_params
    if @request.save
      redirect_to root_path
    else
      redirect_to new_request_path, notice: get_errors
    end
  end

  def new
    session[:page_flag] = 'new_page'
    @request = Request.new
  end

  def edit
    session[:page_flag] = ''
  end

  def show
    session[:page_flag] = 'home_page'
    redirect_to root_path
  end

  def update
    if @request.update get_request_params
      session[:page_flag] = 'home_page'
      redirect_to root_path
    else
      session[:page_flag] = ''
      redirect_to edit_request_path(@request), notice: get_errors
    end
  end

  def destroy
    session[:page_flag] = 'home_page'
    if @request.destroy
      redirect_to root_path
    else
      redirect_to root_path, notice: get_errors
    end
  end

  def search
    session[:page_flag] = 'search_page'
    @requests = Request.all.where("name LIKE ? OR email LIKE ? OR message LIKE ?", "%#{params[:search_term]}%", "%#{params[:search_term]}%", "%#{params[:search_term]}%").paginate(page: params[:page], per_page: 5)
    session[:search_term] = params[:search_term]
  end

  def search_cont
    session[:page_flag] = 'search_page'
    @requests = Request.all.where("name LIKE ? OR email LIKE ? OR message LIKE ?", "%#{session[:search_term]}%", "%#{session[:search_term]}%", "%#{session[:search_term]}%").paginate(page: params[:page], per_page: 5)
    render :search
  end

  private

  def get_request_params
    output = params.require(:request).permit(:name,:email,:message,:done)
    output[:department] = params[:department]
    output
  end

  def get_errors
    @request.errors.full_messages.join("; ")
  end

  def get_request
    @request = Request.find params[:id]
  end

end
