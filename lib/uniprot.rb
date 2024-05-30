require 'nokogiri'
require 'open-uri'

module Uniprot
  
  # Download and annotate the given uniprot_id and return an entry as an array
  def Uniprot.annotate_name(uniprot_id)
    doc = Nokogiri::XML( open("http://www.uniprot.org/uniprot/#{uniprot_id}.xml") )
    doc.remove_namespaces!
    name_node = doc.at_xpath("//recommendedName/fullName")
    if name_node.blank?
      name_node = doc.at_xpath("//submittedName/fullName")
    end
    puts "Does this reach"
    return nil if name_node.blank?
    return name_node.inner_text
  end
  
 # Returns a hash of results required to annotate a molecule with data from UniProt
  def Uniprot.annotate(uniprot_id)
    begin
      doc = Nokogiri::XML( open("http://www.uniprot.org/uniprot/#{uniprot_id}.xml") )
    rescue OpenURI::HTTPError => error
      puts "Whoops got a bad status code #{error.message}: #{uniprot_id}"
      return nil
    end
    
    doc.remove_namespaces!
    results = Hash.new

    entry = doc.at_xpath("//entry")
    return nil if entry.blank?

    results[:dataset] = entry['dataset']

    # Grab identifiers
    results[:primary_accession] = doc.xpath("//accession")[0].inner_text

    name_node = doc.at_xpath("//recommendedName/fullName") || doc.at_xpath("//submittedName/fullName")
    results[:name] = name_node.inner_text
    
    results[:uniprot_name] = doc.at_xpath("uniprot/entry/name").inner_text
    if n = doc.at_xpath("//gene/name[@type='primary']")
      results[:gene_name] = n.inner_text
    end
    
    # Synonyms
    results[:synonyms] = Array.new
    doc.xpath("//gene/name[@type='synonym']").each do |synonym|
      results[:synonyms] << synonym.inner_text
    end
    if name_node = doc.at_xpath("//recommendedName/shortName") 
      results[:synonyms] << name_node.inner_text
    end

    if alternate_names = doc.xpath("//alternativeName/fullName")
      results[:synonyms] += alternate_names.map(&:content)
    end

    #if name_node = doc.at_xpath("//recommendedName/ecNumber") 
      #results[:synonyms] << name_node.inner_text
    #end

    # Function
    if n = doc.at_xpath("//comment[@type='function']")
      results[:general_function] = n.inner_text.strip
    end

    description = [
      results[:general_function],
      doc.xpath("//comment[@type='function']/text").map(&:content),
      doc.xpath("//comment[@type='catalytic activity']/text").map(&:content)
    ].flatten.compact.join(". ").split(/\.+/).map(&:strip).uniq.join(". ").
      gsub(/(?<=\.\s)Major/,"It's a major")

    results[:description] = description

    # Gene name
    if n = doc.at_xpath("//gene/name[@type='primary']")
      results[:gene_name] = n.inner_text.strip
    end

    # PFam
    results[:pfams] = Array.new
    doc.xpath("//dbReference[@type='Pfam']").each do |pfam|
      results[:pfams] << { :name => pfam.at_xpath('property[@type="entry name"]')['value'], :id => pfam['id'] }
    end

    # Protein Sequence
    results[:polypeptide_sequence] = doc.at_xpath('//entry/sequence').inner_text.strip

    # External identifiers
    if n = doc.at_xpath("//dbReference[@type='GeneCards']")
      results[:genecard_id] = n['id']
    end

    if n = doc.at_xpath("//dbReference[@type='HGNC']")
      results[:hgnc_id] = n['id']
    end

    # PDB IDs
    results[:pdb_ids] =
      doc.xpath("//dbReference[@type='PDB']").map{|i| i['id']}


    # Grab organism info
    organism_node = doc.at_xpath('//organism')
    results[:ncbi_taxonomy_id] = organism_node.at_xpath("dbReference[@type='NCBI Taxonomy']")['id']
    results[:uniprot_taxon_id] = organism_node.at_xpath("dbReference")['id']
    results[:uniprot_taxon_db] = organism_node.at_xpath("dbReference")['type']
    results[:organism_scientific_name] = organism_node.at_xpath('name[@type="scientific"]').inner_text
    if n = organism_node.at_xpath('name[@type="common"]')
      results[:species] = n.inner_text
    end
    
    # Grab references
    results[:pubmed_ids] = Array.new
    doc.xpath("//dbReference[@type='PubMed']").each do |pubmed|
      results[:pubmed_ids] << pubmed['id']
    end
    results[:pubmed_ids].uniq!
    
    # Grab GO classifications
    results[:go_classes] = Array.new
    doc.xpath("//dbReference[@type='GO']").each do |g|
      go_class = g.at_xpath('property[@type="term"]')['value']
      code, description = go_class.split(':')
      category = case code
        when 'F' then 'function'
        when 'P' then 'process'
        when 'C' then 'component'
        else raise Exception 'GO class not found'
      end
      results[:go_classes] << { :category => category, :description => description }
    end
    
    results
  end
end
