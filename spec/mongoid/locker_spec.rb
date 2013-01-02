#encoding: utf-8
require "spec_helper"

module Mongoid
  describe Locker do

    describe 'state machine' do
      
      describe ':lock' do
        subject { ::Document.create title: "Tale of Two Plugins", state: :unlocked }
        it { should be_unlocked }
        specify { subject.locked_at.should be_nil}
 
        it "should become locked if it's lockable" do
          subject.lock
          subject.should be_locked
        end
        
        it "should have a locked_at time" do
          subject.lock
          subject.locked_at.should_not be_nil
        end
        
        it "should not be timed_out" do
          subject.class.stub(:timeout).and_return 30
          subject.lock
          subject.can_relock?.should be_false
        end
          
        it "raises an exception if it's already locked" do
          subject.lock
          subject.lock.should raise_error
        end

        it "allows a new lock if it's timed out" do
          subject.class.stub(:timeout).and_return 1
          subject.lock
          sleep(5)
          subject.can_relock?.should be_true
        end
      end
      
      describe ':unlock' do
        subject { ::Document.create title: "Tale of Two Plugins" }
        it "should become unlocked when I unlock it" do
          subject.lock
          subject.unlock
          subject.should be_unlocked
        end
      end
        
    end
    
	end
end
