# frozen_string_literal: true

module RequestLoginMacro
  def login_user
    # Before each test, create and login the user
    before(:each) do
      binding.pry
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user)
      sign_in user
    end
  end

  # Not used in this tutorial, but left to show an example of different user types
  # def login_admin
  #   before(:each) do
  #     @request.env["devise.mapping"] = Devise.mappings[:admin]
  #     sign_in FactoryBot.create(:admin) # Using factory bot as an example
  #   end
  # end
end
