class ApplicationService
  Result = Struct.new(:success?, :body, :error)

  def self.call(*args)
    new(*args).call
  end
end
