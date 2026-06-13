class VendorBlueprint < Blueprinter::Base
  identifier :id

  fields :vendor_name, :vendor_type, :contact_person, :phone, :email,
         :contract_amount, :paid_amount, :notes, :created_at

  field :balance_due
end
