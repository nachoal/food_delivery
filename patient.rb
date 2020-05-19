class Patient
  attr_reader :name, :cured
  attr_accessor :room, :id

  def initialize(attributes = {})
    @id    = attributes[:id]
    @name  = attributes[:name]
    @cured =  attributes[:cured]
    @room  = attributes[:room]
  end

  def cure
    @cured = true
  end
end
