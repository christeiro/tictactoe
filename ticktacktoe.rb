# 1. Comm  up with requirements/specification, which will determine the scope
# 2. Application logic, sequence of steps
# 3. Translation of those steps into code
# 4. Run code to verify logic

# draw a board

# assign player to "X"
# assign computer to "0"

# loop until a winner or all squares are taken
#   player picks an empty square
#     check if player1 won?
#   computer picks an empty square
#     check if the player2 won?

# if there's a winner
#   show the winner
# or else
#   it's a tie

require 'pry'

WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

def initialize_board
  b = {}
  (1..9).each {|position| b[position] = ' '}
  b
end

def draw_board(b)
  system "clear"
  puts " #{b[1]} | #{b[2]} | #{b[3]} " 
  puts "---+---+---"
  puts " #{b[4]} | #{b[5]} | #{b[6]} "
  puts "---+---+---"
  puts " #{b[7]} | #{b[8]} | #{b[9]} "
end

def empty_positions(b)
  b.select { |k, v| v == ' ' }.keys 
end

def player_picks_square(b)
  loop do
    puts "Pick a square (1 - 9):"
    position = gets.chomp.to_i
    if empty_positions(b).include?(position)
      b[position] = 'X'
      break
    else
      puts "This position is already taken"
    end
  end
end

def computer_picks_square(b)
  position = nil;
  WINNING_LINES.each do |line|
    possible_winning_lines = Hash[ line.collect { |v| [v, b[v]] }]
    next_move = two_in_a_row(possible_winning_lines,'X')
    if next_move
      position = next_move
      break
    end
  end
    # Not sure if the following is the best solution, comes from the old programming habbit 
    b[position ? position : empty_positions(b).sample] = '0'
end

def check_winner(b)
  WINNING_LINES.each do |line|
    return 'Player' if b.values_at(*line).count('X') == 3
    return 'Computer' if b.values_at(*line).count('0') == 3
  end
  nil
end


# checks to see if two in a row
def two_in_a_row(hsh, mrkr)
  if hsh.values.count(mrkr) == 2
    hsh.select{|k,v| v == ' '}.keys.first
  else
    false
  end
end


board = initialize_board
draw_board(board)

begin
  player_picks_square(board)
  computer_picks_square(board)
  draw_board(board)
  winner = check_winner(board)
end until winner || empty_positions(board).empty?

if winner
  puts "#{winner} won"
else
  puts "It's a tie"
end
