
refs = Reference.where("pubmed_id is not null").includes(:citations)
doubles = {}
refs.each{|x| doubles[x.pubmed_id] || = []; doubles[x.pubmed_id] = x }

updated_citations = []

doubles.each_value do |dups|
  counts = {}
  dups.each{|x| counts[x] = x.citation.count}

  if counts.values.uniq == [0]
    #delete all but first
    counts.keys[1..-1].each(&:delete)
  else
    with_citations = dups.select{|x| counts[x] > 0}
    dups.delete with_citations
    dups.each(&:delete)
    citations = with_citations.map(&:citations)
    citations.each{|x| x.reference = with_citations.first}
    updated_citations << citations
    with_citations[1..-1].each(&:delete)
  end
end

Citation.import updated_citations.flatten, :on_duplicate_key_update => [:reference_id]

