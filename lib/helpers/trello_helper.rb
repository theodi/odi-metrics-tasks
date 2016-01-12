module TrelloHelper
  
  TRELLO_RETRIES = 3
  
  def trello_rescue
    retries = 0
    yield
  rescue Trello::Error
    if retries < TRELLO_RETRIES
      retries += 1
      sleep 1
      puts "Trello::Error caught. Retrying (attempt #{retries})..."
      retry
    else
      raise
    end
  end
  
end