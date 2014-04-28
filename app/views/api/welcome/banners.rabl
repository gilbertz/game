object false
child @banners do
  node(:id){|b| b.id }
  node(:image_url){|b| b.image_url }
  node(:wait){|b| b.wait }
end