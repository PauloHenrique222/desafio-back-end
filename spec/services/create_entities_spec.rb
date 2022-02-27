RSpec.describe CreateEntities do
  describe "#call" do
    subject(:call) { described_class.call(entities, account) }

    let(:entities) do
      [{
        name: Faker::Superhero.name,
        users: [{
          email: Faker::Internet.email,
          first_name: Faker::Name.female_first_name,
          last_name: Faker::Name.last_name,
          phone: Faker::PhoneNumber.cell_phone,
        }],
      }]
    end
    let(:account) { create(:account) }

    context "when entities is created" do
      it { is_expected.to eql(entities) }
    end

    context "when entities is not created" do
      it "the record is invalid" do
        entities.last[:name] = nil
        expect { call }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
      end
    end
  end
end
