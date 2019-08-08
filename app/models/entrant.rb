class Entrant
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :results, class_name: "LegResult", after_add: :update_total, order: :"event.o".asc
  embeds_one :race, class_name: "RaceRef"
  embeds_one :racer, as: :parent, class_name: 'RacerInfo'

  store_in collection: "results"

  field :bib, type: Integer
  field :secs, type: Float
  field :o, as: :overall, type: Placing
  field :gender, type: Placing
  field :group, type: Placing

  def update_total(result)
    total = self.secs.nil? ? result.secs : (self.secs + result.secs)
    
    self.secs = total
  end

  def the_race
    race.race
  end
end
