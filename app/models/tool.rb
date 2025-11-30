class Tool < ApplicationRecord

  def display_name
    "#{name} - #{description}"
  end
end
