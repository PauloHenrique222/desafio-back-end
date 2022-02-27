RSpec.describe CreateAccount do
  describe "#call" do
    subject(:call) { described_class.call(payload) }

    let(:payload) do
      {
        name: Faker::Superhero.name,
        from_partner: "true",
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

    context "when account is created" do
      let(:expected_result) { ApplicationService::Result.new(true, { account: Account.last }, nil) }

      it { is_expected.to eql(expected_result) }
    end

    context "when account is not created" do
      let(:expected_result) { ->(message) { ApplicationService::Result.new(false, nil, message) } }

      it "the record is invalid" do
        payload[:name] = nil
        expect(call).to eql(expected_result["Validation failed: Name can't be blank"])
      end

      it do
        payload[:entities].last[:name] = nil
        expect(call).to eql(expected_result["Validation failed: Name can't be blank"])
      end

      it "the payload is invalid" do
        payload[:entities] = []
        expect(call).to eql(expected_result["Validation failed: Account is not valid"])
      end
    end
  end
end
