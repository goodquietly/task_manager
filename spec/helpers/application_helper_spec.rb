require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#table_tr_color' do
    let(:task_created) { create(:task, status: :created) }
    let(:task_started) { create(:task, status: :started) }
    let(:task_finished) { create(:task, status: :finished) }

    context 'when task status created' do
      it 'returns the default title' do
        expect(helper.table_tr_color(task_created.status)).to eq('warning')
      end
    end

    context 'when task status started' do
      it 'returns the default title' do
        expect(helper.table_tr_color(task_started.status)).to eq('info')
      end
    end

    context 'when task status finished' do
      it 'returns the default title' do
        expect(helper.table_tr_color(task_finished.status)).to eq('success')
      end
    end
  end
end
