# frozen_string_literal: true

class StvWlmServiceClassState < Redshift
  self.table_name = 'stv_wlm_service_class_state'
  default_scope -> { order(:service_class) }
end
