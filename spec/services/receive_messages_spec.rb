RSpec.describe ReceiveMessages do
  describe "#call" do
    subject(:call) { described_class.call(ENV["AWS_REGION"], ENV["AWS_SQS_QUEUE_URL"]) }

    let(:request_sqs) do
      stub_request(:post, ENV["AWS_SQS_QUEUE_URL"])
        .to_return(status: 200, body: " ", headers: {})
    end

    context "when to receive messages" do
      it "is invalid" do
        request_sqs
        expect(call.success?).to be(false)
      end
    end
  end
end
