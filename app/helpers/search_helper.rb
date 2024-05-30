module SearchHelper

  SEARCH_TYPES = {
    # "Full Site" => "full_site",
    "Conditions"  => "conditions",
    # "All Markers" => "biomarkers",
    "Chemicals" => "chemicals",
    "Genetic Markers" => "genetic_markers",
    "Proteins" => "proteins",
    "Karyotypes" => "karyotypes"
  }

  def search_form(select_options=SEARCH_TYPES)
    selectors = ""
    unless select_options.nil?
      selectors = select_tag(:searcher, options_for_select(select_options, selected: params[:searcher]))
    end

    form_tag(unearth.search_path, :method => :get, :id => "search") do
      selectors + text_field_tag(:query, params[:query]) + submit_tag("Search")
    end

  end

  REVERSE_LOOKUP_SEARCH_TYPES = SEARCH_TYPES.invert

  def search_name(search_index)
    REVERSE_LOOKUP_SEARCH_TYPES[search_index.to_s]
  end

end
