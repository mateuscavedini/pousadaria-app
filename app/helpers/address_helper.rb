module AddressHelper
  def address_description(address)
    description = "#{address.street_name}, #{address.street_number}, "
    description << "#{address.complement}, " unless address.complement.blank?
    description << "#{address.district}, #{address.postal_code}, #{address.city} - #{address.state}"
  end
end