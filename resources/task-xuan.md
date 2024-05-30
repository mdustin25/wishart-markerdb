2) If a user types glucose in the Full Site search, the tope hit is “Sodium/glucose cotransporter”. The word glucose doesn’t show up at all. The site search needs to be smarter. (Xuan) ---> separate each search for different type (only in full_site)
 
3) In the text search if a user presses return after typing the word, they should get the same “response” as clicking the Search button. (Xuan)    ---> this should be working  DONE
 
3.5) The text search should give suggestions if the user has mistyped their query word (Xuan)
---> 

4) Advanced Search needs to support a) Protein Sequence Search, b) (KEVIN) DNA Sequence Search and c) Chemical Structure Search (Xuan) --> DONE
 
5) Response times for MarkerDB are quite slow – needs to be sped up, especially when pulling pages with >200 entries. It’s very slow for pulling up Diagnostic Biomarkers. Are we doing some “smart” memory flushing or pre-loading of data? (Xuan)
--> cache system Working on it

<!-- 0 2 * * * redis-cli flushall -->

9) Searching for chemicals and glucose via the search box, the list produces 33 hits, it should maybe produce 1-2. The formatting for the output is poor as the identifier box is too wide and it overlaps with the name of the compound.  Change the spacing and make the table look nicer and neater. (Xuan).
 
10) Clicking on the glucose hit (MDB000074) gives the description for Estriol instead of Glucose. Clicking on Arabinose (listed below Glucose) gives Progersterone. So there is a real problem with names and links for chemicals in the database right now. CRITICAL FIX (Xuan)  --> this is about mapping issue, consult with Kevin about this


 
11) Searching for conditions and diabetes gives 10 hits, we should probably only provide 3-4 hits as it appears we have duplicated diabetes many times. (Xuan) 


 
26) The layout for genetic biomarkers table should be as follows. The Filter function needs to include filters for bacterial sequences and for viral sequences as well as chromosomes.  The search by name box needs to be changed as described earlier. (Kevin/Xuan).

30) There is a very long lag to display the Diagnostic Biomarkers page (Xuan). --> cache system

40) All descriptions (disease, chemical, etc.) should have active hyperlinks to the references (Pubmed or DOI or others) (Xuan).
--> Done


22) The layout for each chemical biomarker (Abnormal Levels) should be as follows. Make sure to move column 2 over to the right so that everything fits on one line for column 1, right now you have column 1 and 2 too close): (Xuan). DONE
 
1) Specific Condition                                     9) Sensitivity                           16) ROC Curve
2) General Condition(s):                                 10) Specificity
3) Biofluid                                                      11) ROC-AUC
4) Disease Concentration                                12) ROC threshold
5) Normal Concentration                                13) P-Value
6) Age Range:                                                 14) Clinical Status
7) Sex:                                                             15) Notes/Limits:
8) References:


24) The layout for each protein biomarker should be as follows. The search by name box needs to be changed as described earlier. For the protein sequence, provide two versions of the sequence, one in FastA format and another version called “numerically formatted” so that users can see the numbering (space residues every 10, put lines to indicate 10, 20, 30, 40, 50). For the actual data set, move column 2 over to the right so that everything fits on one line for column 1, right now you have column 1 and 2 too close. (Xuan) DONE
 
1) Specific Condition                                     9) Sensitivity                           16) ROC Curve
2) General Condition(s):                                 10) Specificity
3) Biofluid                                                      11) ROC-AUC
4) Disease Concentration                                12) Cutoff values
5) Normal Concentration                                13) P-Value
6) Age Range:                                                 14) Clinical Status
7) Sex:                                                             15) Notes/Limits:
8) References:


26) The layout for genetic biomarkers table should be as follows. The Filter function needs to include filters for bacterial sequences and for viral sequences as well as chromosomes.  The search by name box needs to be changed as described earlier. (Kevin/Xuan).
 
