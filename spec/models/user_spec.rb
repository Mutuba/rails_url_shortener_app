require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'user creation' do
    context 'when user details are correct' do
      it 'it creates a user' do
        user = User.create(email: 'testuser@gmail.com', password: 'asdf123456789',
                           password_confirmation: 'asdf123456789')
        expect(user).to be_valid
        expect(user.email).to eq 'testuser@gmail.com'
      end
    end

    context 'when user details are not correct' do
      context 'when password is too short' do
        it 'it does not create a user' do
          user = User.create(email: 'testuser@gmail.com', password: 'asdf',
                             password_confirmation: 'asdf')
          expect(user).to be_invalid
          expect(user.errors.messages[:password]).to include("is too short (minimum is 6 characters)")
          expect(user.errors.messages[:password][0]).to eq 'is too short (minimum is 6 characters)'
        end
      end

      context 'when passwords do not match' do
        it 'it does not create a user' do
          user = User.create(email: 'testuser@gmail.com', password: 'asdf12345678',
                             password_confirmation: 'asdf124125224')
          expect(user).to be_invalid
          expect(user.errors.messages[:password_confirmation]).to include("doesn't match Password")
          expect(user.errors.messages[:password_confirmation][0]).to eq "doesn't match Password"
        end
      end
    end
  end
end
