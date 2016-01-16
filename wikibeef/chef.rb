class Chef
  require './grocery_store'
  require './sous_chefs'

  def initialize(max_patties = 7, min_patties = 1, min_burgers = 1, max_sous_chefs = 8)
    puts '  .--,--.       '
    puts '  \'.  ,.\'  _  '
    puts '   |___|  | |   '
    puts '   :o o:  |_|   '
    puts '  _:~^~:_  |    '
    puts ' |       | |    '
    @max_patties = max_patties.to_i
    @min_burgers = min_burgers.to_i
    @min_patties = min_patties.to_i
    @max_sous_chefs = [max_sous_chefs.to_i, 1].max

    @icon_step = 0
    @icon = [
        '(^_^)--\\____/     ',
        '(^_^) --\\____/    ',
        '(^_^)  --\\____/   ',
        '(-_^)   --\\____/  ',
        '(^_^)  --\\____/   ',
        '(^_^) --\\____/    '
    ]
    @last_grill_time = Time.now
  end

  def prepTheKitchen
    # Get a grocery store
    @grocer = GroceryStore.new

    # Array of visited pages, so we don't loop!
    @charcuterie = Hash.new

    # Array of matching end point nodes who are 'nominees'
    @beef = []

    # Meat to check (or, current level nodes)
    @meat = Hash.new

    # Next batch
    @next_batch = Hash.new

    # Timesheet
    @timesheet = Mutex.new

    # Get our group of sous chefs
    @souschefs = SousChefs.new @max_sous_chefs
  end

  def closeTheKitchen
    @souschefs.closingTime
    exit
  end

  def wheresTheBeef(topbun, bottombun)
    @topbun = topbun
    @bottombun = bottombun
    @start_time = Time.now
    puts "It's #{@start_time}! Let\'s get cooking!!!"
    puts "I will attempt to make #{@min_burgers} burger#{@min_burgers > 1 ? 's' : ''} from #{@topbun} to #{@bottombun}, with at least #{@min_patties} patties and as many as #{@max_patties} patties~!"
    puts "I may hire up to #{@max_sous_chefs} Sous Chefs! #{@max_sous_chefs > 4 ? 'Qu\'est-ce une grande cuisine!': ''}"
    @meat[@topbun] = nil

    makeThosePatties
    serveThemBurgers
  end

  def serveThemBurgers
    @beef.each do |beef|
      puts 'ORDER UP!!!'
      puts beef
    end
    @elapsed_time = Time.now - @start_time
    puts "Dinner is served! It took #{'%.1f' % @elapsed_time} seconds! Sorry for the wait."
  end

  def makeThosePatties(patty_count = 0)
    return if patty_count > @max_patties

    puts "Making patty number #{patty_count + 1}!"
    puts "There are #{@meat.size} meats in this patty."

    total = @meat.size
    @lastpercent = 0
    @meat.each do |name, parents|
      @meat.delete name
      if @beef.length < @min_burgers
        @souschefs.order do
          grillThatMeat patty_count, name, parents
        end
      end
    end

    until @souschefs.jobs.empty? and not @souschefs.working
      percent = ((total-@souschefs.jobs.size).to_f / total.to_f) * 100
      grillingStatus percent
      sleep(1)
    end

    grillingStatus 100
    print "\n"
    STDOUT.flush

    @meat = @next_batch
    @next_batch = Hash.new
    makeThosePatties patty_count+1 unless @beef.length >= @min_burgers
  end

  def grillThatMeat(patty_count, name, parent)
    return if @beef.length >= @min_burgers
    return if @charcuterie.has_key? name
    if name.casecmp(@bottombun) == 0
      @timesheet.synchronize do
        @beef.push "#{parent} -> #{name}"
        return
      end
    else
      @timesheet.synchronize do
        @charcuterie[name] = true
      end
    end

    # Return if we can't get more patties than this one - we don't want to waste money at the grocer
    return unless patty_count+1 <= @max_patties
    box_of_meats = @grocer.get name

    box_of_meats.each do |new_meat|
      meat_parent = parent.nil? ? '' : "#{parent} -> "
      meat_parent = "#{meat_parent}#{name}"
      @timesheet.synchronize do
        next unless new_meat['ns'] == 0 and not new_meat['exists'].nil?
        if new_meat['*'].casecmp(@bottombun) == 0
          @beef.push "#{meat_parent} -> #{new_meat['*']}"
        else
          @next_batch[new_meat['*']] = meat_parent
        end
      end
    end
  end

  def grillingStatus(percent)
    @icon_step += 1

    print "\r"
    print "#{@icon[@icon_step%@icon.length]} Grilling that patty!  (#{'%.1f' % percent}%)"
    STDOUT.flush
  end
end

# Parse Arguments
arguments = {
  'max-patties' => 7,
  'min-burgers' => 1,
  'min-patties' => 1,
  'from' =>  'sous chef',
  'to' => 'chef',
  'max-sous-chefs' => 8
}

i = 0
while i < ARGV.length do
  if ARGV[i][0,2] == '--'
    arguments[ARGV[i][2,ARGV[i].length]] = ARGV[i+1] || ''
  end
  i += 1
end

# Validate arguments maybe
unless arguments.has_key? 'help'
  # Arguments are good, let's get cooking!
  chef = Chef.new arguments['max-patties'], arguments['min-patties'], arguments['min-burgers'], arguments['max-sous-chefs']
  chef.prepTheKitchen
  chef.wheresTheBeef arguments['from'], arguments['to']
  chef.closeTheKitchen
else
  puts 'Please use the following format:'
  puts 'ruby chef.rb --from PAGE --to PAGE --max-patties INTEGER --min-patties INTEGER --min-burgers INTEGER --max-sous-chefs INTEGER'
  puts 'All parameters are optional, but you get the best use if you specify from and to'
end