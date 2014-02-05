require "lita"
require "nokogiri"

module Lita
  module Handlers
    class FamilyGuyQuote < Handler
      URL = 'http://www.family-guy-quotes.net/'

      route /\A(fg)$/, :quote_family_guy

      def quote_family_guy(response)
        response.reply sanitized_quote
      end

      private
      def replace_tags
        quote.tap do |c|
          c.css('br').each do |br|
            br.replace "\n"
          end
        end
      end

      def sanitized_quote
        replace_tags.text.strip
      end

      def quote
        scraped_html.at_css("#quotes")
      end

      def scraped_html
        @scraped_html ||= Nokogiri::HTML http.get(URL).body
      end
    end

    Lita.register_handler(FamilyGuyQuote)
  end
end
