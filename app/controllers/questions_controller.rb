class QuestionsController < ApplicationController
  before_action :set_question,only: [:show,:edit,:update,:destroy]
  def index
    @questions = params[:tag_id].present? ? Tag.find(params[:tag_id]).questions : Question.all
    # ２0件ずつ
    @questions = @questions.page(params[:page]).per(20).order('updated_at DESC')
  end

  def show
     @answer = Answer.new
  end

  def new
    @question = Question.new
  end
  
  def create
    @question = Question.new(question_params)
    # if @question.save! !でエラー吐くようにできる
    if @question.save
      redirect_to questions_path, notice: '掲示板を作成しました'
    else
      flash[:alert] = '掲示板作成失敗しました'
      render :new
    end
  end
  def update
     if @question.update(question_params)
      redirect_to questions_path, notice: '質問を修正しました'
    else
      flash[:alert] = '質問失敗しました'
      render :new
     end
  end

  def edit
  end
  
  def destroy
    @question.destroy
    redirect_to questions_path, notice: '削除しました'
  end
  
  private
  
  def set_question
     # 紐づいてる回答も引っ張ってきてる　二回SQL投げてる
     #TODO 紐づいてもってきてる回答ページネート
     @question = Question.find(params[:id])
  end
  
  def question_params
    # デバックツール
    # byebug
    params.require(:question).permit(:name,:title,:content,:picture,:user_id,tag_ids: [])
  end

end