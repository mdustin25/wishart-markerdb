sliced_pubmed_ids = File.open("entrezgene_pubmed_ids_to_fetch.csv","r").
  readlines.map(&:strip).each_slice(1000).to_a

sliced_pubmed_ids.each_with_index do |slice,i|
  print "fetching batch #{i + 1} of #{sliced_pubmed_ids.count} ... "
  PubmedFetcher.fetch_batch(slice)
  puts "done"
end
