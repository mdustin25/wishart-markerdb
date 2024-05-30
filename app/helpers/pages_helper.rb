module PagesHelper

  def category(path,icon,name,text)
    link_to path, :class => :category do
        image_tag(icon+".png") +
        content_tag(:div) do
          content_tag(:h3, name) +
          content_tag(:p, text)
        end
    end
  end

  def section(title,&block)
    content_tag :div, :class => "section" do
      content_tag(:h3, title) +
      capture(&block)
    end
  end

end
