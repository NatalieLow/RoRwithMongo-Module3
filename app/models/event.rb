class Event
  include Mongoid::Document

  embedded_in :parent, polymorphic: true, touch: true

  validates_presence_of :order, :name

  field :o, as: :order, type: Integer
  field :n, as: :name, type: String
  field :d, as: :distance, type: Float
  field :u, as: :units, type: String

  def meters
    case self.u
    when "meters"
      return self.d
    when "miles"
      return self.d * 1609.344
    when "yards"
      return self.d * 0.9144
    when "kilometers"
      return self.d * 1000
    else
      return nil
    end
  end

  def miles
    case self.u
    when "miles"
      return self.d
    when "meters"
      return self.d * 0.000621371
    when "yards"
      return self.d * 0.000568182
    when "kilometers"
      return self.d * 0.621371
    else
      return nil
    end
  end
  
end