27) The layout for each genetic biomarkers should include the full gene sequence (with introns and exons) and the mRNA sequence with the variant indicated in red.  For each gene sequence, provide two versions of the sequence, one in FastA format and another version called “numerically formatted” so that users can see the numbering (space residues every 10, put lines to indicate 10, 20, 30, 40, 50). For the actual data set, move column 2 over to the right so that everything fits on one line for column 1, right now you have column 1 and 2 too close. (Kevin). DONE
 
1) Specific Condition                                     9) Sensitivity                           16) ROC Curve
2) General Condition(s):                                 10) Specificity
3) Marker Type                                               11) ROC-AUC
4) Chromosome Position                                12) P-Value
5) Associated Gene                                         13) Clinical Status
6) Sequence Change (protein):                       15) Clinical Significance                               
7) Sequence Change (DNA)                                                  
8) References:
 

29) The layout for karyotype biomarkers table should be as follows. The second column should be called Idiogram (not Ideogram). A chromosomal filter box should be added. The word “Conditions” needs to be changed to “Condition Name”.  The search by name box needs to be changed as described earlier. (Kevin). DONE

31) For the Diagnostic Biomarkers Table, the Filter by biomarker type needs to be reformatted so all the names fit on one line. The names should be in the following order: Chemical, Protein, Genetic and Karyotype. You should also add a search by name box with the same format and style as described earlier. The title for the 4th column should be “Condition Name”.  The structure for all DNA or Genetic biomarkers should just be a nice picture of DNA or the double helix.  The Conditions listed should indicate if the biomarker is Clinically approved or investigational. Applying the filter to list “Chemical” only biomarkers takes forever (or the filter function doesn’t work – can’t tell).  I think this is true for all filter applications. (Kevin). DONE
 
32) For the Prognostic Biomarkers Table, the Filter by biomarker type needs to be reformatted so all the names fit on one line. The names should be in the following order: Chemical, Protein, Genetic and Karyotype. You should also add a search by name box with the same format and style as described earlier. The title for the 4th column should be “Condition Name”.  The structure for all DNA or Genetic biomarkers should just be a nice picture of DNA or the double helix.  The Conditions listed should indicate if the biomarker is Clinically approved or investigational (Kevin).  DONE
 
33) For the Predictive Biomarkers Table, the Filter by biomarker type needs to be reformatted so all the names fit on one line. The names should be in the following order: Chemical, Protein, Genetic and Karyotype. You should also add a search by name box with the same format and style as described earlier. The title for the 4th column should be “Condition Name”.  The structure for all DNA or Genetic biomarkers should just be a nice picture of DNA or the double helix.  The Conditions listed should indicate if the biomarker is Clinically approved or investigational. (Kevin). DONE
 
34) For the Exposure Biomarkers Table, the Filter by biomarker type needs to be reformatted so all the names fit on one line. The names should be in the following order: Chemical, Protein, Genetic and Karyotype. You should also add a search by name box with the same format and style as described earlier. The title for the 4th column should be “Condition Name”.  The structure for all DNA or Genetic biomarkers should just be a nice picture of DNA or the double helix.  The Conditions listed should indicate if the biomarker is Clinically approved or investigational (Kevin) DONE


39) All Karyotype descriptions should appear on the right hand side of the image (not spread out on top and bottom). Further they should begin with the name of the karyotype, a general description of the chromosomal event and a statement of what disease it is associated with, for example: “T(1;14)(p22;q32) is a translocation event involving chromosome 1 and chromosome 14. In particular, the segment from 1p22 to 1pter….  It is frequently found in Malt Lympohoma” (Kevin).


44) All chromosomal abnormality syndromes need to have the first letter in each word capitalized to be consistent with how we are naming all other diseases or syndromes. (Kevin).








# TO REMOVE CACHE

bundle exec rake tmp:cache:clear RAILS_ENV=production
bundle exec rake assets:clean RAILS_ENV=production


# TO Rebuild index
```
curl -XDELETE http://localhost:9200/markerdb_development_*
curl -XGET http://localhost:9200
```

```
curl -XGET http://10.128.10.77:9200/_aliases

curl -XDELETE http://10.128.10.77:9200/markerdb_*
```






































