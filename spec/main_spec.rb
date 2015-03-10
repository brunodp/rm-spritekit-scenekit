describe "Application 'spritekit-scenekit'" do
  before do
    @app = UIApplication.sharedApplication
  end

  it "returns fun" do
    @app.should == :fun
  end
end
