def user_agent?
  ua = request.user_agent.downcase
  ua.index("micromessenger")
end