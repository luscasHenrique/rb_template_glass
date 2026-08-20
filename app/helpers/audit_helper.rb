module AuditHelper
  # Recebe a versão do PaperTrail e devolve o Usuário dono do registro
  def audit_owner_for(version)
    affected_record = version.item || version.reify 
    return nil unless affected_record

    case version.item_type
    when "User"
      affected_record
    when "Profile"
      affected_record.respond_to?(:user) ? affected_record.user : nil
    when "Address", "TrackingIntegration"
      parent = affected_record.respond_to?(:addressable) ? affected_record.addressable : affected_record.try(:profile)
      parent.try(:user)
    else
      nil
    end
  end
end