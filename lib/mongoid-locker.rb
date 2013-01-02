module Mongoid
  module Locker
    extend ActiveSupport::Concern

    included do
      require 'state_machine'

      attr_accessor :locked_at

      class_attribute :timeout
      self.timeout = 30

      state_machine :state, :initial => :unlocked do
        before_transition :locked => :locked, :if => :can_relock?, :do => :reset_lock
        before_transition :unlocked => :locked, :do => :set_lock
        before_transition :locked => :unlocked, :do => :clear_lock
 
         event :lock do
           transition :unlocked => :locked
           transition :locked => :locked, :if => :can_relock?
           transition :locked => same, :do => :raise_lock_error
         end
     
         event :unlock do
           transition :locked => :unlocked, :do => :clear_lock
           transition :unlocked => same # Should there be an error?
         end             
       end
    end

    def set_lock
      @locked_at = Time.now
    end

    def clear_lock
      @locked_at = nil
    end

    def can_relock?
      return self.locked_at ? ((Time.now - self.locked_at ) > timeout) : true
    end
      
    def raise_lock_error
      raise Mongoid::Locker::IsLockedException("is already locked")
    end
  
    class IsLockedException < Exception
    end
    
  end
end
