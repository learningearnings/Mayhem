require 'test_helper'
require 'active_support/core_ext'
require_relative '../../app/models/home_host_finder'

describe HomeHostFinder do
  subject { HomeHostFinder.new }

  it "returns the request host properly if no subdomain" do
    request = request_for(nil, "foo.com")
    subject.host_for("al2", request).must_equal("http://al2.foo.com")
  end

  it "returns the request host properly if on the wrong subdomain" do
    request = request_for("bar", "bar.foo.com")
    subject.host_for("al2", request).must_equal("http://al2.foo.com")
  end

  def request_for(subdomain, host)
    rq = mock "Request"
    rq.stubs(:subdomain).returns(subdomain)
    rq.stubs(:host).returns(host)
    rq.stubs(:protocol).returns("http://")
    rq.stubs(:port).returns(80)
    rq
  end
end
