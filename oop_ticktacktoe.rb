# oop_ticktacktoe.rb

require 'pry'

class Player
  attr_reader :name, :marker, :type

  PLAYER_TYPE = {1 => 'Player', 2 => 'Computer'}

  def initialize(name, marker,type)
    @name = name
    @marker = marker
    @type = type
  end

  def is_human?
    @type == 1
  end

end

class Board

  WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

  attr_reader :board

  def initialize
    @board = {}
    (1..9).each {|position| @board[position] = Square.new(' ')}
    @board
  end

  def draw
    system "clear"
    puts " #{@board[1].value} | #{@board[2].value} | #{@board[3].value} " 
    puts "---+---+---"
    puts " #{@board[4].value} | #{@board[5].value} | #{@board[6].value} "
    puts "---+---+---"
    puts " #{@board[7].value} | #{@board[8].value} | #{@board[9].value} "
  end

  def empty_positions
    @board.select { |_,value| value.is_empty? }.keys 
  end

  def all_squares_marked?
    @board.select { |_, value| value.is_empty? }.empty?
  end

  def mark_position(position, marker)
    @board[position].mark(marker)
  end

  def three_in_row?(marker)
    WINNING_LINES.each do |line|
      return true if @board[line[0]].value == marker && @board[line[1]].value == marker && @board[line[2]].value == marker
    end
    false
  end

  def two_in_row?(marker)
    next_move = nil
    WINNING_LINES.each do |line|
      possible_winning_lines = Hash[ line.collect { |v| [v, @board[v].value] }]
      next_move = possible_winning_line(possible_winning_lines,marker)
      if next_move
        next_move
        break
      end
    end
    if next_move
      next_move
    else
      false
    end
  end

  def possible_winning_line(hsh, marker)
    if hsh.values.count(marker) == 2
      hsh.select{|_k,v| v == ' '}.keys.first
    else
      false
    end
  end

end

class Square < Board
  attr_accessor :value
  
  def initialize(value)
    @value = value
  end

  def is_empty?
    @value == ' '
  end

  def mark(marker)
    @value = marker
  end

end

class Game

  attr_reader :player, :computer, :board, 

  PLAYER_MARKER = 'X'
  COMPUTER_MARKER = 'O'

  def initialize
    @player = Player.new('Player',PLAYER_MARKER, 1)
    @computer = Player.new('Computer',COMPUTER_MARKER, 2)
    @board = Board.new
    @current_player = @player
  end

  def change_current_player
    if @current_player == @player
      @current_player = @computer
    else
      @current_player = @player
    end
  end

  def check_winner
    @board.three_in_row?(@current_player.marker)
  end

  def play
    @board.draw
    loop do @board.all_squares_marked?
      current_player_pick_square
      if check_winner
        puts "#{@current_player.name} won!"
        break
      elsif @board.all_squares_marked? 
        puts "It's a tie"
        break
      end
      change_current_player
    end
    puts "Game over"
  end

  def current_player_pick_square
    if @current_player.is_human?
      position = nil
      loop do
        puts "Pick a square (1 - 9):"
        position = gets.chomp.to_i
        if @board.empty_positions.include?(position)
          @board.mark_position(position,@current_player.marker)
          break
        else
          puts "This position is already taken"
        end
      end
    else
      if @board.two_in_row?(@player.marker)
        @board.mark_position(@board.two_in_row?(@player.marker), @current_player.marker)
      else
        @board.mark_position(@board.empty_positions.sample, @current_player.marker)
      end
    end
    @board.draw
  end

end

game = Game.new
game.play