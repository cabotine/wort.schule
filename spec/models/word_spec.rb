# frozen_string_literal: true

RSpec.describe Word do
  subject(:word) { build :word }

  describe "#syllables_count" do
    subject { word.syllables_count }

    context "with an empty string" do
      before { word.syllables = "" }

      it { is_expected.to eq 0 }
    end

    context "with whitespaces" do
      before { word.syllables = "   " }

      it { is_expected.to eq 0 }
    end

    context "with only one syllable" do
      before { word.syllables = "see" }

      it { is_expected.to eq 1 }
    end

    context "with multiple syllables" do
      before { word.syllables = "katz-en-baum" }

      it { is_expected.to eq 3 }
    end

    context "with multiple syllables and whitespaces" do
      before { word.syllables = " katz-en- baum" }

      it { is_expected.to eq 3 }
    end
  end

  describe "#opposites" do
    subject(:word) { create :word, name: "Haus" }
    let(:synonym) { create :word, name: "Gebäude" }

    it "adds a synonym" do
      word.synonyms << synonym
      word.reload

      expect(word.synonyms).to match [synonym]
    end

    context "with an existing synonym" do
      before do
        word.synonyms << synonym
      end

      it "does not add a duplicate" do
        word.synonyms << synonym
        word.reload

        expect(word.synonyms).to match [synonym]
      end
    end
  end

  describe "#example_sentences" do
    subject(:word) { create :word, name: "Haus" }

    it "adds a sentence" do
      expect(word.update(
        example_sentences_attributes: [{
          sentence: "Das Haus ist gross."
        }]
      )).to be true

      expect(word.example_sentences.map(&:sentence)).to match_array ["Das Haus ist gross."]
    end

    it "ignores an empty sentence" do
      expect(word.update(
        example_sentences_attributes: [{
          sentence: "   "
        }]
      )).to be true

      expect(word.example_sentences).to match_array []
    end

    context "with existing example sentence" do
      let!(:example_sentence) { create :example_sentence, word: }

      it "deletes a sentence" do
        expect(word.example_sentences).to match_array [example_sentence]

        expect(word.update(
          example_sentences_attributes: [{
            id: example_sentence.id,
            _destroy: true
          }]
        )).to be true

        expect(word.example_sentences).to match_array []
      end
    end
  end

  describe "#filter_letters" do
    it "matches umlauts" do
      word = create :noun, name: "Ähre"
      expect(Noun.filter_letters("ä")).to include word
      expect(Word.filter_letters("ä")).to include word.acting_as
    end

    it "requires all letters to be present" do
      word1 = create :noun, name: "Abc"
      create :noun, name: "A"
      expect(Noun.filter_letters("ac")).to match [word1]
      expect(Word.filter_letters("ac")).to match [word1.acting_as]
    end
  end

  describe "#filter_source" do
    it "finds words with a specific source" do
      source = create :source
      word = create :noun, sources: [source]
      create :noun

      expect(Noun.filter_source(source.id)).to match [word]
      expect(Word.filter_source(source.id)).to match [word.acting_as]
    end
  end

  describe "#filter_topic" do
    it "finds words with a specific topic" do
      topic = create :topic
      word = create :noun, topics: [topic]
      create :noun

      expect(Word.filter_topic(topic.id)).to match [word.acting_as]
      expect(Noun.filter_topic(topic.id)).to match [word]
    end
  end

  describe "#filter_hierarchy" do
    it "finds words with a specific hierarchy" do
      hierarchy = create :hierarchy
      word = create(:noun, hierarchy:)
      create :noun

      expect(Noun.filter_hierarchy(hierarchy.id)).to match [word]
      expect(Word.filter_hierarchy(hierarchy.id)).to match [word.acting_as]
    end
  end

  describe "#filter_phenomenons" do
    it "finds words with a specific phenomenon" do
      phenomenon = create :phenomenon
      word = create(:noun, phenomenons: [phenomenon])
      create :noun

      expect(Noun.filter_phenomenons(OpenStruct.new(
        conjunction: "and", phenomenons: [phenomenon.id]
      ))).to match [word]
      expect(Word.filter_phenomenons(OpenStruct.new(
        conjunction: "and", phenomenons: [phenomenon.id]
      ))).to match [word.acting_as]
    end

    it "finds words with multiple ORed phenomenons" do
      phenomenon1 = create :phenomenon
      phenomenon2 = create :phenomenon
      word1 = create(:noun, phenomenons: [phenomenon1, phenomenon2])
      word2 = create :noun, phenomenons: [phenomenon1]

      expect(Noun.filter_phenomenons(OpenStruct.new(
        conjunction: "or", phenomenons: [phenomenon1.id, phenomenon2.id]
      ))).to match_array [word1, word2]
      expect(Word.filter_phenomenons(OpenStruct.new(
        conjunction: "or", phenomenons: [phenomenon1.id, phenomenon2.id]
      ))).to match_array [word1.acting_as, word2.acting_as]
    end

    it "finds words with multiple ANDed phenomenons" do
      phenomenon1 = create :phenomenon
      phenomenon2 = create :phenomenon
      word = create(:noun, phenomenons: [phenomenon1, phenomenon2])
      create :noun, phenomenons: [phenomenon1]

      expect(Noun.filter_phenomenons(OpenStruct.new(
        conjunction: "and", phenomenons: [phenomenon1.id, phenomenon2.id]
      ))).to match_array [word]
      expect(Word.filter_phenomenons(OpenStruct.new(
        conjunction: "and", phenomenons: [phenomenon1.id, phenomenon2.id]
      ))).to match_array [word.acting_as]
    end
  end

  describe "#filter_strategies" do
    it "finds words with a specific strategy" do
      strategy = create :strategy
      word = create(:noun, strategies: [strategy])
      create :noun

      expect(Noun.filter_strategies(OpenStruct.new(
        conjunction: "and", strategies: [strategy.id]
      ))).to match_array [word]
      expect(Word.filter_strategies(OpenStruct.new(
        conjunction: "and", strategies: [strategy.id]
      ))).to match_array [word.acting_as]
    end

    it "finds words with multiple ORed strategies" do
      strategy1 = create :strategy
      strategy2 = create :strategy
      word1 = create(:noun, strategies: [strategy1, strategy2])
      word2 = create :noun, strategies: [strategy1]

      expect(Noun.filter_strategies(OpenStruct.new(
        conjunction: "or", strategies: [strategy1.id, strategy2.id]
      ))).to match_array [word1, word2]
      expect(Word.filter_strategies(OpenStruct.new(
        conjunction: "or", strategies: [strategy1.id, strategy2.id]
      ))).to match_array [word1.acting_as, word2.acting_as]
    end

    it "finds words with multiple ANDed strategies" do
      strategy1 = create :strategy
      strategy2 = create :strategy
      word = create(:noun, strategies: [strategy1, strategy2])
      create :noun, strategies: [strategy1]

      expect(Noun.filter_strategies(OpenStruct.new(
        conjunction: "and", strategies: [strategy1.id, strategy2.id]
      ))).to match [word]
      expect(Word.filter_strategies(OpenStruct.new(
        conjunction: "and", strategies: [strategy1.id, strategy2.id]
      ))).to match [word.acting_as]
    end
  end

  describe "#filter_keywords" do
    it "finds words with a specific keyword" do
      keyword = create :noun
      word = create :noun
      word.update!(keyword_ids: [keyword.acting_as.id])
      create :noun

      expect(Noun.filter_keywords(OpenStruct.new(
        conjunction: "and", keywords: [keyword.acting_as.id]
      ))).to match [word]
      expect(Word.filter_keywords(OpenStruct.new(
        conjunction: "and", keywords: [keyword.acting_as.id]
      ))).to match [word.acting_as]
    end

    it "finds words with multiple ORed keywords" do
      keyword1 = create :noun
      keyword2 = create :noun
      word1 = create :noun
      word1.update!(keyword_ids: [keyword1.acting_as.id, keyword2.acting_as.id])
      word2 = create :noun, keywords: [keyword1]
      word2.update!(keyword_ids: [keyword1.acting_as.id])

      expect(Noun.filter_keywords(OpenStruct.new(
        conjunction: "or", keywords: [keyword1.acting_as.id, keyword2.acting_as.id]
      ))).to match_array [word1, word2]
      expect(Word.filter_keywords(OpenStruct.new(
        conjunction: "or", keywords: [keyword1.acting_as.id, keyword2.acting_as.id]
      ))).to match_array [word1.acting_as, word2.acting_as]
    end

    it "finds words with multiple ANDed keywords" do
      keyword1 = create :noun
      keyword2 = create :noun
      word = create :noun
      word.update!(keyword_ids: [keyword1.acting_as.id, keyword2.acting_as.id])
      other_word = create :noun, keywords: [keyword1]
      other_word.update!(keyword_ids: [keyword1.acting_as.id])

      expect(Noun.filter_keywords(OpenStruct.new(
        conjunction: "and", keywords: [keyword1.acting_as.id, keyword2.acting_as.id]
      ))).to match [word]
      expect(Word.filter_keywords(OpenStruct.new(
        conjunction: "and", keywords: [keyword1.acting_as.id, keyword2.acting_as.id]
      ))).to match [word.acting_as]
    end
  end

  describe "#filter_consonant_vowel" do
    it "finds words with a specific consonant vowel" do
      word = create :noun, name: "Baum"
      create :noun

      expect(Noun.filter_consonant_vowel("KVVK")).to match [word]
      expect(Word.filter_consonant_vowel("KVVK")).to match [word.acting_as]
    end
  end

  describe "#filter_foreign" do
    it "finds words which are foreign" do
      word = create :noun, foreign: true
      create :noun, foreign: false

      expect(Noun.filter_foreign("1")).to match [word]
      expect(Word.filter_foreign("1")).to match [word.acting_as]
    end
  end

  describe "#filter_prototype" do
    it "finds words which are prototypes" do
      word = create :noun, prototype: true
      create :noun, prototype: false

      expect(Noun.filter_prototype("1")).to match [word]
      expect(Word.filter_prototype("1")).to match [word.acting_as]
    end
  end

  describe "#filter_compound" do
    it "finds words which are compound" do
      word = create :noun, compound: true
      create :noun, compound: false

      expect(Noun.filter_compound("1")).to match [word]
      expect(Word.filter_compound("1")).to match [word.acting_as]
    end
  end

  describe "#filter_example_sentences" do
    it "finds words which have example sentences" do
      example_sentence = create :example_sentence
      word = create :noun, example_sentences: [example_sentence]
      create :noun

      expect(Noun.filter_example_sentences("1")).to match [word]
      expect(Word.filter_example_sentences("1")).to match [word.acting_as]
    end
  end

  describe "#filter_singularetantum" do
    it "finds words which are singularetantum" do
      word = create :noun, singularetantum: true
      create :noun, singularetantum: false

      expect(Noun.filter_singularetantum("1")).to match [word]
      expect(Word.filter_singularetantum("1")).to match [word.acting_as]
    end
  end

  describe "#filter_pluraletantum" do
    it "finds words which are pluraletantum" do
      word = create :noun, pluraletantum: true
      create :noun, pluraletantum: false

      expect(Noun.filter_pluraletantum("1")).to match [word]
      expect(Word.filter_pluraletantum("1")).to match [word.acting_as]
    end
  end

  describe "#set_consonant_vowel" do
    it "detects vowels and consonants" do
      word = create :word, name: "Ähre"

      expect(word.consonant_vowel).to eq "VKKV"
    end

    it "ignores non alphabetic characters" do
      word = create :word, name: "Äh-r  9eß"

      expect(word.consonant_vowel).to eq "VKKVK"
    end
  end
end
