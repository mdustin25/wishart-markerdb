FactoryGirl.define do 
  factory :chemical do 
    name "1-Methylhistidine"
    description "One-methylhistidine (1-MHis) is derived mainly from..."
    source nil
    molecule_type nil
    hmdb "HMDB00001"
    moldb_id 9955
    moldb_smiles "CN1C=NC(C[C@H](N)C(O)=O)=C1"
    moldb_formula "C7H11N3O2"
    moldb_inchi "InChI=1S/C7H11N3O2/c1-10-3-5(9-4-10)2-6(8)7(11)12/h..."
    moldb_inchikey "InChIKey=BRMWTNUJHUMWMS-LURJTMIESA-N"
    moldb_iupac "(2S)-2-amino-3-(1-methyl-1H-imidazol-4-yl)propanoic..."
    moldb_logp "-3.0704187479965057"
    moldb_pka "6"
    moldb_average_mass "169.1811"
    moldb_mono_mass "169.085126611"
    moldb_alogps_solubility "6.93e+00 g/l"
    moldb_alogps_logp "-2.95"
    moldb_alogps_logs "-1.39"
    moldb_acceptor_count "4"
    moldb_donor_count "2"
    moldb_rotatable_bond_count "3"
    moldb_polar_surface_area "81.14"
    moldb_refractivity "42.39"
    moldb_polarizability "16.95233574921409"
    moldb_traditional_iupac "4-methyl-histidine"
    moldb_formal_charge 0 
  end
end
