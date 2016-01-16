class SousChefs
  require 'thread'

  def initialize(size)
    @chefs = size
    @jobs = Queue.new
    @working = false

    @kitchen = Array.new(@chefs) do |i|
      Thread.new do
        Thread.current[:id] = i
        catch(:exit) do
          loop do
            job, args = @jobs.pop
            @working = true
            job.call(*args)
            @working = false
          end
        end
      end
    end
  end

  def order(*args, &block)
    @jobs << [block, args]
  end

  def closingTime
    @chefs.times do
      order { throw :exit }
    end

    @kitchen.map(&:join)
  end

  def jobs
    @jobs
  end

  def working
    @working
  end
end