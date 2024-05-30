class LabTest < ActiveRecord::Base
    include Aliasable
    include Linkable
    include CitationOwner

    is_a_and_has_many :co_assays
    has_and_belongs_to_many :biofluids
    has_many :lab_test_ownerships
#    has_many :lab_test_owners,
#      :through => :lab_test_ownerships
    
    has_and_belongs_to_many :test_approvals
    has_many :test_uses
    # TODO just save this as a csv
    has_many :fda_kits, :dependent => :destroy

    def approvals; test_approvals; end
    def uses; test_uses; end

    def owners 
      lab_test_ownerships.map(&:owner)
    end

    def biomarkers
      lab_test_ownerships.biomarkers.map(&:owner)
    end

    def fda_link
      return nil if fda_search_term.nil?
      link = ExternalLink.new( 
        :name => "FDA approved kits",
        :link => "http://www.accessdata.fda.gov/scripts" +
          "/cdrh/cfdocs/cfivd/index.cfm?" + 
          "search_term=#{CGI::escapeHTML(fda_search_term)}"
      )
      link.readonly!
    end

    def lab_test_online_link
      return nil if lab_test_online_name.nil?
      link = ExternalLink.new(
        :key => lab_test_online_name,
        :link_type_name => "lab_test_online_metabolite"
      )
      link.readonly! 
      link
    end

    #define_index do
      #indexes [:name, lab_test_aliases.name], :as => :name
      #indexes description
    #end

end

# == Schema Information
#
# Table name: lab_tests
#
#  id                   :integer(4)      not null, primary key
#  name                 :string(255)
#  description          :text
#  created_at           :datetime
#  updated_at           :datetime
#  review_date          :date
#  fda_search_term      :string(255)
#  formal_name          :string(255)
#  lab_test_online_name :string(255)
#

