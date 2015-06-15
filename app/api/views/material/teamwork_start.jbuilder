# if @teamwork.present?
#   json.result 0
#   json.teamwork do
#     json.id = @teamwork.id
#     json.total_work = @teamwork.total_work
#     json.percent = @teamwork.get_user_percent(current_user.id)
#   end
#   json.user current_user
#   json.reward @material.team_reward
#
# else
#
# end

json.result @flag
#已经在某个团队合作中，且还未结束
if @flag == 0

#加入别人创建好的团队协作活动
elsif @flag == 1

#自己创建一个
elsif @flag == 2

# 手速慢了  teamwork 已经不存在了
elsif @flag == 3

# 没有这个应用 或者当前应用不是团队合作应用
else
  render_api_error! '资源不存在'
end