require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:question) { create :question }
    context 'Создание валидного объекта с правильными атрибутами'do
      it 'Сохранение нового вопроса в БД' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }.to change(question.answers, :count).by(1)
      end
      it 'redirect to question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response.body).to be_blank
      end
    end

    context 'Передача не верных параметров' do
      it 'Новый вопрос НЕ СОХРОНЯЕТСЯ' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js } }.to_not change(Answer, :count)
      end

      it 'redirect to question show view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

end
