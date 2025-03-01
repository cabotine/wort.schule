# frozen_string_literal: true

class FunctionWordsController < ApplicationController
  load_and_authorize_resource

  def index
    @function_words = @function_words.order("words.name").page(params[:page])
  end

  def show
  end

  def new
  end

  def create
    if @function_word.save
      redirect_to @function_word, notice: t("notices.shared.created", name: @function_word.name, class_name: FunctionWord.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @function_word.update(function_word_params)
      redirect_to @function_word, notice: t("notices.shared.updated", name: @function_word.name, class_name: FunctionWord.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    destroyed = @function_word.destroy
    notice = if destroyed
      {notice: t("notices.shared.destroyed", name: @function_word.name, class_name: FunctionWord.model_name.human)}
    else
      {alert: t("alerts.shared.destroyed", name: @function_word.name)}
    end

    redirect_to function_words_url, notice
  end

  private

  def function_word_params
    params.require(:function_word).permit(
      :name, :function_type, :syllables, :written_syllables
    )
  end
end
