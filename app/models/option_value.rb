class OptionValue < ApplicationRecord
  belongs_to :company
  belongs_to :option_type

end
