class RaceRef
  include Mongoid::Document

  embedded_in :entrant
  belongs_to :race, foreign_key: "_id"

  field :n, as: :name, type: String
  field :date, type: Date
end
