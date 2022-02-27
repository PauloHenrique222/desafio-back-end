RSpec.describe CreateRegistration do
  describe "#call" do
    subject(:call) { described_class.call(payload) }

    let(:request_mockapi_internal) do
      stub_request(:post, "https://61b69749c95dd70017d40f4b.mockapi.io/awesome_partner_leads")
        .with(body: { "message" => "new registration", "partner" => "internal" })
        .to_return(status: 200, body: "", headers: {})
    end
    let(:request_mockapi_another) do
      stub_request(:post, "https://61b69749c95dd70017d40f4b.mockapi.io/awesome_partner_leads")
        .with(body: { "message" => "new registration", "partner" => "another" })
        .to_return(status: 200, body: "", headers: {})
    end
    let(:fake_result) { ApplicationService::Result.new(true) }
    let(:payload) do
      {
        name: Faker::Superhero.name,
        from_partner: true,
        phone: Faker::PhoneNumber.cell_phone,
        entities: [{
          name: Faker::Superhero.name,
          users: [{
            email: Faker::Internet.email,
            first_name: Faker::Name.female_first_name,
            last_name: Faker::Name.last_name,
            phone: Faker::PhoneNumber.cell_phone,
          }],
        }],
      }
    end

    context "when account is from Fintera" do
      it "is successful" do
        payload[:name] = "Fintera - #{Faker::Superhero.name}"
        request_mockapi_internal
        expect(call.success?).to eq(fake_result.success?)
      end
    end

    context "when account is from partner" do
      it "is successful" do
        request_mockapi_internal
        expect(call.success?).to eq(fake_result.success?)
      end
    end

    context "when account is from many partners" do
      it "is successful" do
        payload[:many_partners] = true
        request_mockapi_internal
        request_mockapi_another
        expect(call.success?).to eq(fake_result.success?)
      end
    end

    context "when account is not from a partner" do
      it "is successful" do
        payload[:from_partner] = false
        expect(call.success?).to eq(fake_result.success?)
      end
    end
  end
end
