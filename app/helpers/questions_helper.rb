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

  def get_filter(params)
    case params[:controller]
    when "questions"
      filter = ""
    when "search"
      filter = "search_query+" + params[:query]
    when "topics"
      filter = "search_topic+" + params[:id].to_s
    end
    return filter

  end

end
