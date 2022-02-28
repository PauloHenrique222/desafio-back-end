class ApplicationService
  Result = Struct.new(:success?, :body, :error)

  def self.call(...)
    new(...).call
  end
end
