require_relative 'assoc_options'

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    self.foreign_key = "#{self_class_name.downcase}_id".to_sym
    self.primary_key = "id".to_sym
    self.class_name = name.to_s.camelcase.singularize

    options.each do |attr_name, overriddance|
      send("#{attr_name}=".to_sym, overriddance)
    end
  end
end
