module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      FactoryGirl.create_list(:role, 2)
      admin = FactoryGirl.create(:user)  
      user = FactoryGirl.create(:user)  
      sign_in admin
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      FactoryGirl.create_list(:role, 2)
      admin = FactoryGirl.create(:user)  
      user = FactoryGirl.create(:user)  
      sign_in user
    end
  end
end
