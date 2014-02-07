require 'spec_helper'
require 'pry'

describe Lita::Handlers::JoebotThinksYouSuck, lita_handler: true do
  it { routes_command("joebot, yo").to :record }
  it { doesnt_route("joebot, yo").to :listen }
  it { doesnt_route("joebot, yo").to :sleep }
  it { doesnt_route("joebot, yo").to :that_sucks }

  it { routes_command("listen up joebot!").to :listen }
  it { doesnt_route("listen up joebot").to :listen }
  it { doesnt_route("listen up joebot!").to :record }
  it { doesnt_route("listen up joebot!").to :sleep }
  it { doesnt_route("listen up joebot!").to :that_sucks }

  it { routes_command("simmah down joebot!").to :sleep }
  it { doesnt_route("simmah down joebot").to :sleep }
  it { doesnt_route("simmah down joebot!").to :record }
  it { doesnt_route("simmah down joebot!").to :listen }
  it { doesnt_route("simmah down joebot!").to :that_sucks }

  it { routes_command("what does joebot think?").to :that_sucks }
  it { doesnt_route("what does joebot think").to :that_sucks }
  it { doesnt_route("what does joebot think?").to :record }
  it { doesnt_route("what does joebot think?").to :listen }
  it { doesnt_route("what does joebot think?").to :sleep }


  describe "#record" do
    context 'when Message is active' do
      let(:message) { binding.pry; Lita::Handers::MessageDouble.new }

      before do
        message.stub(:active).and_return(true)
        Lita.handlers.stub(:message).and_return(message)
      end

      it 'records the input' do
        send_message("Record my message!")
        expect(message).to receive(:record).with(source.message.body)
      end
    end

    context 'when Message is inactive' do
      it 'ignores the input' do
      end
    end
  end

  describe "#listen" do
    it 'sets the Message state to active' do
    end

    it 'prints a confirmation that the Message is listening' do
    end
  end

  describe "#sleep" do
    it 'set the Message state to inactive' do
    end

    it 'prints a confirmation that the Message is sleeping' do
    end
  end

  describe "#that_sucks" do
    context 'when Message is active' do
      it 'returns the last recorded message' do
      end
    end

    context 'when Message is inactive' do
      it 'returns a default message' do
      end
    end
  end
end
