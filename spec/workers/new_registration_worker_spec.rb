RSpec.describe NewRegistrationWorker do
  describe "#perform" do
    subject(:perform) { described_class.new.perform(sqs_message.data) }

    let(:request_mockapi_internal) do
      stub_request(:post, "https://61b69749c95dd70017d40f4b.mockapi.io/awesome_partner_leads")
        .with(body: { "message" => "new registration", "partner" => "internal" })
        .to_return(status: 200, body: "{\"message\":\"new registration\",\"partner\":\"internal\"}", headers: {})
    end
    let(:sqs_message) { OpenStruct.new(data: body) }
    let(:body) do
      {
        account: {
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
        },
      }
    end

    context "when payload is valid" do
      it "creates a new registration" do
        request_mockapi_internal
        expect(perform.success?).to be(true)
      end
    end

    context "when payload is invalid" do
      it "raises an error" do
        body[:account][:name] = nil
        expect(perform.error).to eql("Validation failed: Name can't be blank")
      end
    end
  end
end
