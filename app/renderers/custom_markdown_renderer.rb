class CustomMarkdownRenderer < Redcarpet::Render::HTML

  def link(link, title, content)
    html = %(<a href="#{link}" target="_blank" rel="noopener noreferrer")
    html << %( title="#{title}") if title
    html << %(>#{content}</a>)

    html.html_safe
  end
end
