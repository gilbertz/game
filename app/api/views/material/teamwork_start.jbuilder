if @teamwork.present?
  json.result 0
  json.teamwork do
    json.id = @teamwork.id
    json.total_work = @teamwork.total_work
    json.percent = @teamwork.get_user_percent(current_user.id)
  end
  json.user current_user
  json.reward @material.team_reward

else
  render_api_error! '资源不存在'
end