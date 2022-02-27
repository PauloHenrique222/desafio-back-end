RSpec.describe CreateUsers do
  describe "#call" do
    subject(:call) { described_class.call(users) }

    let(:users) do
      [{
        email: Faker::Internet.email,
        first_name: Faker::Name.female_first_name,
        last_name: Faker::Name.last_name,
        phone: Faker::PhoneNumber.cell_phone,
      }]
    end

    context "when users is created" do
      it { is_expected.to eql(User.where(email: users.pluck(:email)).to_a) }
    end

    context "when users is not created" do
      it "the record is invalid" do
        users.last[:first_name] = nil
        expect { call }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: First name can't be blank")
      end
    end
  end
end
