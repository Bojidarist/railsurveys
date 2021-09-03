module VotesHelper
  def can_vote_cookie?(answer)
    if cookies[:num_votes].nil?
      cookies[:num_votes] = { :num_votes => [ { :survey_id => answer.survey_id, :vote => true } ] }.to_json
    else
      num_votes_cookie = JSON.parse(cookies[:num_votes])
      is_survey_in_cookie = false

      num_votes_cookie["num_votes"].each do |value|
        if value["survey_id"] == answer.survey_id
          is_survey_in_cookie = true
          if value["vote"]
            return false
          else
            num_votes_cookie["num_votes"].append( { :survey_id => answer.survey_id, :vote => true } )
            cookies[:num_votes] = num_votes_cookie.to_json
          end
        end
      end

      unless is_survey_in_cookie
        num_votes_cookie["num_votes"].append( { :survey_id => answer.survey_id, :vote => true } )
        cookies[:num_votes] = num_votes_cookie.to_json
      end
    end

    return true
  end

  def can_vote_ip?(survey)
    geo_vote = survey.geo_votes.find_by(ip_address: request.remote_ip)
    if geo_vote.nil?
      survey.geo_votes.create(ip_address: request.remote_ip, votes: 1)
    else
      if geo_vote.votes >= 5
        return false
      else
        geo_vote.update({ :votes => geo_vote.votes + 1 })
      end
    end

    return true
  end
end
