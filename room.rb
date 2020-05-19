require_relative 'patient'

class Room
  attr_accessor :id
  # STATE/DATA
  # In the end we want to link the patients in the room
  # We want to know how many patients in a room
  # We want to know the information of people in the room
  # 1. capacity as Integer/Fixnum
  # 2. patients as [Patient] ( array of instances)
  # We could have plenty more but lets focus on these 2

  def initialize(attributes = {})
    @capacity = attributes[:capacity]
    @patients = attributes[:patients] || []
    @id = attributes[:id]
  end

  # BEHAVIOR
  def full?
    @patients.length == @capacity
  end

  def add_patient(patient)
    if full?
      fail Exception, 'The room is full'
    else
      @patients << patient
      patient.room = self
    end
  end
end