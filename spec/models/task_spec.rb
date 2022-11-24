require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'associations' do
    context 'task user' do
      it { should belong_to(:user).class_name('User') }
    end

    context 'task author' do
      it { should belong_to(:author).class_name('User') }
    end
  end

  describe '#validations' do
    context 'task title presence' do
      it { should validate_presence_of(:title) }
    end

    context 'task title max length' do
      it { should validate_length_of(:title).is_at_most(35) }
    end
  end

  describe '#status' do
    context 'task enum status' do
      it { should define_enum_for(:status).with_values(created: 0, started: 1, finished: 2) }
    end
  end
end
