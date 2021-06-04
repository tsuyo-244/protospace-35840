class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show ]

  def index
    @prototypes = Prototype.all#includes(:user)
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
      #pathを指定しなくても:newだけで新規作成ページに
      #移行(今回はそのままのページに止まる)できる
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments
  end

  def edit
    @prototype = Prototype.find(params[:id])
    unless current_user == @prototype.user
      redirect_to root_path
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    else
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
                                      #↑必要な全てのカラムを書き込まなければ投稿が保存されない
  end
end
