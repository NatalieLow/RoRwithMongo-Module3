class LegResult
  include Mongoid::Document
  field :secs, type: Float

  embedded_in :entrant
  embeds_one :event, as: :parent, class_name: "Event"

  validates_presence_of :event

  def calc_ave
    
  end

  after_initialize :calc_ave

  def secs= value
    self[:secs] = value
    self.calc_ave
  end
end
