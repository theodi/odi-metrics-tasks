require 'trello'
require 'helpers/trello_helper'

Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_DEV_KEY']
  config.member_token = ENV['TRELLO_MEMBER_KEY']
end

class TrelloBoard

  include TrelloHelper

  def initialize(board_id)
    @board = trello_rescue{Trello::Board.find(board_id)}
    @cards = trello_rescue{@board.cards}
    @discuss_list = discuss_list
    @done_list = done_list
  end

  def outstanding
    cards = []
      if card.closed == false && trello_rescue{card.list}.id != @discuss_list && trello_rescue{card.list}.id != @done_list
        cards << get_progress(card)
      end
    end
    cards
  end

  def to_discuss
    cards = []
      if card.list.id == @discuss_list
    @cards.each do |card|
        cards << get_progress(card)
      end
    end
    cards
  end

  def done
    cards = []
      if trello_rescue{card.list}.id == @done_list
    @cards.each do |card|
        cards << get_progress(card)
      end
    end
    cards
  end

  def discuss_list
    get_list("to discuss")
  end

  def done_list
    get_list("done")
  end

  def get_list(name)
    trello_rescue{@board.lists}.select { |l| l.name.downcase == name.downcase }.first.id rescue nil
  end

  def get_progress(card)
    progress = []
    total = 0
    complete = 0
    trello_rescue{card.checklists}.each do |checklist|
      unless trello_rescue{checklist.check_items}.count == 0
        total    += trello_rescue{checklist.check_items}.count
        complete += trello_rescue{checklist.check_items}.select { |item| item["state"]=="complete" }.count
      end
    end
    progress = complete.to_f / total.to_f
    no_checklist = progress.nan?
    progress = 0 if progress.nan?
    {id: card.id, title: card.name, due: card.due, progress: progress, no_checklist: no_checklist}
  end

end
