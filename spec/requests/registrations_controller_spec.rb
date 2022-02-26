RSpec.describe "Api::V1::RegistrationsController", type: :request do
  describe "POST #create" do
    let(:params) do
      {
        account: {
          name: Faker::Superhero.name, from_partner: true,
          users: [{
            email: Faker::Internet.email,
            first_name: Faker::Name.female_first_name,
            last_name: Faker::Name.last_name,
            phone: Faker::PhoneNumber.cell_phone,
          }],
        },
      }
    end
    
    context "when account is created" do
      it "renders 200 success" do
        post api_v1_registrations_path(params: params)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include({ "id" => Account.last.id })
      end
    end

    context "when account is not created" do
      it "renders 422 unprocessable entity" do
        params[:account].delete(:name)
        post api_v1_registrations_path(params: params)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include({ "error" => "Name can't be blank" })
      end
    end
  end
end
