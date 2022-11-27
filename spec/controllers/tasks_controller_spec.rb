require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:task) { create(:task) }
  let(:user) { create(:user) }

  describe '#set_task' do
    it 'should use before_action' do
      should use_before_action(:set_task)
    end
  end

  describe '#index' do
    it 'should route get to tasks#index' do
      should route(:get, '/tasks').to(action: :index)
    end

    context 'when anonim' do
      before do
        get :index
      end

      it 'status is not 200 OK' do
        expect(response.status).not_to eq(200)
      end

      it 'status is 302 OK' do
        expect(response.status).to eq(302)
      end

      it 'should not rendered template index' do
        expect(response).not_to render_template(:index)
      end

      it 'should redirect to authorization' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'it must be flash alert' do
        expect(flash[:alert]).to be
      end

      it 'should be flash with content' do
        should set_flash.to('You are not allowed to perform this action.')
      end
    end

    context 'when user' do
      before do
        sign_in user
        get :index
      end

      it 'status is 200 OK' do
        expect(response.status).to eq(200)
      end

      it 'status is 302 OK' do
        expect(response.status).not_to eq(302)
      end

      it 'should rendered template index' do
        expect(response).to render_template(:index)
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

  describe '#show' do
    it 'should route get to tasks#show' do
      should route(:get, "/tasks/#{task.id}").to(action: :show, id: task.id)
    end

    context 'when anonim' do
      before do
        get :show, params: { id: task.id }
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

      it 'should be flash with content' do
        should set_flash.to('You are not allowed to perform this action.')
      end
    end

    context 'when user' do
      context 'when task id is fake' do
        let(:fake_id) { 789_789 }

        before do
          sign_in user
          get :show, params: { id: fake_id }
        end

        it 'status is 302' do
          expect(response.status).to eq(302)
        end

        it 'should not rendered template edit' do
          expect(response).not_to render_template(:edit)
        end

        it 'should redirect to root' do
          expect(response).to redirect_to(root_path)
        end

        it "it shouldn't be an flash alert" do
          expect(flash[:alert]).to be
        end

        it 'should be flash with content' do
          should set_flash.to('The task with the given ID does not exist! Choose another.')
        end
      end

      context 'when the task ID is in the database' do
        before do
          sign_in user
          get :show, params: { id: task.id }
        end

        it 'status is 200 OK' do
          expect(response.status).to eq(200)
        end

        it 'should rendered template show' do
          expect(response).to render_template(:show)
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

  describe '#new' do
    it 'should route get to tasks#new' do
      should route(:get, '/tasks/new').to(action: :new)
    end

    context 'when anonim' do
      before do
        get :new
      end

      it 'status is 302 OK' do
        expect(response.status).to eq(302)
      end

      it 'should not rendered template new' do
        expect(response).not_to render_template(:new)
      end

      it 'should redirect to authorization' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'it must be flash alert' do
        expect(flash[:alert]).to be
      end

      it 'should be flash with content' do
        should set_flash.to('You are not allowed to perform this action.')
      end
    end

    context 'when user' do
      before { sign_in user }

      context 'when there is a task executor' do
        before do
          get :new, params: { id: user.id }
        end

        it 'status is 200 OK' do
          expect(response.status).to eq(200)
        end

        it 'should rendered template new' do
          expect(response).to render_template(:new)
        end

        it "it shouldn't be an flash alert" do
          expect(flash[:alert]).not_to be
        end

        it 'should rendered with layout application' do
          should render_with_layout('application')
        end
      end

      context 'when there is no task executor' do
        before do
          get :new
        end

        it 'status is 302' do
          expect(response.status).to eq(302)
        end

        it 'should redirect to /' do
          expect(response).to redirect_to(root_path)
        end

        it 'it must be flash alert' do
          expect(flash[:alert]).to be
        end

        it 'should be flash with content' do
          should set_flash.to('The user with the given ID does not exist! Choose another.')
        end
      end
    end
  end

  describe '#create' do
    it 'should route post to tasks#create' do
      should route(:post, '/tasks').to(action: :create)
    end

    context 'when anonim' do
      before do
        post :create, params: { task: { title: task.title, user_id: user.id } }
      end

      it 'status is 302 OK' do
        expect(response.status).to eq(302)
      end

      it 'should redirect to authorization' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'it must be flash alert' do
        expect(flash[:alert]).to be
      end

      it 'should be flash with content' do
        should set_flash.to('You are not allowed to perform this action.')
      end
    end

    context 'when user' do
      let(:task_user) { create(:user) }

      context 'when the task is successfully saved' do
        before do
          sign_in user
          post :create, params: { task: { title: 'new task', user_id: task_user.id } }
        end

        let(:new_task) { Task.where(title: 'new task', user_id: task_user.id) }

        it 'status is 302' do
          expect(response.status).to eq(302)
        end

        it 'should redirect to task path' do
          expect(response).to redirect_to(task_path(new_task.ids))
        end

        it 'it must be flash notice' do
          expect(flash[:notice]).to be
        end

        it 'should be flash with content' do
          should set_flash.to('Task successfully created!')
        end

        it 'should rendered with layout mailer' do
          should render_with_layout('mailer')
        end
      end

      context 'when the task is not successfully saved' do
        before do
          sign_in user
          post :create, params: { task: { title: '', user_id: task_user.id } }
        end

        it 'status is 200 OK' do
          expect(response.status).to eq(200)
        end

        it 'should be rendered new template' do
          expect(response).to render_template(:new)
        end

        it 'it must be flash alert' do
          expect(flash[:alert]).to be
        end

        it 'should be flash now with content' do
          should set_flash.now.to('You filled in the Title field incorrectly')
        end

        it 'should rendered with layout application' do
          should render_with_layout('application')
        end
      end
    end
  end

  describe '#edit' do
    it 'should route get to tasks#edit' do
      should route(:get, "/tasks/#{task.id}/edit").to(action: :edit, id: task.id)
    end

    context 'when anonim' do
      before do
        get :edit, params: { id: task.id }
      end

      it 'status is 302' do
        expect(response.status).to eq(302)
      end

      it 'should not rendered template new' do
        expect(response).not_to render_template(:edit)
      end

      it 'should redirect to authorization' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'it must be flash alert' do
        expect(flash[:alert]).to be
      end

      it 'should be flash with content' do
        should set_flash.to('You are not allowed to perform this action.')
      end
    end

    context 'when user' do
      context 'when task id is fake' do
        let(:fake_id) { 789_789 }

        before do
          sign_in user
          get :edit, params: { id: fake_id }
        end

        it 'status is 302' do
          expect(response.status).to eq(302)
        end

        it 'should not rendered template edit' do
          expect(response).not_to render_template(:edit)
        end

        it 'should redirect to root' do
          expect(response).to redirect_to(root_path)
        end

        it "it shouldn't be an flash alert" do
          expect(flash[:alert]).to be
        end

        it 'should be flash with content' do
          should set_flash.to('The task with the given ID does not exist! Choose another.')
        end
      end

      context 'when the task ID is in the database' do
        context 'when the user is not the author of the task' do
          before do
            sign_in user
            get :edit, params: { id: task.id }
          end

          it 'return status is 302' do
            expect(response.status).to eq(302)
          end

          it 'should not rendered template edit' do
            expect(response).not_to render_template(:edit)
          end

          it 'it should redirect to root path' do
            expect(response).to redirect_to(root_path)
          end

          it 'it must be flash alert' do
            expect(flash[:alert]).to be
          end

          it 'should be flash with content' do
            should set_flash.to('You are not allowed to perform this action.')
          end
        end

        context 'when the user is the author of the task' do
          let(:task_with_author) { create(:task, author_id: user.id) }

          before do
            sign_in user
            get :edit, params: { id: task_with_author.id }
          end

          it 'return status is 200 OK' do
            expect(response.status).to eq(200)
          end

          it 'should rendered template edit' do
            expect(response).to render_template(:edit)
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
  end

  describe '#update' do
    it 'should route post to patch#update' do
      should route(:patch, "/tasks/#{task.id}").to(action: :update, id: task.id)
    end

    context 'when anonim' do
      before do
        patch :update, params: { id: task.id }
      end

      it 'status is 302' do
        expect(response.status).to eq(302)
      end

      it 'should redirect to authorization' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'it must be flash alert' do
        expect(flash[:alert]).to be
      end

      it 'should be flash with content' do
        should set_flash.to('You are not allowed to perform this action.')
      end
    end

    context 'when user' do
      context 'when task id is fake' do
        let(:fake_id) { 789_789 }

        before do
          sign_in user
          patch :update, params: { id: fake_id }
        end

        it 'status is 302' do
          expect(response.status).to eq(302)
        end

        it 'should not rendered template edit' do
          expect(response).not_to render_template(:edit)
        end

        it 'should redirect to root' do
          expect(response).to redirect_to(root_path)
        end

        it "it shouldn't be an flash alert" do
          expect(flash[:alert]).to be
        end

        it 'should be flash with content' do
          should set_flash.to('The task with the given ID does not exist! Choose another.')
        end
      end

      context 'when the task ID is in the database' do
        context 'when the user is not the author of the task' do
          before do
            sign_in user
            patch :update, params: { id: task.id }
          end

          it 'return status is 302' do
            expect(response.status).to eq(302)
          end

          it 'should not rendered template edit' do
            expect(response).not_to render_template(:edit)
          end

          it 'it should redirect to root path' do
            expect(response).to redirect_to(root_path)
          end

          it 'it must be flash alert' do
            expect(flash[:alert]).to be
          end

          it 'should be flash with content' do
            should set_flash.to('You are not allowed to perform this action.')
          end
        end

        context 'when the user is the author of the task and task status not finished' do
          context 'when the task is successfully update' do
            let(:task_with_author) { create(:task, author_id: user.id, status: :started) }

            before do
              sign_in user
              patch :update, params: {
                task: { title: task_with_author.title, user_id: user.id }, id: task_with_author.id
              }
            end

            it 'status is 302' do
              expect(response.status).to eq(302)
            end

            it 'should redirect to task path' do
              expect(response).to redirect_to(task_path(task_with_author))
            end

            it 'it must be flash notice' do
              expect(flash[:notice]).to be
            end

            it 'should be flash with content' do
              should set_flash.to('The task has been successfully updated!')
            end

            it 'should rendered with layout mailer' do
              should render_with_layout('mailer')
            end
          end

          context 'when the task is not successfully update' do
            let(:task_with_author) { create(:task, author_id: user.id) }

            before do
              sign_in user
              patch :update, params: {
                task: { title: '', user_id: user.id, status: :started }, id: task_with_author.id
              }
            end

            it 'status is 200 OK' do
              expect(response.status).to eq(200)
            end

            it 'should be rendered edit template' do
              expect(response).to render_template(:edit)
            end

            it 'it must be flash alert' do
              expect(flash[:alert]).to be
            end

            it 'should be flash now with content' do
              should set_flash.now.to('You filled in the Title field incorrectly.')
            end

            it 'should rendered with layout application' do
              should render_with_layout('application')
            end
          end
        end

        context 'when the user is the author of the task and task status finished' do
          let(:task_with_author) { create(:task, author_id: user.id, status: :finished) }

          before do
            sign_in user
            patch :update, params: {
              task: { title: task_with_author.title, user_id: user.id }, id: task_with_author.id
            }
          end

          it 'task status should be finished' do
            expect(task_with_author.status).to eq('finished')
          end

          it 'status is 302' do
            expect(response.status).to eq(302)
          end

          it 'should redirect to root path' do
            expect(response).to redirect_to(root_path)
          end

          it 'it must be flash alert' do
            expect(flash[:alert]).to be
          end

          it 'should be flash with content' do
            should set_flash.to('You are not allowed to perform this action.')
          end
        end
      end
    end
  end

  describe '#destroy' do
    it 'should route delete to delete#destroy' do
      should route(:delete, "/tasks/#{task.id}").to(action: :destroy, id: task.id)
    end

    context 'when anonim' do
      before do
        put :destroy, params: { id: task.id }
      end

      it 'status is 302' do
        expect(response.status).to eq(302)
      end

      it 'should redirect to authorization' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'it must be flash alert' do
        expect(flash[:alert]).to be
      end

      it 'should be flash with content' do
        should set_flash.to('You are not allowed to perform this action.')
      end
    end

    context 'when user' do
      context 'when task id is fake' do
        let(:fake_id) { 789_789 }

        before do
          sign_in user
          delete :destroy, params: { id: fake_id }
        end

        it 'status is 302' do
          expect(response.status).to eq(302)
        end

        it 'should redirect to root' do
          expect(response).to redirect_to(root_path)
        end

        it "it shouldn't be an flash alert" do
          expect(flash[:alert]).to be
        end

        it 'should be flash with content' do
          should set_flash.to('The task with the given ID does not exist! Choose another.')
        end
      end

      context 'when the task ID is in the database' do
        context 'when the user is not the author of the task' do
          before do
            sign_in user
            delete :destroy, params: { id: task.id }
          end

          it 'return status is 302' do
            expect(response.status).to eq(302)
          end

          it 'it should redirect to root path' do
            expect(response).to redirect_to(root_path)
          end

          it 'it must be flash alert' do
            expect(flash[:alert]).to be
          end

          it 'should be flash with content' do
            should set_flash.to('You are not allowed to perform this action.')
          end
        end

        context 'when the user is the author of the task' do
          context 'when task status finished' do
            let(:task_with_author_finished) { create(:task, user_id: user.id, status: :finished) }

            before do
              sign_in user
              delete :destroy, params: { id: task_with_author_finished.id }
            end

            it 'task status should be finished' do
              expect(task_with_author_finished.status).to eq('finished')
            end

            it 'status is 302' do
              expect(response.status).to eq(302)
            end

            it 'should redirect to root path' do
              expect(response).to redirect_to(root_path)
            end

            it 'it must be flash alert' do
              expect(flash[:alert]).to be
            end

            it 'should be flash with content' do
              should set_flash.to('You are not allowed to perform this action.')
            end
          end

          context 'when task status not finished' do
            let(:task_with_author) { create(:task, user_id: user.id) }

            before do
              sign_in user
              delete :destroy, params: { id: task_with_author.id }
            end

            it 'status is 302' do
              expect(response.status).to eq(302)
            end

            it 'should redirect to task path' do
              expect(response).to redirect_to(root_path)
            end

            it 'it must be flash notice' do
              expect(flash[:notice]).to be
            end

            it 'should be flash with content' do
              should set_flash.to('The task was successfully deleted.')
            end

            it 'should rendered with layout mailer' do
              should render_with_layout('mailer')
            end
          end
        end
      end
    end
  end

  describe '#update_status' do
    it 'should route put to put#update_status' do
      should route(:put, "/tasks/#{task.id}/update_status").to(action: :update_status, id: task.id)
    end

    context 'when anonim' do
      before do
        put :update_status, params: { id: task.id }
      end

      it 'status is 302' do
        expect(response.status).to eq(302)
      end

      it 'should redirect to authorization' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'it must be flash alert' do
        expect(flash[:alert]).to be
      end

      it 'should be flash with content' do
        should set_flash.to('You are not allowed to perform this action.')
      end
    end

    context 'when user' do
      context 'when task id is fake' do
        let(:fake_id) { 789_789 }

        before do
          sign_in user
          put :update_status, params: { id: fake_id }
        end

        it 'status is 302' do
          expect(response.status).to eq(302)
        end

        it 'should redirect to root' do
          expect(response).to redirect_to(root_path)
        end

        it "it shouldn't be an flash alert" do
          expect(flash[:alert]).to be
        end

        it 'should be flash with content' do
          should set_flash.to('The task with the given ID does not exist! Choose another.')
        end
      end

      context 'when the task ID is in the database' do
        context 'when the user is not the executor of the task' do
          before do
            sign_in user
            put :update_status, params: { id: task.id }
          end

          it 'return status is 302' do
            expect(response.status).to eq(302)
          end

          it 'it should redirect to authorization' do
            expect(response).to redirect_to(root_path)
          end

          it 'it must be flash alert' do
            expect(flash[:alert]).to be
          end

          it 'should be flash with content' do
            should set_flash.to('You are not allowed to perform this action.')
          end
        end

        context 'when the user is the executor of the task and task status created' do
          let(:task_with_executor) { create(:task, user_id: user.id) }

          before do
            sign_in user
            put :update_status, params: { id: task_with_executor.id }
          end

          it 'status is 302' do
            expect(response.status).to eq(302)
          end

          it 'should redirect to task path' do
            expect(response).to redirect_to(task_path(task_with_executor))
          end

          it 'it must be flash notice' do
            expect(flash[:notice]).to be
          end

          it 'should be flash with content' do
            should set_flash.to('Task status changed!')
          end

          it 'should rendered with layout mailer' do
            should render_with_layout('mailer')
          end
        end

        context 'when the user is the executor of the task and task status created' do
          let(:task_with_executor) { create(:task, user_id: user.id, status: :started) }

          before do
            sign_in user
            put :update_status, params: { id: task_with_executor.id }
          end

          it 'status is 302' do
            expect(response.status).to eq(302)
          end

          it 'should redirect to task path' do
            expect(response).to redirect_to(task_path(task_with_executor))
          end

          it 'it must be flash notice' do
            expect(flash[:notice]).to be
          end

          it 'should be flash with content' do
            should set_flash.to('Task status changed!')
          end

          it 'should rendered with layout mailer' do
            should render_with_layout('mailer')
          end
        end

        context 'when the user is the executor of the task and task status finished' do
          let(:task_with_executor) { create(:task, user_id: user.id, status: :finished) }

          before do
            sign_in user
            put :update_status, params: { id: task_with_executor.id }
          end

          it 'task status should be finished' do
            expect(task_with_executor.status).to eq('finished')
          end

          it 'status is 302' do
            expect(response.status).to eq(302)
          end

          it 'should redirect to root path' do
            expect(response).to redirect_to(root_path)
          end

          it 'it must be flash alert' do
            expect(flash[:alert]).to be
          end

          it 'should be flash with content' do
            should set_flash.to('You are not allowed to perform this action.')
          end
        end
      end
    end
  end
end
