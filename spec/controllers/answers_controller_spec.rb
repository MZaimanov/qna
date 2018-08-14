require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:question) { create :question }
    context 'Создание валидного объекта с правильными атрибутами'do
      it 'Сохранение нового вопроса в БД' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question} }.to change(question.answers, :count).by(1)
      end
      it 'redirect to question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Передача не верных параметров' do
      it 'Новый вопрос НЕ СОХРОНЯЕТСЯ' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }.to_not change(Answer, :count)
      end

      it 'redirect to question show view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

end
