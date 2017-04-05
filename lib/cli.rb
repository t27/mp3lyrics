def to_b(string)
  !(string =~ /^(true|t|yes|y|1)$/i).nil?
end

def usage_message(override_options, use_options)
  'Usage: ./mp3lyrics.rb <dir> [-override ' + override_options.join('/') + '] [-use ' + use_options.join('/') + ']'
end

override_options = [true, false]
use_options = %w(lyricwikia genius metrolyrics azlyrics swiftlyrics)

if ARGV.length.even? ||
   ARGV.count('-override') > 1 ||
   ARGV.count('-use') > 1
  # If there is an even number of arguments (includes no arguments)
  # or a flag has been used more than once
  puts usage_message(override_options, use_options)
  exit
end

dir = ARGV[0]
override = false
wiki_to_use = nil

i = 1
while i < ARGV.length
  if ARGV[i] == '-override'
    if override_options.include?(to_b(ARGV[i + 1]))
      override = to_b(ARGV[i + 1])
    else
      # If the argument after the override flag is invalid
      puts usage_message(override_options, use_options)
      exit
    end
  elsif ARGV[i] == '-use'
    if use_options.include?(ARGV[i + 1])
      wiki_to_use = ARGV[i + 1]
    else
      # If the argument after the use flag is invalid
      puts usage_message(override_options, use_options)
      exit
    end
  else
    # If the argument is not a valid flag
    puts usage_message(override_options, use_options)
    exit
  end
  i += 2
end

puts "
                  Welcome to
  __  __ _____ ____  _                _
 |  \\\/  |  __ \\___ \\| |              (_)
 | \\  \/ | |__) |__) | |    _   _ _ __ _  ___ ___
 | |\\/| |  ___\/|__ <| |   | | | | \'__| |\/ __\/ __|
 | |  | | |    ___) | |___| |_| | |  | | (__\\__ \\
 |_|  |_|_|   |____\/|______\\__, |_|  |_|\\___|___\/
                            __\/ |
                           |___\/

The current working directory is #{dir}
Overriding existing lyrics is #{override}"
puts "Specific wiki to use is #{wiki_to_use}" unless wiki_to_use.nil?
puts "\n\r"
