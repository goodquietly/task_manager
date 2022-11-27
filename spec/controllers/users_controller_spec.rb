require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '#show' do
    let(:user) { create(:user) }

    it 'should routing get to users#show' do
      should route(:get, "/users/#{user.id}").to(action: :show, id: user.id)
    end

    context 'when anonim' do
      before do
        get :show, params: { id: user.id }
      end

      it 'status is not 200 OK' do
        expect(response.status).not_to eq(200)
      end

      it 'status is 302 OK' do
        expect(response.status).to eq(302)
      end

      it 'should not rendered template show' do
        expect(response).not_to render_template(:show)
      end

      it 'should redirect to authorization' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'it must be flash alert' do
        expect(flash[:alert]).to be
      end
    end

    context 'when user' do
      let(:task) { create(:task) }

      before do
        sign_in user
        get :show, params: { id: user.id }
      end

      it 'status is not 200 OK' do
        expect(response.status).to eq(200)
      end

      it 'should rendered template show' do
        expect(response).to render_template(:show)
      end

      it 'should redirect to authorization' do
        expect(response).not_to redirect_to(new_user_session_path)
      end

      it 'it must be flash alert' do
        expect(flash[:alert]).not_to be
      end

      it 'should rendered with layout application' do
        should render_with_layout('application')
      end
    end
  end
end
