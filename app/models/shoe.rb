require_relative '../../lib/active_record_lite/sql_object.rb'

class Shoe < SQLObject
  belongs_to :pant
  self.finalize!
end
