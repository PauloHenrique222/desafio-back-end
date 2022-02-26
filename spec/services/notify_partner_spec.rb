RSpec.describe NotifyPartner do
  describe "#call" do
    subject(:call) { described_class.call }

    let!(:stub) do
      stub_request(:post, "https://61b69749c95dd70017d40f4b.mockapi.io/awesome_partner_leads")
        .with(body: { "message" => "new registration", "partner" => "internal" })
        .to_return(status: 200, body: "", headers: {})
    end

    it "sends a notification to the partner" do
      call
      expect(stub).to have_been_requested
    end
  end
end
