class Document
  include Mongoid::Document
  include Mongoid::Locker
  
  field :title, type: String
  
  self.timeout = 1
  
end
