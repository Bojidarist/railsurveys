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
		number_of_empty_answers(answer_params) > 3
	end

	private
	def number_of_empty_answers(answer_params)
		empty_answers = 0
		answer_params.each do |key, value|
		  if value.empty?
			empty_answers += 1
		  end
		end
	
		empty_answers
	end
end
