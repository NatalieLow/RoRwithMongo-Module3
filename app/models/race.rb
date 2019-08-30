class Race
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :events, as: :parent, class_name: 'Event', order: [:order.asc]
  has_many :entrants, foreign_key: 'race._id', dependent: :delete,
   order: [:secs.asc, :bib.asc]

  field :n, as: :name, type: String
  field :date, as: :date, type: Date
  field :loc, as: :location, type: Address
  field :next_bib, as: :next_bib, type: Integer, default: 0

  scope :upcoming, -> { where(:date.gte => Date.current) }
  scope :past, -> { where(:date.lt => Date.current) }

  DEFAULT_EVENTS = {'swim' => {:order => 0, :name => 'swim', :distance => 1.0, :units => 'miles'},
                    't1' => {:order => 1, :name => 't1'},
                    'bike' => {:order => 2, :name => 'bike', :distance => 25.0, :units => 'miles'},
                    't2' => {:order => 3, :name => 't2'},
                    'run' => {:order => 4, :name => 'run', :distance => 10.0, :units => 'kilometers'}}

  def self.default
    Race.new do |race|
    DEFAULT_EVENTS.keys.each {|leg|race.send("#{leg}")}
    end
  end

  ["city", "state"].each do |action|
    define_method("#{action}") do
      self.location ? self.location.send("#{action}") : nil
    end
    define_method("#{action}=") do |name|
      object=self.location ||= Address.new
      object.send("#{action}=", name)
      self.location=object
    end
  end

  DEFAULT_EVENTS.keys.each do |name|
    define_method("#{name}") do
      event = events.select {|event| name == event.name}.first
      event ||= events.build(DEFAULT_EVENTS["#{name}"])
    end
    %w(order distance units).each do |prop|
      if DEFAULT_EVENTS["#{name}"][prop.to_sym]
        define_method("#{name}_#{prop}") do
          event = self.send("#{name}").send("#{prop}")
        end
        define_method("#{name}_#{prop}=") do |value|
          event = self.send("#{name}").send("#{prop}=", value)
        end
      end
    end
  end

  def next_bib
    self.next_bib = self[:next_bib] + 1
    self.save
    self[:next_bib]
  end

  def get_group(racer)
    if racer && racer.birth_year && racer.gender
      age = self.date.year - racer.birth_year
      min_age = ((age/10).floor) * 10
      max_age = min_age + 9
      gender = racer.gender
      name = min_age >= 60 ? "masters #{gender}" : "#{min_age} to #{max_age} (#{gender})"
      Placing.demongoize(:name=>name)
    end
  end

  def create_entrant(racer)
    new_entrant = Entrant.new()
    new_entrant.race = attributes.symbolize_keys.slice(:_id, :n, :date) 
    new_entrant.racer = racer.info.attributes
    new_entrant.group = get_group(racer)

    events.each do |event|
      new_entrant.send("#{event.name}=", event)
    end

    if new_entrant.validate
      new_entrant.bib = next_bib
      new_entrant.save
    # else
      # new_entrant.bib = self[:next_bib]
    end
    new_entrant
  end

  def self.upcoming_available_to(racer)
    race_ids = racer.races.pluck(:race).map { |r| r[:_id].to_s }
    where(:date.gte => Date.current).where(:_id.nin => race_ids)
  end
end
