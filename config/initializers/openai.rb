require "bundler/setup"
require "openai"

@openai = OpenAI::Client.new(
  api_key: ENV.fetch("OPENAI_API_KEY")
)
