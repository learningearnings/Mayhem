require_relative './base_importer'

module Importers
  class Le
    class GameQuestionsImporter < BaseImporter
      protected
      def run
        question_data.each do |datum|
          create_question(datum)
        end
      end

      def question_data
        parsed_doc.map do |datum|
          {
            question: {
              body: datum["question"],
              grade: datum["grade_level"],
              game_type: game_type
            },
            category: {
              subject: datum["subject"]
            },
            answers: {
              correct_answer: datum["correct_answer"],
              incorrect1: datum["incorrect1"],
              incorrect2: datum["incorrect2"],
              incorrect3: datum["incorrect3"]
            }
          }
        end
      end

      def existing_category(subject)
        Games::QuestionCategory.where(subject: subject).first || Games::QuestionCategory.create(subject: subject)
      end

      def create_question(datum)
        category = existing_category(datum[:category][:subject])
        question = Games::Question.new(datum[:question])
        question.category = category
        question.save

        # Create answers...
        find_or_create_answer(datum[:answers][:correct_answer], question, true)
        find_or_create_answer(datum[:answers][:incorrect1], question)
        find_or_create_answer(datum[:answers][:incorrect2], question)
        find_or_create_answer(datum[:answers][:incorrect3], question)
      end

      def find_or_create_answer(body, question, correct=false)
        answer = Games::Answer.where(game_type: game_type, body: body).first || Games::Answer.create(game_type: game_type, body: body)
        if answer.id && question.id
          link = Games::QuestionAnswer.where(question_id: question.id, answer_id: answer.id, correct: correct).first || Games::QuestionAnswer.create!(question_id: question.id, answer_id: answer.id, correct: correct)
        end
      end

      def game_type
        "FoodFight"
      end
    end
  end
end
