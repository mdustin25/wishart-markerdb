module ChemicalsHelper
#  def chemical_path(bm)
#    "/#{bm.bmid}"
#  end

  def print_formula( chemical_marker )
    h(chemical_marker) \
      .gsub( /(\d+)/, '<sub>\1</sub>').html_safe
  end
end
