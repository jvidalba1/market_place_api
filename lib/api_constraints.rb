class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(request)
    @default || request.headers['Accept'].include?("application/vnd.market_place_api.v#{@version}")
  end
end
