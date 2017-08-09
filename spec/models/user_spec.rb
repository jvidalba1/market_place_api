require 'rails_helper'

RSpec.describe User, type: :model do
  
  let(:user) { FactoryGirl.build(:user) }

  subject { user } 

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  describe 'validations' do 
    context 'when email is not present'
      it { is_expected.to validate_presence_of :email }
      # it { is_expected.to validate_uniqueness_of :email }
      it { is_expected.to validate_confirmation_of :password }
      it { is_expected.to allow_value('example@domain.com').for(:email) }

      it 'should be no valid' do 
        user.email = " "
        expect(user).not_to be_valid
      end
  end
end
