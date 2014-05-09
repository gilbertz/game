object false
node(:total_page){ @materials.total_pages }
node(:page){ @materials.current_page }
node(:more_page){ @materials.total_pages - @materials.current_page }
child @materials do
  node(:id){|m| m.id }
  node(:title){|m| m.wx_title }
  node(:wx_url){|m| m.wx_url }
  node(:wx_tlimg){|m| m.wx_tlimg }
  node(:pv){|m| m.redis_pv }
end