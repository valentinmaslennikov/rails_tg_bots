module TranslateProvider
  extend ActiveSupport::Concern

  included do
    def get_url url_type
      VOCAB[url_type.to_sym].sample
    end

    def translated_text
      static_translate
    end

    private

    def static_translate
      result_text = ''
      result_text << "#{VOCAB['adjectives'].sample}-#{VOCAB['adjectives'].sample} "
      result_text << "#{VOCAB['objects'].sample} #{VOCAB['verbs'].sample} #{VOCAB['subjects'].sample} "
      result_text << VOCAB['destinations'].sample

      result_text
    end
  end
end
