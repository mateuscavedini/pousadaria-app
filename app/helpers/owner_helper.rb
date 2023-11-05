module OwnerHelper
  def owner_description(owner)
    "#{owner.name} | #{owner.email}"
  end
end