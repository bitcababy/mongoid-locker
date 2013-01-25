require 'active_support/concern'

module Mongoid
  module Locker
    extend ::ActiveSupport::Concern

    included do
      require 'state_machine'
  
    end

    module ClassMethods
      def enable_locking_with fn
        self.class_attribute :timeout
        self.timeout = 5*60
 
        field fn, type: Time, default: nil

        define_method :set_lock do 
          self[fn] = Time.now.localtime
        end

        define_method :clear_lock do
          self[fn] = nil
        end
    
        define_method :update_time do
          self[fn] = Time.now.localtime
        end

        define_method :timed_out? do
          return self[fn] ? ((Time.now.localtime - self.locked_at ) > self.class.timeout) : true
        end
      
        define_method :raise_lock_error do
          raise Mongoid::Locker::IsLockeredException("is already locked")
        end

        state_machine :state, :initial => :unlocked do
          before_transition any - :locked => :locked, :do => :set_lock
          before_transition :locked => :unlocked, :do => :clear_lock
          before_transition :on => :relock, :do => :set_lock
    
          event :lock do
            transition :unlocked => :locked
            transition :locked => :locked, :if => :timed_out?
            transition :locked => same, :do => :raise_lock_error
          end
     
          event :unlock do
            transition :locked => :unlocked
            transition :unlocked => same
          end
         
          event :relock do
            transition :locked => :locked, :do => :update_time
          end
         
          event :break_lock do
            transition any => :unlocked
          end
         
          state :locked do
            validates_presence_of :locked_at
          end

        end # state_machine
      end # lock_using
 
      class IsLockeredException < Exception
      end
    end #ClassMethods

     
  end
end
