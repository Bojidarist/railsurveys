module SurveysHelper
    def vote_as_percentage(current_answer, total_votes)
        vote_as_value(current_answer, total_votes) + "%"
    end

    def vote_as_value(current_answer, total_votes)
        # Prevent division by zero
        if total_votes == 0
            total_votes = 1
        end
        sprintf("%.0f", (current_answer.votes.to_f / total_votes) * 100)
    end

    def valid_number_of_answers?(answer_params)
        number_of_valid_answers(answer_params) >= 2
    end

    private
    def number_of_valid_answers(answer_params)
        answers_count = 0
        unless answer_params.nil?
            answer_params.each do |key, value|
                unless value["description"].empty?
                    answers_count += 1
                end
            end
        end
    
        answers_count
    end
end
