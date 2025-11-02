require "bundler/setup"
require "openai"

# Configure a singleton client for the app. Keep secrets in ENV.
# Expected ENV vars:
# - OPENAI_API_KEY: your API key
# - OPENAI_ORG (optional): org id if needed
# - OPENAI_PROJECT (optional): project id if needed

openai = OpenAI::Client.new(
  api_key: ""
)
