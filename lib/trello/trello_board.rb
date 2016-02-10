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
    get_cards(Proc.new { |card| card.closed == false && card.list_id != @discuss_list && card.list_id != @done_list })
  end

  def to_discuss
    get_cards(Proc.new { |card| card.list_id == @discuss_list })
  end

  def done
    get_cards(Proc.new { |card| card.list_id == @done_list })
  end

  def get_cards(proc)
    @cards.select { |card| proc.call(card) }
          .map { |card| get_progress(card) }
  end

  def discuss_list
    get_list("to discuss")
  end

  def done_list
    get_list("done")
  end

  def lists
    @lists ||= trello_rescue{@board.lists}
  end

  def get_list(name)
    lists.select { |l| l.name.downcase == name.downcase }.first.id rescue nil
  end

  def get_progress(card)
    progress = []
    total = 0
    complete = 0
    trello_rescue{card.checklists}.each do |checklist|
      check_items = trello_rescue{checklist.check_items}
      unless check_items.count == 0
        total    += check_items.count
        complete += check_items.select { |item| item["state"]=="complete" }.count
      end
    end
    progress = complete.to_f / total.to_f
    no_checklist = progress.nan?
    progress = 0 if progress.nan?
    {id: card.id, title: card.name, due: card.due, progress: progress, no_checklist: no_checklist}
  end

end
