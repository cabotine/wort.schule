# frozen_string_literal: true

module Cardable
  extend ActiveSupport::Concern

  included do
    def card
      @card = Card.accessible_by(current_ability).find(params[:card_id])
      @word = instance_variable_get("@#{params[:controller].singularize}")
    end
  end
end
