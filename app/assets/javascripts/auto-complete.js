$(function() {

  var full_set_tag   = get_chemical_tag().concat(get_genetic_tag()).concat(get_protein_tag()).concat(get_karyotype_tag()).concat(get_condition_tag());
  var condition_tag  = get_condition_tag();
  var all_marker_tag = get_chemical_tag().concat(get_genetic_tag()).concat(get_protein_tag()).concat(get_karyotype_tag());
  var chemical_tag   = get_chemical_tag();
  var genetic_tag    = get_genetic_tag();
  var protein_tag    = get_protein_tag();
  var karyotype_tag  = get_karyotype_tag();


  $("select#searcher").change(function(){
      let selected = $(this).children("option:selected").val();
      // console.log(selected);
      var availableTags = undefined;

      if (selected === "full_site"){
      	availableTags = full_set_tag;
      }
      else if (selected === "conditions"){
      	availableTags = condition_tag;
      }
      else if (selected === "biomarkers"){
      	availableTags = all_marker_tag;
      }
      else if (selected === "chemicals"){
      	availableTags = chemical_tag;
      }
      else if (selected === "genetic_markers"){
      	availableTags = genetic_tag;
      }
      else if (selected === "proteins"){
      	availableTags = protein_tag;
      }
      else if (selected === "karyotypes"){
      	availableTags = karyotype_tag;
      }
      else{
      	availableTags = full_set_tag;
      }

      $( "#query" ).autocomplete({
        source: function(request, response){
        	var results = $.ui.autocomplete.filter(availableTags, request.term);
        	response(results.slice(0, 5));
        }
      });
  	});



  let page_form = $(".search-form-each-page").find("input").attr("data-type");
  let correct_tag = undefined;
  if (page_form === "conditions"){
    correct_tag = condition_tag;
  }else if (page_form === "chemicals"){
    correct_tag = chemical_tag;
  }
  else if (page_form === "karyotypes"){
    correct_tag = karyotype_tag;
  }
  else if (page_form === "genetics"){
    correct_tag = genetic_tag;
  }
  else if (page_form === "proteins"){
    correct_tag = protein_tag;
  }

  if (correct_tag != undefined){
    $(".search-form-each-page").find("input").autocomplete({
        source: function(request, response){
          var results = $.ui.autocomplete.filter(correct_tag, request.term);
          response(results.slice(0, 5));
        }
    });
  }

  
});








































