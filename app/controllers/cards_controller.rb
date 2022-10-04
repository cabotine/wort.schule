# frozen_string_literal: true

class CardsController < ApplicationController
  load_and_authorize_resource

  def index
    @cards = @cards.order(:name).page(params[:page])
  end

  def show
  end

  def new
  end

  def create
    if @card.save
      redirect_to @card, notice: t("notices.shared.created", name: @card.name, class_name: Card.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @card.update(card_params)
      redirect_to @card, notice: t("notices.shared.updated", name: @card.name, class_name: Card.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    destroyed = @card.destroy
    notice = if destroyed
      {notice: t("notices.shared.destroyed", name: @card.name, class_name: Card.model_name.human)}
    else
      {alert: t("alerts.shared.destroyed", name: @card.name)}
    end

    redirect_to cards_url, notice
  end

  private

  def card_params
    params.require(:card).permit(
      :name, :description, :word_type, :template, :visibility
    )
  end
end
