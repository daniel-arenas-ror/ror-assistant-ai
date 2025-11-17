require 'pgvector'

class RealEstate < ApplicationRecord
  #include Pgvector::Model
  #vector :embedding, limit: 3072

  belongs_to :company

  def embed_input
    <<~EOS
      name: #{name}
      code: #{code}
      url: #{url}
      price: #{price}
      description: #{description}
      amenities: #{amenities}
      location: #{location}
    EOS
  end

  def raw_update!(attributes)
    conn = ActiveRecord::Base.connection.raw_connection

    sql = <<-SQL
      UPDATE real_estates
      SET embedding = $1
      WHERE id = $2
      RETURNING id;
    SQL

    conn.exec_params(sql, [attributes[:embedding], id])
  end
end
