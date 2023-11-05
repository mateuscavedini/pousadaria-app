module ContactHelper
  def contact_description(contact)
    "#{contact.email} | #{contact.phone}"
  end
end