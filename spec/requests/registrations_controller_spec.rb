RSpec.describe "Api::V1::RegistrationsController", type: :request do
  describe "POST #create" do
    let(:request_mockapi_internal) do
      stub_request(:post, "https://61b69749c95dd70017d40f4b.mockapi.io/awesome_partner_leads")
        .with(body: { "message" => "new registration", "partner" => "internal" })
        .to_return(status: 200, body: "{\"message\":\"new registration\",\"partner\":\"internal\"}", headers: {})
    end
    let(:params) do
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

    context "when account is created" do
      it "renders 200 success" do
        request_mockapi_internal
        post api_v1_registrations_path(params: params)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["account"]).to include({ "id" => Account.last.id })
      end
    end

    context "when account is not created" do
      it "renders 422 unprocessable entity" do
        params[:account].delete(:entities)
        post api_v1_registrations_path(params: params)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include({ "error" => "Validation failed: Account is not valid" })
      end
    end
  end
end
