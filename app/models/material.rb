# encoding: utf-8
class Material < ActiveRecord::Base

  belongs_to :category
  belongs_to :user
  has_many :images, as: :viewable, class_name: "Image", dependent: :destroy
  has_many :answers, as: :viewable, class_name: "Answer",  dependent: :destroy

  has_many :questions

  class_attribute :clone

  before_update :clone_self, if: Proc.new{|mate| mate.clone == true}
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
     key = "wx_gshare_#{type}_#{self.id}"
     $redis.get(key) 
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
    self.description
  end


  private
  def clone_self
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
  end
end
