class SubdomainConstraint
  def initialize(domain)
    @domain = domain
  end

  def matches?(request)
    request.subdomain.present? && request.subdomain == @domain
  end
end
