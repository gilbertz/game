# encoding: utf-8
class Material < ActiveRecord::Base

  belongs_to :category
  belongs_to :user
  has_many :images, as: :viewable, class_name: "Image", dependent: :destroy
  has_many :answers, as: :viewable, class_name: "Answer",  dependent: :destroy

  has_many :questions

  class_attribute :clone

  before_validation :auto_url
  def auto_url
    if self.url.blank?
      self.url = Material.maximum('id').to_s + rand(1000000).to_s
    end
  end


  before_update :clone_self, if: Proc.new{|mate| mate.clone == true}

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

  def fake_pv
    if self.pv.to_i > 10000
      (self.pv.to_i / 100).to_i
    else
      self.pv
    end
  end

  def share_count(type)
     key = "wx_gshare_#{type}_#{self.url}"
     $redis.get(key) 
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

  def cn_state; { 0 => '下线', 1 => '上线', nil => '下线' }[state] end

  def game_type
    unless self.category.game_type.blank?
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
    rec_games << Material.where(state: 1).order('created_at desc').first
    games =  Material.where("id != #{exclude_num}").where(state: 1)
    rec_games += games.sample(n)
    rec_games
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
