require_relative 'bootstrap'

puts I18n.t(:test)

# mastermind = Mastermind.new
# puts mastermind.generate_random_code
# mastermind.guess(one: 1, two: 2, three: 3, four: 4)
# puts
# puts mastermind.clues

puts "Wanna try your MASTERMIND?!"
puts "1 -- yes\n2--no"

while true
  input = gets.chomp
  exit if input == 'exit'
  mastermind = Codebreaker::Game.new(difficulty: 'medium') if input.downcase == '1'
  mastermind.start_new_game if input == 'yes'
  break
end

while true
  puts
  puts 'Enter four number code. Each number should be from 1 to 6'
  puts
  puts "very secret code is #{mastermind.very_secret_code}"
  input = gets.chomp

  if input == 'exit'
    exit
  elsif input.length < 4 || input.length > 4
    puts 'Lol, try four numbers'
  elsif input == 'hint'
    puts "The hint is #{mastermind.show_hint}"
  else
    input = input.to_i.digits.reverse
    mastermind.guess(one: input[0], two: input[1], three: input[2], four: input[3])
    puts "very secret code is #{mastermind.very_secret_code}"
    puts "input is #{input}"
    puts mastermind.clues
    puts
    puts mastermind.clues.length
  end

  exit if mastermind.lost?
end
