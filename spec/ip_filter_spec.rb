require "spec_helper"

describe IpFilter do 
  context "Methods" do
    context "#ip_address?" do
      
      it "should success on IP range " do
        described_class.send(:"ip_address?", '1.2.3.4/1').should be_true
      end

      it "should success on IP " do
        described_class.send(:"ip_address?", '1.2.3.4').should be_true
      end

    end
  end
  
end