module ApplicationHelper
  # makes title div for info pages 
  def title( name )
    content_tag :div, name, :id=>"bm-title"
  end
  # menu bar item
  def menu_item( name, path )
    content_tag :td do 
      name_proper = name.gsub("-", "s ")
      link_to( name, path, :class => name_proper.downcase)
    end
  end

  def column_wrapper(&block)
    column_maker "col-wrapper", &block
  end

  def wide_column(&block)
    column_maker "wide-col", &block
  end

  def left_column(&block)
    column_maker "left-col", &block
  end

  def right_column(&block)
    column_maker "right-col", &block
  end

  def left_column_karyo(&block)
    column_maker "left-col-karyo", &block
  end

  def right_column_karyo(&block)
    column_maker "right-col-karyo", &block
  end

  private
  def column_maker(type, &block)
    content_tag :div, capture(&block), :class => type 
  end
end
