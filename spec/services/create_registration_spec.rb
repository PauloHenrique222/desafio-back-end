RSpec.describe CreateRegistration do
  describe "#call" do
    let(:request_mockapi) do
      stub_request(:post, "https://61b69749c95dd70017d40f4b.mockapi.io/awesome_partner_leads")
        .to_return(status: 200, body: "", headers: {})
    end

    subject(:call) { described_class.call(payload) }
    
    let(:fake_result) { ApplicationService::Result.new(true) }

    context "when account is from partner" do
      let(:payload) do
        {
          name: Faker::Company.name,
          from_partner: true,
          users: [
            {
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.email,
              phone: "(11) 97111-0101",
            },
          ],
        }
      end

      it "is valid" do
        request_mockapi
        expect(call.success?).to eq(fake_result.success?)
      end
    end

    context "when account is from many partners" do
      let(:payload) do
        {
          name: Faker::Company.name,
          from_partner: true,
          many_partners: true,
          users: [
            {
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.email,
              phone: "(11) 97111-0101",
            },
          ],
        }
      end

      it "is valid" do
        request_mockapi
        expect(call.success?).to eq(fake_result.success?)
      end
    end

    context "when account is not from a partner" do
      let(:payload) do
        {
          name: "Fintera - #{Faker::Company.name}",
          users: [
            {
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.email,
              phone: "(11) 97111-0101",
            },
          ],
        }
      end

      it "is valid" do
        expect(call.success?).to eq(fake_result.success?)
      end
    end
  end
end
