object false
child @materials do
  node(:id){|m| m.id }
  node(:title){|m| m.wx_title }
  node(:wx_url){|m| m.wx_url }
  node(:wx_tlimg){|m| m.wx_tlimg }
end