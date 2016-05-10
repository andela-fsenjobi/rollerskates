	
require "spec_helper"
 
describe "Utility Methods" do
  context "#snakize" do
    context "PersonController" do
      it { expect("PersonController".snakize).to eq "person_controller" }
    end
 
    context "Person" do
      it { expect("Person".snakize).to eq "person" }
    end
 
    context "Todo::Person" do
      it { expect("Todo::Person".snakize).to eq "todo/person" }
    end
 
    context "PERSONController" do
      it { expect("PERSONController".snakize).to eq "person_controller" }
    end
 
    context "Person8Controller" do
      it { expect("Person8Controller".snakize).to eq "person8_controller" }
    end
 
    context "personcontroller" do
      it { expect("personcontroller".snakize).to eq "personcontroller" }
    end
 
    context "person" do
      it { expect("person".snakize).to eq "person" }
    end
  end
end
