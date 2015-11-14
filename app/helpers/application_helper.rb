module ApplicationHelper
  include Rack::Recaptcha::Helpers

  # Method for sorting table.
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, params.merge(sort: column, direction: direction, page: nil), { class: css_class }
  end

  def title(page_title)
    content_for :title, page_title.to_s
  end

  # Method for include JavaScripts for different pages.
  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end
end
