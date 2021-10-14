# A party generator for randomized fft runs
#
# Rules:
#
#  Roll a 20 sided die for each of Ramza and 3 generic characters. Each number
#  corresponds to a job. Each character gets to use abilities from 3 jobs, with
#  no repeats.
#
#  The last party member must be a recruited monster
#
#  Some jobs may be forbidden
#
JOBS = [
  'Squire',
  'Chemist',
  'Knight',
  'Archer',
  'Wizard',
  'Priest',
  'Thief',
  'Lancer',
  'Monk',
  'Time Mage',
  'Oracle',
  'Mediator',
  'Summoner',
  'Geomancer',
  'Ninja',
  'Samurai',
  'Dancer',
  'Bard',
  'Calculator',
  'Mime'
]

FORBIDDEN_JOBS = ['Mime', 'Calculator']
PARTY_SIZE = 4
JOBS_PER_CHAR = 3

RULES =
  <<-MSG
  ---
  The party will consist of #{PARTY_SIZE + 1} characters (Ramza, 1 monster, and generics). 
  Each character gets access to abilities from #{JOBS_PER_CHAR} jobs, with no repeated jobs.
  ---

  MSG

def prompt(message)
  puts "=> #{message}"
end

def welcome_message
  system('clear')
  puts "Welcome!"
  print "\n"
  puts RULES
end

def display_current_party
  prompt "Current saved party:"
  puts File.read("current_party.txt")
  print "\n"
end

def start_gen
  prompt "Press enter to generate a new party"
  gets.chomp
end

def generate_party
  party = []
  PARTY_SIZE.times do |time|
    party[time] = pick_three(party)
  end
  party
end

def pick_three(party)
  job_list = make_job_list(party)
  char = []
  while char.size < JOBS_PER_CHAR
    char << job_list.pop
  end
  char
end

def make_job_list(party)
  job_list = JOBS.reject { |job| FORBIDDEN_JOBS.include?(job) }
  job_list.reject { |job| party.flatten.include?(job) }.shuffle
end

def make_readable_party(party)
  readable_party = ''
  party.each_with_index do |char, idx|
    readable_party << "Character #{idx + 1}: #{char.join('/')}"
    readable_party << "\n" unless idx == PARTY_SIZE - 1
  end
  readable_party
end

def display_new_party(party)
  puts make_readable_party(party)
end

def save_party!(party)
  File.write("current_party.txt", make_readable_party(party))
end

def save_party?
  loop do
    print "\n"
    prompt "Do you want to save this party composition? (y/n)"
    answer = gets.chomp
    return true if answer.downcase == 'y'
    return false if answer.downcase == 'n'
    prompt "Please enter 'y' or 'n'"
  end
end

def gen_again?
  loop do
    print "\n"
    prompt "Generate another party? (y/n)"
    answer = gets.chomp
    return true if answer.downcase == 'y'
    return false if answer.downcase == 'n'
    prompt "Please press 'y' or 'n'"
  end
end

def goodbye
  prompt "Have fun!"
end

loop do
  welcome_message
  display_current_party if File.exist?("current_party.txt")
  start_gen
  party = generate_party
  display_new_party(party)
  save_party!(party) if save_party?
  break unless gen_again?
end

goodbye
