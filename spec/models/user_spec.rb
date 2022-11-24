require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    context 'task user' do
      it { should have_many(:task_users).class_name('Task').with_foreign_key('user_id') }
    end

    context 'task author' do
      it { should have_many(:task_authors).class_name('Task').with_foreign_key('author_id') }
    end
  end

  describe '#validations' do
    context 'when user name' do
      context 'presence' do
        it { should validate_presence_of(:name) }
      end

      context 'max length' do
        it { should validate_length_of(:name).is_at_most(35) }
      end
    end

    context 'when user surname' do
      context 'presence' do
        it { should validate_presence_of(:surname) }
      end

      context 'max length' do
        it { should validate_length_of(:surname).is_at_most(35) }
      end
    end
  end

  let(:user) { FactoryBot.create(:user) }

  describe '#full_name' do
    it 'returns correctly written full name' do
      expect(user.full_name).to eq "#{user.name} #{user.surname}"
    end
  end
end
