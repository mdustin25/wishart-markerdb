module LabTestsHelper
  # link to a page on the FDA site
  # displaying tests for for the search_term
  def fda_link_for( lab_test )
    link_to "FDA approved kits",
    "http://www.accessdata.fda.gov/scripts" +
    "/cdrh/cfdocs/cfivd/index.cfm?" + 
    "search_term=#{html_escape(lab_test.fda_search_term)}"
  end

  def link_to_fda_page(fda_kit)
    url = 
      "http://www.accessdata.fda.gov/" +
      "scripts/cdrh/cfdocs/cfivd/index.cfm?" +
      "db=pmn&id=#{fda_kit.doc_number}"

    link_to "FDA", url
  end

  def co_assay_links(lab_test)
    output = ActiveSupport::SafeBuffer.new
    list = @lab_test.co_assays.collect do |test| 
      link_to( test.name, test ) 
    end 
    output.safe_concat( list * ", " )
  end
 
  def usage_list( lab_test )
    list = lab_test.usages.collect do |usage|
      usage.name
    end
    list * ", "
  end

  def approval_list( lab_test )
    if lab_test.approvals.empty? 
      "none" 
    else
      list = lab_test.approvals.collect do |approval|
        approval.name
      end
      list * ", "
    end
  end

end
