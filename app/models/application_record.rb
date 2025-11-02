class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.ransackable_attributes(auth_object = nil)
    self.column_names
  end

  def self.ransackable_associations(auth_object = nil)
    self.reflect_on_all_associations.collect{|r| r.name.to_s}
  end
end
