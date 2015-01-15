require_relative 'assoc_options'

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    self.foreign_key = "#{name}_id".to_sym
    self.primary_key = "id".to_sym
    self.class_name = name.to_s.camelcase

    options.each do |attr_name, overriddance|
      send("#{attr_name}=".to_sym, overriddance)
    end
  end
end
