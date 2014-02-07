require 'lita'
require 'singleton'

module Lita
  module Handlers
    class JoebotThinksYouSuck < Handler
      route /^(joebot, how does it work\?)$/, :help
      route /^(listen up joebot!)$/, :listen
      route /^(simmah down joebot!)$/, :sleep
      route /(what does joebot think\?)$/m, :that_sucks
      route /^((?!\bwhat does joebot think\b\?)|(?!\bjoebot, how does it work\b\?)|(?!\blisten up joebot!)|(?!\bsimmah down joebot!)).+/, :record

      def help(response)
        response.reply operating_manual
      end

      def record(response)
        message.record(response.message.body) if message.active?
      end

      def listen(response)
        message.listen!
        response.reply "YO!"
      end

      def sleep(response)
        message.sleep!
        response.reply "Zzzzzzzz"
      end

      def that_sucks(response)
        response.reply message.active? ? that_message_sucks : imma_sleepin
      end

      private
      def message
        @message ||= Message.instance
      end

      class Message
        include ::Singleton
        attr_accessor :message, :active

        def record(message)
          self.message = message
        end

        def active?
          self.active
        end

        def listen!
          self.active = true
        end

        def sleep!
          self.active = false
        end

        def recall
          self.message
        end
      end

      def operating_manual
        <<-EOS
          O hai, I'm Joebot. These are the things I will respond to:

            listen up joebot!       => This tells me to start listening to the chat but I will only remember the last message that was posted
            simmah down joebot!     => This tells me to stop listening to the chat
            what does joebot think? => This prompts me to weigh in on whatever the last message posted in the chat was

          Want me to do more neat stuff? Submit a pull request to https://github.com/imoss/berklee-online-chatbot
        EOS
      end

      def that_message_sucks
        "What do I think about #{message.recall}?! I THINK IT SUCKS!"
      end

      def imma_sleepin
        <<-EOS
          Imma sleeping, but I do think that...
          ♫ ♫ You may be the fate of Ophelia sleeping and perchance to dream ♫ ♫ 
          ♫ ♫ Honest to the point of recklessness, self-centered in the extreme ♫ ♫ 
        EOS
      end
    end

    Lita.register_handler(JoebotThinksYouSuck)
  end
end
