require "lita"

module Lita
  module Handlers
    class ImageBomb < Handler
      URL = 'https://ajax.googleapis.com/ajax/services/search/images'

      route /(\d+|^)([a-zA-Z\s]+)(bomb!|bombs!)/, :drop

      def drop(response)
        Bomb.fetch(response, http)
      end

      class Bomb < Struct.new(:response, :http)
        def self.fetch(response, http)
          new(response, http).fetch
        end

        def quantity
          matches.first == "" ? 1 : matches.first.to_i
        end

        def fetch
          if quantity > 8
            response.reply "TOO MANY #{query.upcase} BOMBS STUPID HEAD!"
          else
            results.each { |r| response.reply "#{r["unescapedUrl"]}#.png" }
          end
        end

        def results
          http_response = http.get(URL, v: '1.0', q: query, safe: 'active', rsz: quantity)
          MultiJson.load(http_response.body)["responseData"]["results"]
        end

        def matches
          response.matches.last
        end

        def query
          matches[1].strip
        end
      end
    end

    Lita.register_handler(ImageBomb)
  end
end
