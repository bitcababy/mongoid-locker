#encoding: utf-8
require "spec_helper"

class Doc
  include Mongoid::Document
  include Mongoid::Locker
  
  field :title, type: String
  
  enable_locking_with :locked_at
  
  self.timeout = 1
  
end

module Mongoid
  describe Locker do

    describe 'state machine' do
      subject { Doc.create title: "Tale of Two Plugins" }
      [:lock, :unlock, :relock, :locked?, :unlocked?, :locked_at].each do |meth|
        it { should respond_to meth}
      end
      specify { subject.locked_at.should be_nil}
            
      describe ':lock' do
        subject { Doc.create title: "Tale of Two Plugins" }
 
        it "should become locked if it's lockable" do
          subject.lock
          subject.should be_locked
        end
        
        it "should have a locked_at time" do
          subject.lock
          subject.locked_at.should_not be_nil
        end
        
        it "should not be timed out" do
          subject.class.stubs(:timeout).returns 30
          subject.lock
          subject.timed_out?.should be_false
        end
          
        it "raises an exception if it's already locked" do
          subject.lock
          subject.lock.should raise_error
        end

        it "allows a new lock if it's timed out" do
          subject.class.stubs(:timeout).returns 1
          subject.lock
          sleep(5)
          subject.timed_out?.should be_true
        end
      end
      
      describe ':unlock' do
        subject { Doc.create title: "Tale of Two Plugins" }
        it "should become unlocked when I unlock it" do
          subject.lock
          subject.unlock
          subject.should be_unlocked
        end
      end
        
    end
    
	end
end
