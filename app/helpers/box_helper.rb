module BoxHelper
  # makes content box with a title around 
  # the content.  Most content should be
  # divided up into sections and each 
  # section in a box using this helper
  def box( title, options={},  &block )
    content = capture(&block)
    
    options[:class] ||= "" 
    options[:class] += " box"
    
    content_tag( :div, options ) do
      content_tag( :h1, title ) + 
        content_tag( :div, content, :class => :content) 
    end 
  end

  # this content box should be used for
  # description content 
  #  - if the object is aliasable it will automatically
  #  add the alternate names field
  #
  #  - extra information can be added by calling a block like
  #
  #   <%= box_description @chemical do %>
  #     <%= info_row "Iupac", @chemical.iupac %>
  #   <% end %>
  def box_description(object, options={}, &block)
    return nil if object.nil? || ( object.description.nil? && ( !object.respond_to?(:aliases) || object.aliases.empty? ))

    options[:class] ||= "" 
    options[:class] += " intro"
    
    # clean up the description text
    description = object.description || ""
    description.gsub!(/(?!^)\n/,"")
    description.gsub!(/\n/,"\n\n")

    # collect extra info rows
    extra_info = ActiveSupport::SafeBuffer.new

    # add the aliasable info row if it is aliasable
    #if object.class.include? Aliasable
    # if object.respond_to? :aliases 
    #   extra_info << info_table{info_row("Alternate names", object.names * "; ")}
    # end

    # get the rows in the block if it is given 
    extra_info << info_table(&block) if block_given?

    # rap the rows with the info_table helper if there are any
    extra_info = info_table{ extra_info } unless extra_info.blank?

    # puts "description => #{description}"
    description = text_with_linked_references(description, object)

    # rap the info table with a box titled Description
    # and put the description text and info box
    box "Description", options do
      simple_format(description) + extra_info
    end
  end

  # this is a helper to add information tables to the
  # boxes
  def info_table(opts={},&block)
    opts[:class] ||= ""
    opts[:class] += " info-table"
    content_tag :table, opts do  
      capture(&block)
    end
  end

  # this helper allows you to add information rows 
  # to the description box like so:
  #
  #   <%= box_description @chemical do %>
  #     <%= info_row "Iupac", @chemical.iupac %>
  #   <% end %>
  # def info_row(title,content)
  #      content_tag :tr do
  #        content_tag(:th, title, :style=>"text-align:left; font-size:1em; width:75%") + 
  #         content_tag(:td, content,:style=>"text-align:left; font-size:1em;")
  #      end
  # end
  def info_row(title,content, title_width=15)
    content_tag :tr do
    content_tag(:th, title, :style=>"text-align:left; font-size:1em; width:#{title_width}%") +
    content_tag(:td, content,:style=>"text-align:left; font-size:1em;")
    end
  end
  # this is used for a content box with sorted headers
  # proper use is (example only make header1 sortable)
  # # <%= box_table "title", %w[header1]
  # %w[header1 header2], collection do %>
  #   <td>col1 content</td>
  #   <td>col2 content</td>
  # #<% end %>
  # if [] is given for headers then the header row
  # is not rendered
  def sorted_box_table(title, header_sort, column_headers, collection, &block)
    table_id = title.sub(/[\s]/,"_")
    if collection.nil? || collection.empty?
      return box(title){content_tag(:em, "No items found")} 
    end
    output = ActiveSupport::SafeBuffer.new
    output.safe_concat <<-HTML
      <div class=\"box\" id=#{table_id}>
        <h1>#{title}</h1> 
        <div class=\"table-responsive\">
          <table class="table table-striped table-condensed table-hover metabolites">
    HTML
    if column_headers.size > 0
      output.safe_concat("<thead><tr>")
      column_headers.each do |header|
        if header_sort.include?(header)
          output << content_tag( :th, table_sort_link(header,header), :style => "text-align: left;")
        else
          output << content_tag( :th, header,:style => "text-align: left;")
        end
      end
      output.safe_concat("</tr></thead>")
    end

    output.safe_concat("<tbody>")
    collection.each do |o| 
      new_block = Proc.new do 
        block.call( o )
      end
      output << content_tag(
        :tr, 
        capture(&new_block), 
        :class => cycle("even", "odd")

      )
    end
    output.safe_concat <<-HTML 
            </tbody>
          </table>
        </div>
      </div>
    HTML
  end

  # this is used for a content box with
  # a table in it
  # proper use is 
  #
  # <%= box_table "title"
  # %w[header1 header2], collection do %>
  #   <td>col1 content</td>
  #   <td>col2 content</td>
  # <% end %>
  # 
  # if [] is given for headers then the header row
  # is not rendered
  def box_table(title, column_headers, collection, &block)
    table_id = title.sub(/[\s]/,"_")
    if collection.nil? || collection.empty?
      return box(title){content_tag(:em, "No items found")} 
    end
    output = ActiveSupport::SafeBuffer.new
    output.safe_concat <<-HTML
      <div class=\"box\" id=#{table_id}>
        <h1>#{title}</h1> 
        <div class=\"table-responsive\">
          <table class=\"table table-striped table-condensed table-hover metabolites\">
    HTML
    if column_headers.size > 0
      output.safe_concat("<thead><tr>")
      column_headers.each do |header|
        output << content_tag( :th, header, :style => "text-align: left;")
      end
      output.safe_concat("</tr></thead>")
    end

    output.safe_concat("<tbody>")
    collection.each do |o| 
      new_block = Proc.new do 
        block.call( o )
      end
      output << content_tag(
        :tr, 
        capture(&new_block), 
        :class => cycle("even", "odd")

      )
    end
    output.safe_concat <<-HTML 
            </tbody>
          </table>
        </div>
      </div>
    HTML
  end

  # this helper renders a list of items using their default partials
  # that way it can be used for a mixed collection of items or 
  # for a homogenous collection
  # TODO automatically add pagination
  # TODO add ability to select a folder of alternate partials
  def box_list(title, collection )
    if collection.nil? || collection.empty?
      return box(title){content_tag(:em, "No items found")} 
    end

    list = collection.reduce(ActiveSupport::SafeBuffer.new) do |buffer,item|
      buffer.safe_concat content_tag(
        :table,render(item),
        :class => cycle("even", "odd")
      )
    end
 
    box(title,:id => title.sub(/[\s]/,"_"), :class => "list" ){list}
  end


  # this helper renders a list of items using their default partials
  # that way it can be used for a mixed collection of items or 
  # for a homogenous collection
  # With pagination
  def box_list_with_pagination(title, collection, page)
    if collection.nil? || collection.empty?
      return box(title){content_tag(:em, "No items found")} 
    end

    collection = collection.paginate(:page => page, :per_page => 3)

    list = collection.reduce(ActiveSupport::SafeBuffer.new) do |buffer,item|
      buffer.safe_concat content_tag(
        :table,render(item),
        :class => cycle("even", "odd")
      )
    end
  
    box(title,:id => title.sub(/[\s]/,"_"), :class => "list" ){list}
  end




  def text_with_linked_references(text, object)
    # Please don't convert to REGEX. It is a big one and not future-self friendly.
    # Sometimes some verbosity goes a long way...

    return text if text.blank?

    begin # Rescue errors to ensure this never fails and kills the page
      linked_text = text.to_s.dup
      linkers = { pubmed: 'PMID', omim: 'OMIM' }

      linkers.each do |link_type, matcher|
        matches = text.scan(/#{matcher}:?\s*([\d\,\s]+)/i)
        replaced = Set.new

        if matches.present?
          matches.each do |match|
            match.first.split(/,\s*/).each do |id|
              next if id.blank? || replaced.include?(id)
              replaced << id
              linked_text.gsub!(id, bio_link_out(link_type, id))
            end
          end
        end
      end

      uris = URI.extract(text)
      reference_box = text.scan(/\[[a-zA-Z ]*\]/)
      if uris.length == reference_box.length
        # array.each_with_index {|val, inds| puts "#{val} => #{index}" }
        uris.each_with_index { |val, inds|
          replaced = "#{reference_box[inds]} #{val}"
          reference_box_text = reference_box[inds].gsub("[","").gsub("]","")
          linked_text.gsub!(replaced, "<a target=\"_blank\" class=\"wishart-link-out\" href=#{val}> #{reference_box_text}<span class=\"glyphicon glyphicon-new-window\"> </span></a>")
        } 
      end

      # Add Wikipedia links
      if text.include? "Wikipedia"
        if wikipedia_id = object.wrangler_identifiers["wikipedia_id"]
          linked_text.gsub!("Wikipedia", bio_link_out(:wikipedia, wikipedia_id, "Wikipedia"))
        end
      end

      linked_text
    rescue Exception => e
      # puts "exception => #{e.message}"
      return text
    end
  end

  def info_table_link_reference_pmid(pubmed_id)
    links = "<a data-placement=\"top\" data-toggle=\"tooltip\" href=\"https://www.ncbi.nlm.nih.gov/pubmed/#{pubmed_id}\"> PMID: #{pubmed_id} </a>"
    return links.html_safe
  end

  def info_table_link_reference_url(ref_obj)
    puts "ref_obj => #{ref_obj}"
    links = "<a href=#{ref_obj.url} data-toggle=\"tooltip\" data-placement=\"top\" title=\"#{ref_obj.citation}\">#{ref_obj.citation.to_s.truncate(20)} </a>"
    return links.html_safe
  end


  def prettify_sequence(chain)
    after_style = ""
    length_per_line = 60 # 60 char then \n
    space_per_line = 10 # 10 char then space
    # {line number}<span></span>
    # <table>
    # <tr>
    #     <td>Alfreds Futterkiste</td>
    #     <td>Maria Anders</td>
    #     <td>Germany</td>
    #   </tr>
    #   <tr>
    #     <td>Centro comercial Moctezuma</td>
    #     <td>Francisco Chang</td>
    #     <td>Mexico</td>
    #   </tr>

    # after_style += "1<span>"
    after_style += "<table id=\"sequence-table\" style=\"font-size:12px\"><tr><td>1</td><td style=\"font-family: Courier, monospace; max-width: 101ch;\">#{chain.first}"
    (1..chain.length).step(1) do |n|
      
      if n%space_per_line == 0
        after_style += " "
      end

      if n%length_per_line == 0
        after_style +=  "</td></tr><tr><td>#{n+1}</td><td style=\"font-family: Courier, monospace; max-width: 101ch;\">"
      end
      if n != chain.length
        after_style += chain[n]
      end
    end

    after_style += "</td></tr></table>"

    return after_style.html_safe
  end

end









































