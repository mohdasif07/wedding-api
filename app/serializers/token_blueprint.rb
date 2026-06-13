class TokenBlueprint < Blueprinter::Base
  fields :access_token, :refresh_token, :token_type, :expires_in
end
