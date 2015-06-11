class Teamwork < ActiveRecord::Base
  belongs_to :material

  validates :sponsor,
            :presence     => true

  validates :total_work,
            :presence     => true

  validates :material_id,
            :presence     => true


  def self.create_teamwork(user_id,material_id,init_percent,total_work = 1000)
    t = Teamwork.new
    t.sponsor = user_id
    t.material_id = material_id
    t.total_work = 1000
    if init_percent

    end
    if t.save
      return t
    else
    end
  end

  #0 代表进行中  1代表成功完成  2代表失败结束
  def teamwork_state
    [0,1,2]
  end

  before_create :begin_teamwork

  def begin_teamwork
    self.state = teamwork_state[0]
    if self.partner.nil?
      # self.partner = self.sponsor.to_s
      add_partner self.sponsor
    end

  end



  def add_one_person(user_id,percent,appid=WX_APPID)
    if user_id && percent
      add_partner user_id
      add_percent percent
      save
    end
  end

  def partners
    if self.partner
      self.partner.split(',')
    else
      []
    end
  end

  def add_partner (user_id,appid = WX_APPID)
    if user_id
      arr = partners
      arr.push user_id

     self.partner = arr.join(',')
    end
  end

  def team_percents
    if self.team_percent != nil
      self.team_percent.split(',')
    else
      []
    end
  end

  def add_percent(percent)
    if percent && percent < 1.0
      arr = team_percents
      arr.push percent
      arr.join(',')
      self.team_percent  = arr.join(',')
    end
  end

  def is_successful?
    self.state == teamwork_state[1]
  end

  def is_failure?
    self.state == teamwork_state[2]
  end

  def is_over?
    is_successful? || is_failure?
  end

  def is_runing?
    self.state == teamwork_state[0]
  end

end
