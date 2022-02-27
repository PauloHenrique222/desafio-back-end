class ReceiveMessages < ApplicationService
  require "aws-sdk-sqs"
  require "aws-sdk-sts"

  def initialize(region, queue_url, max_number_of_messages: 10)
    @sqs_client = Aws::SQS::Client.new(region: region)
    @queue_url = queue_url
    @max_number_of_messages = max_number_of_messages
  end

  def call
    response = @sqs_client.receive_message(
      queue_url: @queue_url,
      max_number_of_messages: @max_number_of_messages
    )
    return Result.new(true, "No messages to receive") if response.messages.count.zero?

    response.messages.each { |message| puts message.body }
    Result.new(true, "Received messages")
  rescue StandardError => e
    Result.new(false, nil, "Error receiving messages: #{e.message}")
  end
end
