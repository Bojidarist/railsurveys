module VotesHelper
  def can_vote_cookie?(answer)
    if cookies["voted_#{answer.survey_id}"].nil?
      cookies["voted_#{answer.survey_id}"] = true

      return true
    end

    return false
  end

  def can_vote_ip?(survey)
    geo_vote = survey.geo_votes.where(ip_address: request.remote_ip).first_or_create(votes: 0)

    return false if geo_vote.votes >= 5

    geo_vote.increment(:votes)
    geo_vote.save()

    return true
  end
end
