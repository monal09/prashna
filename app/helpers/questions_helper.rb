module QuestionsHelper

  def get_display_message(action, query = nil, topic_id = nil, topic = nil)

    case action
    when "questions"
      "Most recent questions for you"
    when "search"
      "Search results for your query <b><u>#{query}</u></b>".html_safe
    when "topics"
      if topic_id.blank?
        "Results for your topic search <b><u>#{topic}</u></b>".html_safe
      else
        "Results for your topic search <b><u>#{Topic.find_by(id: topic_id).name}</u></b>".html_safe
      end
    end

  end
end
