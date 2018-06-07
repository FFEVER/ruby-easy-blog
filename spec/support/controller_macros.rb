# FactoryBot.define do
#   factory :user do
#     sequence(:email) { |n| "user#{n}@example.com" }
#     password '123456'
#     password_confirmation '123456'
#   end

#   factory :article do
#     title 'This is for testing'
#     text 'abcdefghijklmnopqrstuvwxyz 1234567890 !@#$$%^&*())_+?><MNBVCXZ":LKJHGFDSA}{OIUYTREWQ"'
#     user
#     association factory: :user
#   end
# end

# module ControllerMacros
#   def login_user
#     before(:each) do
#       @request.env["devise.mapping"] = Devise.mappings[:user]
#       user = FactoryBot.create(:user)
#       sign_in user
#     end
#   end
# end
