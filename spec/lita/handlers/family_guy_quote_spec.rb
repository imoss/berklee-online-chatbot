require "spec_helper"

describe Lita::Handlers::FamilyGuyQuote, lita_handler: true do
  it { routes_command("fg").to :quote_family_guy }
  it { doesnt_route("fga").to :quote_family_guy }

  describe "#quote_family_guy" do
    let(:html) do
      <<-EOS
        <div id="quotes">
        This is a test<br>quote
        </div>
      EOS
    end

    let(:response) { double("Faraday::Response") }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(response)
      allow(response).to receive(:body).and_return html

      send_command("fg")
    end

    it "returns the sanitized quote" do
      expect(replies.last).to eq("This is a test\nquote")
    end
  end
end
