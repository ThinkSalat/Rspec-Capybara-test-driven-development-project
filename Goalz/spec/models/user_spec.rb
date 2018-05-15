# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  session_token   :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  
  subject(:user) { User.create(username:'user',password:'password')}
  
  describe 'validations' do 
    it {should validate_presence_of(:username)}
    it { is_expected.to validate_presence_of(:username)}
    it {should validate_presence_of(:password_digest)}
    it {should validate_presence_of(:session_token)}
    it {should validate_uniqueness_of(:username)}
    it {should validate_uniqueness_of(:session_token)}
    
    it {should validate_length_of(:password).is_at_least(6)}
  end
  
  
  describe 'session_token' do
    it 'assigns a session token' do 
      user.valid?
      expect(user.session_token).to_not be_nil
    end
  end
  describe '::find_by_credentials' do
    context 'when valid' do
      it 'returns a user' do
        our_user = User.create(username:'user',password:'password')
        expect(User.find_by_credentials('user','password')).to be_instance_of(User)
      end
    end
    
    context 'when invalid' do
      it 'returns nil' do 
        expect(User.find_by_credentials('user','pass')).to be_nil
      end 
    end
  end
  
  
  describe '#password=' do 
    it 'uses BCrypt to create a password hash' do 
      
      expect(BCrypt::Password).to receive(:create).with("password")
      
      our_user = User.new(username:'user', password:'password')
      puts  our_user.attributes
    
    end 
  end 
  
  
  describe '#is_password?' do 
    context 'when correct password' do 
      it 'returns true is password is correct' do
        expect(user.is_password?('password')).to be true
      end
    end
    context 'when incorrect password' do 
      it 'returns false is password is incorrect' do
        expect(user.is_password?('passasdfsdafasword')).to be false
      end
    end
  end  
  
  
end
