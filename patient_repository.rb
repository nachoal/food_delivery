require 'csv'
require_relative 'patient'
require_relative 'room_repository'

class PatientRepository
  # We can see that patient has a dependency on room because it NEEDS the room_id
  # We can also see that in the patients.csv with the room_id column
  # When we have a model_id on the csv THIS IS THE CHILDREN OF THE OTHER MODEL
  # All repositories that have a dependency take the other model repo as argument
  def initialize(csv_file, room_repository)
    @csv_file = csv_file
    @patients = []
    @next_id  = 1 # always starts at 1 and auto increments by 1
    @room_repository = room_repository

    load_csv
  end

  def add_patient(patient)
    patient.id = @next_id

    @patients << patient

    save_csv
  end

  private

  def load_csv
    # When we add the headers first row option the usual array becomes a Hash
    # the header_converters option turns the string key to a symbol
    # It makes our reading more convenient and elegant.
    csv_options = { headers: :first_row, header_converters: :symbol }

    CSV.foreach(@csv_file, csv_options) do |row|
      # Convert the values from string to the right type
      row[:id]    = row[:id].to_i          # Convert column to Integer
      row[:cured] = row[:cured] == "true"  # Convert column to boolean
      # Create a new key in the hash
      # We will use the room repo to find the room with right the room_id 
      row[:room]  = @room_repository.find(row[:room_id].to_i)
      patient     = Patient.new(row)
      row[:room].add_patient(patient)

      # Add the row (thats now a hash) into the Patient
      @patients << patient

      #Auto increment the next id
      @next_id += 1
    end
  end

  def save_csv
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }

    # We use 'wb' to rewrite the whole csv
    # This is the most common technique, we never append to an existing csv
    # We always rewrite
    CSV.open(@csv_file, 'wb', csv_options) do |csv|
      # When saving we first add the column names
      csv << ['id','name','cured']
      
      # Then we iterate through the patients and add them to the csv
      @patients.each do |patient|
        csv << [patient.id, patient.name, patient.cured]
      end

    end

  end

end

##### TESTING AREA #####

room_repo = RoomRepository.new('rooms.csv')

patient_repo = PatientRepository.new('patients.csv', room_repo)

# ringo = Patient.new(name:'ringo', cured: true)

# # p patient_repo

# patient_repo.add_patient(ringo)

p patient_repo
p room_repo