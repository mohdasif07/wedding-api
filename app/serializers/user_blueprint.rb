class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :first_name, :last_name, :email, :phone, :role, :created_at

  field :full_name

  view :with_tokens do
    association :tokens, blueprint: TokenBlueprint do |_user, options|
      options[:tokens]
    end
  end
end
