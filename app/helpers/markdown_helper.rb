module MarkdownHelper

  RENDER_OPTIONS = {
    filter_html: true,
    hard_wrap: true,
    link_attributes: { rel: "nofollow" }
  }

  EXTENSIONS = {
    autolink: true,
    tables: true,
    fenced_code_blocks: true,
    strikethrough: true,
    lax_spacing: true,
    space_after_headers: true,
    underline: true,
    highlight: true,
    footnotes: true
  }

  def render_markdown(text)
    renderer = CustomMarkdownRenderer.new(RENDER_OPTIONS)
    markdown = Redcarpet::Markdown.new(renderer, EXTENSIONS)

    markdown.render(text).html_safe
  end
end
