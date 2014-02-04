require "spec_helper"
require "json"
require "pry"

describe Lita::Handlers::ImageBomb, lita_handler: true do
  it { routes_command("puppy bomb!").to :drop }
  it { routes_command("10 puppy bomb!").to :drop }
  it { routes_command("puppy bombs!").to :drop }
  it { routes_command("10 puppy bombs!").to :drop }

  it { doesnt_route("puppy bomb").to :drop }
  it { doesnt_route("10 puppy bomb").to :drop }
  it { doesnt_route("puppy bombs").to :drop }
  it { doesnt_route("10 puppy bombs").to :drop }

  describe "#drop" do
    let(:json) do
      { responseStatus: 200, responseData: { results: image_paths }}.to_json
    end

    let(:response) { double("Faraday::Response") }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(response)
      allow(response).to receive(:body).and_return json
    end

    context 'request single image' do
      let(:image_paths) do
        [{ unescapedUrl: 'http://www.example.com/path/to/an/image.jpg' }]
      end

      before { send_command("puppy bomb!") }

      it 'returns an image' do
        expect(replies.last).to eq("http://www.example.com/path/to/an/image.jpg#.png")
      end
    end

    context 'request 2 to 8 images' do
      let(:image_paths) do
        [
          { unescapedUrl: 'http://www.example.com/path/to/an/image1.jpg' },
          { unescapedUrl: 'http://www.example.com/path/to/an/image2.jpg' },
          { unescapedUrl: 'http://www.example.com/path/to/an/image3.jpg' },
          { unescapedUrl: 'http://www.example.com/path/to/an/image4.jpg' },
          { unescapedUrl: 'http://www.example.com/path/to/an/image5.jpg' }
        ]
      end

      before { send_command("5 puppy bombs!") }

      it 'returns replies with many images' do
        expect(replies).to include("http://www.example.com/path/to/an/image4.jpg#.png")
        expect(replies).to include("http://www.example.com/path/to/an/image2.jpg#.png")
        expect(replies).to include("http://www.example.com/path/to/an/image3.jpg#.png")
        expect(replies).to include("http://www.example.com/path/to/an/image4.jpg#.png")
        expect(replies).to include("http://www.example.com/path/to/an/image5.jpg#.png")
      end
    end

    context 'request more than 8 images' do
      let(:image_paths) { [] }

      before { send_command("9 puppy bombs!") }

      it 'yells at you' do
        expect(replies.last).to eq('TOO MANY PUPPY BOMBS STUPID HEAD!')
      end
    end
  end
end
