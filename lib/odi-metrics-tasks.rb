class Hash
  def compact
    delete_if { |k, v| !v }
  end
end

# Configure CapsuleCRM connection
require 'capsulecrm'
CapsuleCRM.account_name = ENV['CAPSULECRM_ACCOUNT_NAME']
CapsuleCRM.api_token = ENV['CAPSULECRM_API_TOKEN']
CapsuleCRM.initialize!

# Require helpers first
Dir.glob(File.expand_path("helpers/*.rb", File.dirname(__FILE__))).each do |inc|
  require inc
end

# Require everything else in lib
Dir.glob(File.expand_path("**/*.rb", File.dirname(__FILE__))).each do |inc|
  require inc
end

def environment
  ENV['RACK_ENV'] || 'production'
end
