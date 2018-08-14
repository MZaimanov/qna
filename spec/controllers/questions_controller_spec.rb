require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3)}
    before { get :index }

    it 'Заполняет массив всех вопросов' do
      expect(assigns(:questions)).to match_array (questions)
    end
    it 'Отрендерить index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'Установить запрошенную переменую в @question' do
      expect(assigns(:question)).to eq question
    end

    it 'Назначить новый ответ для вопроса' do
      expect(assigns(:answer)).to be_a_new (Answer)
    end

    it 'Отрендерить index show' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }
    it 'Создает новый вопрос и присваивает ег переменой @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'Отрендерить new index' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, params: { id: question } }

    it 'Установить запрошенную переменую в @question' do
      expect(assigns(:question)).to eq question
    end

    it 'Отрендерить edit index' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'Создание валидного объекта с правильными атрибутами'do
      it 'Сохранение нового question в БД' do
        expect { post :create, params: { question: attributes_for(:question)} }.to change(Question, :count).by(1)
      end
      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'Передача не верных параметров' do
      it 'Новый вопрос НЕ СОХРОНЯЕТСЯ' do
        expect { post :create, params: { question: attributes_for(:invalid_question)} }.to_not change(Question, :count)
      end

      it 're-render view new' do
        post :create, params: { question: attributes_for(:invalid_question)}
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH  #update' do
    sign_in_user
    context 'Правильные атрибуты' do
      it 'Установить запрошенную переменую в @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'Атрибуты изменены' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'Редирект на обновленный question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'Неверные параметры' do
      before { patch :update, params: { id: question, question: { title: 'new title', body: nil } } }

      it 'Не изменяются атрибуты question' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-render view new' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE  #destroy' do
    sign_in_user
    before { question }

    it 'Удаление question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end
    it 'Перенаправление на index view' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to question_path
    end
  end
end
