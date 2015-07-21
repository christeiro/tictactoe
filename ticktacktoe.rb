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

def draw_board(board)
  system "clear"
  puts " #{board[1]} | #{board[2]} | #{board[3]} " 
  puts "---+---+---"
  puts " #{board[4]} | #{board[5]} | #{board[6]} "
  puts "---+---+---"
  puts " #{board[7]} | #{board[8]} | #{board[9]} "
end

def empty_positions(board)
  board.select { |k, v| v == ' ' }.keys 
end

def player_picks_square(board)
  loop do
    puts "Pick a square (1 - 9):"
    position = gets.chomp.to_i
    if empty_positions(board).include?(position)
      board[position] = 'X'
      break
    else
      puts "This position is already taken"
    end
  end
end

def computer_picks_square(board)
  position = nil;
  WINNING_LINES.each do |line|
    possible_winning_lines = Hash[ line.collect { |v| [v, board[v]] }]
    next_move = two_in_a_row(possible_winning_lines,'X')
    if next_move
      position = next_move
      break
    end
  end
    # Not sure if the following is the best solution, comes from the old programming habbit 
    board[position ? position : empty_positions(board).sample] = '0'
end

def check_winner(board)
  WINNING_LINES.each do |line|
    return 'Player' if board.values_at(*line).count('X') == 3
    return 'Computer' if board.values_at(*line).count('0') == 3
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


game_board = initialize_board
draw_board(game_board)

begin
  player_picks_square(game_board)
  computer_picks_square(game_board)
  draw_board(game_board)
  winner = check_winner(game_board)
end until winner || empty_positions(game_board).empty?

if winner
  puts "#{winner} won"
else
  puts "It's a tie"
end
