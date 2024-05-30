module MeasurementsHelper
  include BoxHelper

  def measurement_boxes(biomarker, *boxes)
    boxes.reduce(ActiveSupport::SafeBuffer.new) do |buffer,type|
      buffer << render(
        :partial => "measurements/#{type}", 
        :object  => biomarker.send(type) 
      )
    end
  end

  def measurement_box(title, column_headers, collection, &block)
    box_table title, column_headers, collection || [], &block 
  end
end
