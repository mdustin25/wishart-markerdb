module ImageHelper
  def thumb_image(object)
    begin
      render( 
        :partial => "#{object.class.to_s.tableize}/thumb",
        :locals => { object.class.to_s.downcase.to_sym => object}
      )
    rescue
      puts "failed"
    end
  end

end
