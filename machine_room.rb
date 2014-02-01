require 'debugger'
require_relative 'cab'
require_relative 'cab_call'
require_relative 'cab_call_queue'
require_relative 'cab_call_unit'

class MachineRoom
  attr_reader :active, :num_floors, :num_cabs, :cab_call_queue, :cab_call_units, :cabs

  def initialize(opts = {})
    @active = false
    @num_floors = opts[:num_floors] || 12
    @num_cabs = opts[:num_cabs] || 3
  end

  def power_on
    init_cab_call_queue!
    init_cab_call_units!
    init_cabs!
    activate_cabs!
    @active = true
  end

  def play_simulation
    power_on unless active?
    Thread.abort_on_exception = true
    caller = Thread.new do
      loop do
        puts "[machine room] queue is: #{cab_call_queue}\n"
        unit = cab_call_units.sample
        call = CabCall.new(from_floor: unit.on_floor, direction: [:up, :down].sample)
        puts "[machine room] artificially triggering #{unit} to make #{call}\n"
        cab_call_queue.add(call)
        sleep 9
      end
    end
    caller.join
  end

  private

  def active?
    active
  end

  def init_cab_call_queue!
    puts "[machine room] creating cab call queue"
    @cab_call_queue = CabCallQueue.new
  end

  def init_cab_call_units!
    puts "[machine room] creating cab call units for each floor"
    @cab_call_units = [].tap do |units|
      1.upto(num_floors) do |floor_num|
        units << CabCallUnit.new(on_floor: floor_num, cab_call_queue: cab_call_queue)
      end
    end
    puts "[machine room] cab call units created:"
    cab_call_units.each { |unit| puts "\t#{unit}" }
  end

  def init_cabs!
    puts "[machine room] creating #{num_cabs} cabs"
    @cabs = num_cabs.times.inject([]) do |cabs, num|
      cab = Cab.new(cab_call_queue: cab_call_queue)
      cabs << cab
    end
    puts "[machine room] cabs created:"
    cabs.each { |cab| puts "\t#{cab}" }
  end

  def activate_cabs!
    puts "[machine room] activating all cabs"
    cabs.each { |cab| cab.activate! }
  end
end

if __FILE__ == $0
  machine_room = MachineRoom.new
  machine_room.power_on
  machine_room.play_simulation
end
