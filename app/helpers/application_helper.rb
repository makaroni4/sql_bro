module ApplicationHelper
  def nav_li(name=nil, path="#", *args, &block)
    path = name || path if block_given?
    is_active = current_page?(path)

    options = args.extract_options!

    content_tag :li, class: is_active ? "active" : "" do
      if block_given?
        link_to path, options, &block
      else
        link_to name, path, options, &block
      end
    end
  end
end
