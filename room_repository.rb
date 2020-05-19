require 'csv'
require_relative 'room'

class RoomRepository
  def initialize(csv_file)
    @csv_file = csv_file
    @rooms    = []
    @next_id  = 1
    load_csv
  end

  def find(id)
    # Documentation for #find 
    # https://ruby-doc.org/core-2.7.1/Enumerable.html#method-i-find
    @rooms.find {|room| room.id == id}
  end

  private

  def load_csv
    csv_options = { headers: :first_row, header_converters: :symbol }

    CSV.foreach(@csv_file, csv_options) do |row|
      # Convert the values from string to the right type
      row[:id]    = row[:id].to_i          # Convert column to Integer

      # Add the row (thats now a hash) into the Patient
      @rooms << Room.new(row)

      #Auto increment the next id
      @next_id += 1
    end
  end

  def save_csv
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }


    CSV.open(@csv_file, 'wb', csv_options) do |csv|
      csv << ['id','capacity']
      
      @rooms.each do |room|
        csv << [room.id, room.capacity]
      end

    end

  end

end