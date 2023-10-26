class Participant
  attr_accessor :cards_in_hand

  def initialize
    @cards_in_hand = []
  end

  # returns the participant's card at a specific index
  def [](index)
    card = cards_in_hand[index]
    num = card[0]
    suit = card[1]
    "#{num} of #{suit}"
  end

  def last_card
    self[cards_in_hand.length - 1]
  end

  def hand_value
    card_values = cards_without_suits
    updated_card_values = replace_strings_with_ints(card_values)
    adjust_for_aces(updated_card_values)
  end

  def bust?
    hand_value > 21
  end

  private

  def adjust_for_aces(cards)
    num_aces = cards.count do |value|
      value == 1
    end
    total = cards.sum
    start = 0
    while total <= 21 && start < num_aces
      if (total + 10) <= 21
        total += 10
      else
        break
      end
      start += 1
    end
    total
  end

  def replace_strings_with_ints(cards)
    cards.map do |value|
      case value
      when "ace"
        1
      when "jack"
        10
      when "queen"
        10
      when "king"
        10
      else
        value
      end
    end
  end

  def cards_without_suits
    cards = cards_in_hand.flatten
    cards.select.with_index do |_, index|
      index.even?
    end
  end
end

class Deck
  def initialize
    @cards = setup_and_shuffle
  end

  def setup_and_shuffle
    hash = {
      clubs: [],
      spades: [],
      hearts: [],
      diamonds: []
    }
    hash.each_key do |key|
      hash[key] += (2..10).to_a
      hash[key] += ["jack", "queen", "king", "ace"]
      hash[key].shuffle!
    end
    hash
  end

  def get_card
    suit = cards.keys.sample
    card = cards[suit].pop
    [card, suit]
  end

  private

  attr_reader :cards
end

class TwentyOneGame
  def play
    display_welcome
    loop do
      deal_initial_cards
      player_turn
      dealer_turn unless player.bust?
      display_results unless dealer.bust? || player.bust?
      break unless play_again?
      reset
      display_play_again_message
    end
    display_goodbye
  end

  private

  attr_reader :deck, :player, :dealer

  def initialize
    @player = Participant.new
    @dealer = Participant.new
    @deck = Deck.new
  end

  def display_welcome
    system 'clear'
    puts "Welcome to 21!"
    puts ""
  end

  def deal_initial_cards
    deal_card(player)
    deal_card(player)
    deal_card(dealer)
    deal_card(dealer)
    display_player_cards
    display_one_dealer_card
    puts ""
  end

  def deal_card(participant)
    participant.cards_in_hand.push(deck.get_card)
  end

  def display_one_dealer_card
    puts "The dealer has a #{dealer[0]} and a card face down."
  end

  def display_both_dealer_cards
    puts "The dealer has a #{dealer[0]} and a #{dealer[1]}."
  end

  def display_player_cards
    puts "You have been dealt a #{player[0]} "\
           "and a #{player[1]}."
  end

  def player_turn
    loop do
      if player_hit?
        deal_card(player)
        puts ""
        puts "You are dealt a #{player.last_card}"
        puts ""
        if player.bust?
          puts "You busted! You lose!"
          break
        end
      else
        break
      end
    end
  end

  def player_hit?
    response = nil
    loop do
      puts "Would you like to hit or stay?"
      response = gets.chomp.downcase
      break if response == "hit" || response == "stay"
      puts "Please enter a valid response."
      puts ""
    end
    response == "hit"
  end

  def dealer_turn
    puts ""
    puts "The dealer flips over their card."
    display_both_dealer_cards
    puts ""
    dealer_hit_loop
    if dealer.bust?
      puts "The dealer busted! You win!"
    else
      puts "The dealer stays."
      puts ""
    end
  end

  def dealer_hit_loop
    while dealer.hand_value <= 16
      puts "The dealer hits."
      deal_card(dealer)
      puts "The dealer deals themselves a "\
             "#{dealer.last_card}."
      puts ""
    end
  end

  def display_results
    puts "You have #{player.hand_value}."
    puts "The dealer has #{dealer.hand_value}."
    if player.hand_value > dealer.hand_value
      puts "You win!"
    elsif player.hand_value < dealer.hand_value
      puts "You lose!"
    else
      puts "The game is a push!"
    end
  end

  def play_again?
    puts ""
    answer = nil
    loop do
      puts "Would you like to play again? (yes/no):"
      answer = gets.chomp.downcase
      break if answer == "yes" || answer == "no"
      puts "Please enter a valid response."
      puts ""
    end
    answer == "yes"
  end

  def reset
    deck.setup_and_shuffle
    player.cards_in_hand = []
    dealer.cards_in_hand = []
    system 'clear'
  end

  def display_play_again_message
    puts ""
    puts "Welcome back to 21.  Let's play again!"
    puts ""
  end

  def display_goodbye
    puts ""
    puts "Thank you for playing. Goodbye!"
  end
end

TwentyOneGame.new.play
