# encoding: utf-8
class Material < ActiveRecord::Base

  belongs_to :category
  belongs_to :user
  has_many :images, as: :viewable, class_name: "Image", dependent: :destroy
  has_many :answers, as: :viewable, class_name: "Answer",  dependent: :destroy
  has_many :bgames, :foreign_key => "game_id"

  has_many :questions
  has_many :records
  has_many :MappingMis

  has_many :teamworks

  cattr_accessor :current_material
  class_attribute :clone

  before_validation :auto_url
  def auto_url
    if self.url.blank?
      self.url = Material.maximum('id').to_s + rand(1000000).to_s
    end
  end


  before_update :clone_self, if: Proc.new{|mate| mate.clone == true}

  def self.create_by_web(url)
    require 'open-uri'

    docid = Digest::MD5.hexdigest(url.gsub('#rd', ''))
    return if Material.find_by_docid(docid)

    doc = Nokogiri::HTML(open(url))
    title = doc.title 
    html = ""
    doc.css("#js_content").each do |c|
      html = c.to_html
      break
    end

    src_dict = {}
    html.scan(/(data-src=\"(.*?)\")/).each{ |m|
      t = m[1].gsub(/\/0$/, "/640")
      src_dict[m[0]] = m[0] + " src=\"#{t}\""
    }

    src_dict.each do |k, v|
      html = html.gsub(k, v)
    end

    img_dict = {}
    html.scan(/src=\"(.*?)\"/).each{ |m|
      unless /uploads/ =~ m[0]
        #p m[0]
        next if m[0].index('v.qq.com/iframe/player.html')
        img_fn = Digest::MD5.hexdigest(m[0])
        img_url =  'http://wx.51self.com' + "/uploads/post/#{img_fn}.jpg"
        `wget  -t 10  -nc -c -x -O /root/weixin_game/public/uploads/post/#{img_fn}.jpg #{m[0]}`
         img_dict[m[0]] = img_url
      end
    }
    img_dict.each do |k, v|
      html = html.gsub(k, v)
    end
    template = Material.find 920
    template.cloning(true)
    m = Material.last
    m.description = html
    m.name = title
    m.wx_title = title
    m.docid = docid
    m.link = url
    m.save
    m
  end


  def self.by_url url
    m =  Material.find_by_url( url )
    m = Material.find_by_id( url ) unless m
    m
  end

  def get_name
    if self.id == Material.last.id
      "【新】" + self.name
    else
      self.name
    end 
  end 

  def get_answers
     answers = []
     self.answers.each do |ans|
       next if ans.weight.to_i < 0
       (0..ans.weight.to_i).each do 
         answers << ans
       end
     end
     answers
  end

  def get_answer_indexes
    r_arr = []
    idx = 0
    self.answers.each do |ans|
      if ans.weight.to_i < 0
        idx += 1
        next
      end
      (0..ans.weight.to_i).each do
         r_arr << idx
      end
      idx += 1
    end
    r_arr
  end

  def cloning(param)
    self.update_attribute(:clone,param)
  end

  def wx_cloning(param)
    self.cloning(param)
  end

  def pv
    key = "gstat_pv_#{self.id}"
    $redis.get(key)
  end

  def share_stat
    stat = ""
    $redis.keys("share_count_#{self.url}_*").each do |k|
      stat += "#{k.gsub('share_count_' + self.url.to_s + '_', '')} => #{$redis.get(k)} &nbsp;"
    end
    stat
  end

  def fake_pv
    self.pv.to_i * 10 + rand(10)
  end

  def share_count(type)
     key = "wx_gshare_#{type}_#{self.url}"
     $redis.get(key) 
  end

  def answer_qv(i)
    key = "q#{url}_#{i}"
  end

  
  def wx_share_stat
    stat = ""
    i = 0
    self.answers.each do |ans|
      key = "g#{self.url}_#{i}"
      if $redis.get(key)
        count = $redis.get(key)
        count = $redis.get(key).to_i / ( 1 + ans.weight.to_i ) if ans.weight.to_i >=0
        stat +=  "#{i} &nbsp; #{count} &nbsp; #{ans.title[0,10]}  &nbsp; #{ans.weight.to_i} <br/>"
      end
      i += 1
    end
    return stat
  end

  def invert_state
    val = state.eql?(0) ? 1 : 0
    self.update_attributes(state: val)
  end

  def invert_rrr
    val = rrr.eql?(0) ? 1 : 0
    self.update_attributes(rrr: val)
  end

  def cn_state; { 0 => '下线', 1 => '上线', nil => '下线' }[state] end

  def cn_rrr; { 0 => '不推荐', 1 => '推荐', nil => '无' }[rrr] end

  def game_type
    if self.category and not self.category.game_type.blank?
      self.category.game_type.game_type
    else
      ""
    end
  end

  def wx_share_id
    self.wx_url.gsub(/(.*?)(\d+)$/, '\2')
  end

  def custom_clone
    material = Material.new self.attributes.except!("created_at","id")
    material.state = 0
    material.images  = self.images.map {|img| Image.new img.attributes.except!("id") }
    material.answers = self.answers.map{|asw| Answer.new asw.attributes.except!("id")}
    #material.questions = self.questions.map{|que| newQ = Question.new que.attributes.except!("id") }

    self.questions.each do |que|
      newQ = material.questions.new que.attributes.except!("id")
      newQ.question_answers = que.question_answers.map{|qa| QuestionAnswer.new qa.attributes.except!("id") }
    end
    material.save
    material
  end

  def get_description
    #self.description
    ""
  end

  def self.recommended_games(n=3, exclude_num=0)  
    rec_games = []
    rec_games << Material.where("id != #{exclude_num}").where(state: 1).order('created_at desc').first
    games =  Material.where("id != #{exclude_num}").where(state: 1).sample(n)
    rec_games += games
    rec_games
  end

  def self.rec_games_new(n=4,exclude_num=0)
    rec_games = Material.joins(:category).where('categories.game_type_id >=13').where("materials.id != #{exclude_num}").where(state: 1).order('created_at desc').sample(n)
    rec_games
  end
  
  def self.h5_games(n=3, exclude_num=0)
    rec_games = Material.joins(:category).where('categories.game_type_id = 7').where("materials.id != #{exclude_num}").where(state: 1).order('created_at desc').sample(n)
    rec_games
  end

  
  def self.article_games(n=3, exclude_num=0)
    rec_games = Material.joins(:category).where('categories.game_type_id = 11').where("materials.id != #{exclude_num}").where(state: 1).order('created_at desc').sample(n)
    rec_games
  end


  def self.by_hook(url)
    m = Material.find_by_id url
    m = Material.find_by_url(url) unless m
    unless m
      hook = Hook.find_by_url(url)
      m = Material.find_by_id(hook.material_id) if hook
    end
    m
  end

  def self.get_object(game_url)
    material = Material.by_hook(game_url) if game_url
    if not material.object_type.blank? and material.object_id
      object = material.object_type.capitalize.constantize.find material.object_id
    end
  end

  def self.get_game(game_url)
    game_id = Material.by_hook(game_url).id if Material.by_hook(game_url)
  end

  def get_share_url(domain='')
    domain = 'http://51self.com' if domain.blank?
    unless self.share_url
      domain + "/weitest/#{self.url}"  
    else
      self.share_url
    end
  end

  def get_o2o_url(beacon=nil)
    if beacon.nil?
      "http://wx.yaoshengyi.com/gs/#{self.url}"
    else
      "http://wx.yaoshengyi.com/#{beacon.url}/gs/#{self.url}" 
    end
  end

  def game_type_id
    if self.category and not self.category.game_type.blank?
      self.category.game_type.id
    else
      0
    end
  end


  def get_link(beaconid=nil)
    if beaconid.nil?
      if self.game_type_id == 7 or  self.game_type_id == 14
        "http://www.51self.com/weitest/#{self.url}"
      else
        "http://www.021591.com/weitest/#{self.url}"
      end
    else
       "http://#{WX_DOMAIN}/#{beaconid}/gs/#{self.url}"
    end
  end

  def get_top(limit=10, beaconid=nil)
    cond = '1=1'
    unless beaconid.nil?
      b = Ibeacon.find_by_url(beaconid)
      cond = "beaconid=#{b.id}"
    end
    rs = Record.where(:game_id => self.id ).where(cond).order('score desc').limit(limit)
    rs
  end

  def get_today_top(limit=10, beaconid=nil)
    cond = '1=1'
    unless beaconid.nil?
      b = Ibeacon.find_by_url(beaconid)
      cond = "beaconid=#{b.id}"
    end
    rs = Record.where(:game_id => self.id ).where(cond).where("created_at >= ? and created_at <= ?", Date.today.beginning_of_day, Date.today.end_of_day).order('score desc').limit(limit)
    rs
  end


  def get_rank(uid)
    r = Record.find_by_user_id_and_game_id(uid, self.id)
    if r
      rs = Record.where(:game_id => self.id ).where( "score > ?", r.score).order('score desc')
      rs.length + 1
    else
      0
    end
  end

  
  def get_today_rank(uid)
    ss = Record.where(:game_id => self.id, :user_id => uid).where("created_at >= ? and created_at <= ?", Date.today.beginning_of_day, Date.today.end_of_day).order('score desc')
    if ss and ss.length > 0
      rs = Record.where(:game_id => self.id ).where( "score > ?", ss[0].score).where("created_at >= ? and created_at <= ?", Date.today.beginning_of_day, Date.today.end_of_day).order('score desc')
      rs.length + 1
    else
      0
    end
  end
 

  def get_qr_img
    'http://qr.liantu.com/api.php?text=' + self.get_link('shengye')
  end  


  def self.get_games_for_select(user_id=nil)
    cond = 'rrr=1'
    if user_id
      cond=" and user_id=#{user_id}"
    end
    gs = Material.where(cond).order('created_at desc').limit(50)
    gs.map{|b|[b.name, b.id]}
  end

  def social_share?
    if self.category and  self.category.game_type_id == 15
      return true
    end
    return false
  end


  private
  def clone_self
    material = Material.new self.attributes.except!("created_at","id", "url")
    material.state = 0
    material.images  = self.images.map {|img| Image.new img.attributes.except!("id") }
    material.answers = self.answers.map{|asw| Answer.new asw.attributes.except!("id")}
    material.auto_url
    #material.questions = self.questions.map{|que| newQ = Question.new que.attributes.except!("id") }

    self.questions.each do |que|
      newQ = material.questions.new que.attributes.except!("id")
      newQ.question_answers = que.question_answers.map{|qa| QuestionAnswer.new qa.attributes.except!("id") }
    end

    material.save
  end
end
