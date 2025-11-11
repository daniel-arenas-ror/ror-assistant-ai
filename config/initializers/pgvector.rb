require 'pgvector'

ActiveSupport.on_load(:active_record) do
  if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
    begin
      conn = ActiveRecord::Base.connection.raw_connection # Get the underlying PG::Connection
      if conn
        registry = PG::BasicTypeRegistry.new.define_default_types
        Pgvector::PG.register_vector(registry)
        conn.type_map_for_results = PG::BasicTypeMapForResults.new(conn, registry: registry)
      end
    rescue StandardError => e
      Rails.logger.warn "Failed to register pgvector types: #{e.message}"
    end
  end
end
