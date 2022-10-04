# frozen_string_literal: true

class CardComponent < ViewComponent::Base
  def initialize(word:, card:)
    @word = word
    @card = card

    @template = Liquid::Template.parse(@card.template)
    @rendered_template = @template.render(params.with_indifferent_access)
  end

  private

  def params
    case @word
    when Noun then noun_params
    when Verb then verb_params
    when Adjective then adjective_params
    end
  end

  def noun_params
    {
      name: @word.name
    }
  end

  def verb_params
    {
      name: @word.name
    }
  end

  def adjective_params
    {
      name: @word.name
    }
  end
end
