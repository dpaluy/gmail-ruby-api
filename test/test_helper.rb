require 'gmail'
require 'test/unit'
require 'mocha/setup'
require 'stringio'
require 'shoulda'
require File.expand_path('../test_data', __FILE__)
def default_locale
  @default_locale ||= "en"
  @locale = @default_locale
end
# monkeypatch request methods
module Gmail
  @client = nil

  def self.connect

  end

  def self.client= value
    @client = value
  end

end

class Test::Unit::TestCase
  include Gmail::TestData
  include Mocha

  setup do
    @mock = mock
    Gmail.client = @mock
    #Gmail.new(client_id: "foo", client_secret: "foo", refresh_token: "foo", application_name: "test", application_version: "test")
    Gmail.new(client_id: "foo", client_secret: "foo", refresh_token: "foo", auth_method:"web_application")
  end

  teardown do
    Gmail.client = nil
    Gmail.client_id = nil
    Gmail.client_secret = nil
    Gmail.refresh_token = nil
  end
end