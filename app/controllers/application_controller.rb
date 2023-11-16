class ApplicationController < ActionController::Base
  protected

  def devise_parameter_sanitizer
    if resource_class == Owner
      OwnerParameterSanitizer.new(Owner, :owner, params)
    elsif resource_class == Guest
      GuestParameterSanitizer.new(Guest, :guest, params)
    else
      super
    end
  end
end
