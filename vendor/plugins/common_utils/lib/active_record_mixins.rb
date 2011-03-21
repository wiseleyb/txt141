module ActiveRecordMixins
  class ActiveRecord::Base
    #this overrides the default_scope of models overriding this
    def self.find_without_scope(*args)
      self.with_exclusive_scope { find(*args) }
    end
    def self.find!(*args)
      self.find_without_scope(*args)
    end
  end
end
