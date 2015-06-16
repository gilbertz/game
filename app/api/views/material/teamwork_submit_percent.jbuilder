
json.result @flag
#成功过关
if @flag == 0
  json.message "恭喜您,成功过关!"
#成功完成活动
elsif @flag == 1
  json.message "恭喜您,完成团队合作!"

#完成活动失败
elsif @flag == 2
  json.message "很遗憾,任务未完成,再来一局吧!"
# 没有这个应用 或者当前应用不是团队合作应用
else
  json.message '资源不存在'
end

if @flag == 0 || @flag == 1 || @flag == 2
  json.result 0
  json.teamwork do
    json.id  @exist_teamwork.id
    json.total_work  @exist_teamwork.total_work
    json.state  @exist_teamwork.state
    json.sponsor @exist_teamwork.sponsor
    # json.result_percent @teamwork.result_percent
  end
  json.partner_users(@partner_users) do |item|
    json.id  item.id
    json.name item.name
    json.profile_img_url item.profile_img_url
    json.sex item.sex
    json.city item.city
    json.expect_percent @exist_teamwork.get_user_percent(item.id)
    json.result_percent @exist_teamwork.get_result_percent(item.id)
  end
end