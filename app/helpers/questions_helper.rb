module QuestionsHelper

  def get_display_message(action)

    case action
    when "questions"
      "Most recent questions for you"
    when "search"
      "Search results for your query"
    when "topics"
      "Results for your topic search"
    end
  end

end
