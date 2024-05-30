namespace :default_data do
  task create: [:environment] do

    LinkType.transaction do
      LinkType.where(
        name: "PDB",
        prefix: "http://www.rcsb.org/pdb/explore/explore.do?structureId="
      ).first_or_create

      LinkType.where(
        name: "Uniprot",
        prefix: "http://www.uniprot.org/uniprot/"
      ).first_or_create
    end

  end
end
