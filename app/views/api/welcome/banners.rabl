object false
child @banners do
  node(:id){|b| b.id }
  node(:image_url){|b| b.image_url }
  node(:link){|b| b.link }
  node(:wait){|b| b.wait }
end