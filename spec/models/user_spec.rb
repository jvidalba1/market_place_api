require 'rails_helper'

RSpec.describe User, type: :model do
  
  let(:user) { FactoryGirl.build(:user) }

  subject { user } 

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:auth_token) }

  it { should be_valid }

  it { is_expected.to validate_confirmation_of :password }
  it { is_expected.to allow_value('example@domain.com').for(:email) }

  describe 'validations' do 
    context 'when email is not present' do
      it { is_expected.to validate_presence_of :email }

      it 'should be no valid' do 
        user.email = " "
        expect(user).not_to be_valid
      end
    end
  end

  it { is_expected.to validate_uniqueness_of(:auth_token) }

  describe '#generate_authentication_token!' do 
    it "generates a unique token" do
      Devise.stub(:friendly_token).and_return("auniquetoken123")
      user.generate_authentication_token!
      expect(user.auth_token).to eql "auniquetoken123"
    end

    it "generates another token when one already has been taken" do
      existing_user = FactoryGirl.create(:user, auth_token: "auniquetoken123")
      user.generate_authentication_token!
      expect(user.auth_token).not_to eql existing_user.auth_token
    end
  end

end
