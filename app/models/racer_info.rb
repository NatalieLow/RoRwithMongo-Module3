require 'date'

class RacerInfo
  include Mongoid::Document

  embedded_in :parent, class_name: 'Entrant', polymorphic: true
  embedded_in :parent, class_name: 'Racer', polymorphic: true

  validates_presence_of :first_name, :last_name, :gender, :birth_year
  validates :gender, inclusion: { in: %w(M F), message: "Must be M or F"}
  validates :birth_year, numericality: {only_integer: true, less_than: Date.current.year, message: "Must be in past"}

  field :racer_id, as: :_id
  field :_id, default:->{ racer_id }
  field :fn, as: :first_name, type: String
  field :ln, as: :last_name, type: String
  field :g, as: :gender, type: String
  field :yr, as: :birth_year, type: Integer
  field :res, as: :residence, type: Address

end
