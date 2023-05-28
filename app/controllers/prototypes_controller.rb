class PrototypesController < ApplicationController
  before_action :get_prototype, only: [:show, :edit]
  before_action :authenticate_user!, only: [:new, :edit, :destroy]
  before_action :redirect_to_root, only: [:edit]

  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    get_prototype
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
  end

  def update
    get_prototype
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    else
      render :edit
    end
  end

  def destroy
    get_prototype
    @prototype.destroy
    redirect_to root_path
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def get_prototype
    @prototype = Prototype.find(params[:id])
  end

  def redirect_to_root
    unless current_user.id == @prototype.user_id
      redirect_to root_path
    end
  end
end
