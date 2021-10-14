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
RULES =
  <<-MSG
  ---
  The party will consist of 5 characters (Ramza, 3 generic and 1 monster). 
  Each character gets access to abilities from 3 jobs, with no repeated jobs between characters.
  ---

  Press Enter to generate party

  MSG

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

def prompt(message)
  puts "=> #{message}"
end

def welcome_message
  system('clear')
  puts "Welcome!"
  print "\n"
  puts RULES
end

def start_gen
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

def display_party(party)
  party.each_with_index do |char, idx|
    prompt "Character #{idx + 1}: #{char.join('/')}"
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
  start_gen
  party = generate_party
  display_party(party)
  break unless gen_again?
end

goodbye
