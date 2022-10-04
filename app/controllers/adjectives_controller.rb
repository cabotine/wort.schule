# frozen_string_literal: true

class AdjectivesController < PublicController
  include Cardable

  load_and_authorize_resource

  def index
    @filterrific = initialize_filterrific(
      Adjective,
      params[:filterrific]
    ) or return
    @adjectives = @filterrific.find.ordered_lexigraphically.page(params[:page])
  end

  def new
  end

  def create
    @adjective.assign_compound_entities(params[:adjective][:compound_entity_ids])

    if @adjective.save
      redirect_to @adjective, notice: t("notices.adjectives.created", adjective: @adjective.name)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @adjective.assign_compound_entities(params[:adjective][:compound_entity_ids])

    if @adjective.update(adjective_params)
      @adjective.compound_entities.each(&:save)

      redirect_to @adjective, notice: t("notices.adjectives.updated", adjective: @adjective.name)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    destroyed = @adjective.destroy
    notice = if destroyed
      {notice: t("notices.adjectives.destroyed", adjective: @adjective.name)}
    else
      {alert: t("alerts.adjectives.destroyed", adjective: @adjective.name)}
    end

    redirect_to adjectives_path, notice
  end

  private

  def adjective_params
    params.require(:adjective).permit(
      :comparative,
      :superlative,
      :absolute,
      :irregular_comparison,
      :irregular_declination,
      *Word::ATTRIBUTES
    )
  end
end
