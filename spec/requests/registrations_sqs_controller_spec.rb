RSpec.describe "Api::V1::RegistrationsSqsController", type: :request do
  describe "POST #create" do
    let(:request_sqs) do
      stub_request(:post, ENV["AWS_SQS_QUEUE_URL"])
        .to_return(status: 200, body: " ", headers: {})
    end

    it "renders 422 unprocessable entity" do
      request_sqs
      post api_v1_registrations_sqs_path

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
