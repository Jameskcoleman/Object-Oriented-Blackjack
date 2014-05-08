class Card
  attr_accessor :suit, :face_value

  def initialize(s, fv)
    @suit = s
    @face_value = fv
  end

  def pretty_output
    "The #{face_value} of #{suit}. "
  end

  def to_s
    pretty_output
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    ['Hearts', 'Diamonds', 'Spades', 'Clubs'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    scramble!
  end

  def scramble!
    cards.shuffle!
  end

  def deal_one
    cards.pop
  end

  def size
    cards.size
  end
end

module Hand
  def show_hand
    puts " "
    puts "#{name} is holding:"
    cards.each do |card|
      puts "#{card}"
    end
    puts "Total value: #{total}. "
  end

  def total
    handvalue = 0
    aces_in_hand = 0
    cards.each do |card|
    cardvalue = 0
    if card.face_value == "2"
      cardvalue = 2
    elsif card.face_value == "3"
      cardvalue = 3
    elsif card.face_value == "4"
      cardvalue = 4
    elsif card.face_value == "5"
      cardvalue = 5
    elsif card.face_value == "6"
      cardvalue = 6
    elsif card.face_value == "7"
      cardvalue = 7
    elsif card.face_value == "8"
      cardvalue = 8
    elsif card.face_value == "9"
      cardvalue = 9
    elsif card.face_value == "10"
      cardvalue = 10
    elsif card.face_value == "Jack"
      cardvalue = 10
    elsif card.face_value == "Queen"
      cardvalue = 10
    elsif card.face_value == "King"
      cardvalue = 10
    elsif card.face_value == "Ace"
      cardvalue = 11
      aces_in_hand = aces_in_hand + 1
    end
    handvalue = handvalue + cardvalue
    end
    while aces_in_hand > 0 do
      if handvalue > Blackjack::BLACKJACK_AMOUNT
        handvalue = handvalue - 10
      end
      aces_in_hand = aces_in_hand - 1
    end
    handvalue
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > Blackjack::BLACKJACK_AMOUNT
  end
end


class Player
  include Hand

  attr_accessor :name, :cards

  def initialize(n)
    @name = n
    @cards = []
  end

  def show_flop
    show_hand
  end

end

class Dealer
    include Hand

    attr_accessor :name, :cards

    def initialize
      @name = Dealer
      @cards = []
    end

    def show_flop
      puts "Dealer is holding:"
      puts "(Dealer's first card is hidden.)"
      puts "Dealer's second card is: #{cards[1]}"
    end
end

class Blackjack
  attr_accessor :deck, :player, :dealer

  BLACKJACK_AMOUNT = 21
  DEALER_HIT_POINT = 17

  def initialize
    @deck = Deck.new
    @player = Player.new("player_one")
    @dealer = Dealer.new
  end

  def set_player_name
    puts "What is your name?"
    player.name = gets.chomp
  end

  def deal_cards
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end

  def show_flop
    player.show_flop
    dealer.show_flop
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total == BLACKJACK_AMOUNT
      if player_or_dealer.is_a?(Dealer)
        puts "The dealer hit blackjack. #{player.name} loses."
      else
        puts "You hit blackjack! You win!"
      end
      play_again?
    elsif player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Dealer)
        puts "The dealer busted. #{player.name} wins!"
      else
        puts "You busted. Sorry, you lose."
      end
      play_again?
    end
  end

  def player_turn
    blackjack_or_bust?(player)
    while !player.is_busted? do
      puts "What would you like to do?  1) Hit  2) Stay"
      decision = gets.chomp
      if decision == "2"
        break
      elsif decision == "1"
        player.add_card(deck.deal_one)
        player.show_hand
        puts "#{player.name}'s total is: #{player.total}"
        blackjack_or_bust?(player)
      else
        puts "Please enter either '1' or '2'."
        next
      end
    end
  end

  def dealer_turn
    blackjack_or_bust?(dealer)
    while dealer.total < DEALER_HIT_POINT
      dealer.add_card(deck.deal_one)
      dealer.show_hand
      blackjack_or_bust?(dealer)
    end
    puts "Dealer stays at #{dealer.total}."
  end

  def who_won?
    if player.total > dealer.total
      puts "#{player.name} wins! Congratulations!"
    elsif player.total < dealer.total
      puts "#{player.name} loses. Sorry!"
    else
      puts "The game is a tie."
    end
    play_again?
  end

  def play_again?
    puts "Would you like to play again?  1) Yes  2) No"
    if gets.chomp == "1"
      puts "Starting new game."
      puts " "
      deck = Deck.new
      player.cards = []
      dealer.cards = []
      start
    else
      puts "Thanks for playing!"
      exit
    end 
  end

  def start
    set_player_name
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?
  end
end

game = Blackjack.new
game.start
