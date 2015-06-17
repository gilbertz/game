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
 json.message "查看当前的团队活动成功!"
#加入别人创建好的团队协作活动
elsif @flag == 1
  json.message "加入团队成功!"
#自己创建一个
elsif @flag == 2
  json.message "发起活动成功!"

# 手速慢了  teamwork 已经不存在了
elsif @flag == 3
  json.message "手速慢了,其他小伙伴已经抢先加入,重开一局吧!"
# 没有这个应用 或者当前应用不是团队合作应用
else
  json.message '资源不存在'
end

if @flag == 0 || @flag == 1 || @flag == 2
  json.teamwork do
    json.id  @teamwork.id
    json.total_work  @teamwork.total_work
    json.state  @teamwork.state
    json.sponsor @teamwork.sponsor
  end
  json.partner_users(@partner_users) do |item|
    json.id  item.id
    json.name item.name
    json.profile_img_url item.profile_img_url
    json.sex item.sex
    json.city item.city
    json.expect_percent @teamwork.get_user_percent(item.id)
    json.result_percent @teamwork.get_result_percent(item.id)
  end
end
