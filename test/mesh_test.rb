require_relative 'test_helper'

module MESH
  describe 'Testing MESH:Mesh core functions' do

    it 'should yield to a block for each' do
      block_called = false
      MESH::Mesh.each do |h|
        block_called = true
        break
      end
      assert block_called
    end

    it 'should not have nil headings' do
      MESH::Mesh.each do |h|
        refute_nil h
      end
    end

    it 'should find by unique id' do
      mh = MESH::Mesh.find('D000001')
      refute_nil mh
    end

    it 'should find by tree number' do
      mh = MESH::Mesh.find_by_tree_number('G14.640.079')
      refute_nil mh
      assert_equal 'D000065', mh.unique_id
    end

    it 'should have the correct unique id' do
      mh = MESH::Mesh.find('D000001')
      assert_equal 'D000001', mh.unique_id
    end

    it 'should have the correct tree number' do
      mh = MESH::Mesh.find('D000001')
      assert_equal 1, mh.tree_numbers.length
      assert_includes mh.tree_numbers, 'D03.438.221.173'
    end

    it 'should have the correct tree numbers' do
      mh = MESH::Mesh.find('D000224')
      assert_equal 2, mh.tree_numbers.length
      assert_includes mh.tree_numbers, 'C19.053.500.263'
      assert_includes mh.tree_numbers, 'C20.111.163'
    end

    it 'should have the correct original heading' do
      mh = MESH::Mesh.find('D000224')
      assert_equal 'Addison Disease', mh.original_heading
      mh = MESH::Mesh.find('D000014')
      assert_equal 'Abnormalities, Drug-Induced', mh.original_heading
    end

    it 'should have anglicised original heading' do
      mh = MESH::Mesh.find('D001471')
      assert_equal 'Barrett Esophagus', mh.original_heading
      assert_equal 'Barrett Oesophagus', mh.original_heading('en-GB')
    end

    it 'should have natural language name' do
      mh = MESH::Mesh.find('D000224')
      assert_equal 'Addison Disease', mh.natural_language_name
      mh = MESH::Mesh.find('D000014')
      assert_equal 'Drug-Induced Abnormalities', mh.natural_language_name
    end

    it 'should have anglicised natural language name' do
      mh = MESH::Mesh.find('D001471')
      assert_equal 'Barrett Esophagus', mh.natural_language_name
      assert_equal 'Barrett Oesophagus', mh.natural_language_name('en-GB')
    end

    it 'should have the correct summary' do
      mh = MESH::Mesh.find('D000238')
      assert_equal 'A benign tumor of the anterior pituitary in which the cells do not stain with acidic or basic dyes.', mh.summary
    end

    it 'should have anglicised summary' do
      mh = MESH::Mesh.find('D001471')
      assert_equal 'A condition with damage to the lining of the lower ESOPHAGUS resulting from chronic acid reflux (ESOPHAGITIS, REFLUX). Through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the INTESTINE or the salmon-pink mucosa of the STOMACH. Barrett\'s columnar epithelium is a marker for severe reflux and precursor to ADENOCARCINOMA of the esophagus.', mh.summary
      assert_equal 'A condition with damage to the lining of the lower OESOPHAGUS resulting from chronic acid reflux (OESOPHAGITIS, REFLUX). Through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the INTESTINE or the salmon-pink mucosa of the STOMACH. Barrett\'s columnar epithelium is a marker for severe reflux and precursor to ADENOCARCINOMA of the oesophagus.', mh.summary('en-GB')
    end

    it 'should have the correct entries' do
      expected_entries = ['Activity Cycles', 'Ultradian Cycles', 'Activity Cycle', 'Cycle, Activity', 'Cycle, Ultradian', 'Cycles, Activity', 'Cycles, Ultradian', 'Ultradian Cycle']
      expected_entries.sort!
      mh = MESH::Mesh.find('D000204')
      assert_equal expected_entries, mh.entries
    end

    it 'should have anglicised entries' do
      expected_entries = ['Barrett Esophagus', 'Barrett Syndrome', 'Esophagus, Barrett', 'Barrett Epithelium', 'Barrett Metaplasia', 'Barrett\'s Esophagus', 'Barrett\'s Syndrome', 'Barretts Esophagus', 'Barretts Syndrome', 'Epithelium, Barrett', 'Esophagus, Barrett\'s', 'Syndrome, Barrett', 'Syndrome, Barrett\'s']
      expected_entries_en = ['Barrett Oesophagus', 'Barrett Syndrome', 'Oesophagus, Barrett', 'Barrett Epithelium', 'Barrett Metaplasia', 'Barrett\'s Oesophagus', 'Barrett\'s Syndrome', 'Barretts Oesophagus', 'Barretts Syndrome', 'Epithelium, Barrett', 'Oesophagus, Barrett\'s', 'Syndrome, Barrett', 'Syndrome, Barrett\'s']
      expected_entries.sort!
      expected_entries_en.sort!
      mh = MESH::Mesh.find('D001471')
      assert_equal expected_entries, mh.entries
      assert_equal expected_entries_en, mh.entries('en-GB')
    end

    it 'should have the correct parent' do
      mh = MESH::Mesh.find('D000001')
      assert_equal 1, mh.parents.length
      assert_equal 'D001583', mh.parents[0].unique_id
    end

    it 'should have the correct parents' do
      mh = MESH::Mesh.find('D000224')
      p1 = MESH::Mesh.find('D000309')
      p2 = MESH::Mesh.find('D001327')
      assert_equal 2, mh.parents.length
      assert_includes mh.parents, p1
      assert_includes mh.parents, p2
    end

    it 'should have the correct children' do
      parent = MESH::Mesh.find_by_tree_number('C19.053.500')
      child1 = MESH::Mesh.find_by_tree_number('C19.053.500.263')
      child2 = MESH::Mesh.find_by_tree_number('C19.053.500.270')
      child3 = MESH::Mesh.find_by_tree_number('C19.053.500.480')
      child4 = MESH::Mesh.find_by_tree_number('C19.053.500.740')

      assert_equal 4, parent.children.length
      assert_includes parent.children, child1
      assert_includes parent.children, child2
      assert_includes parent.children, child3
      assert_includes parent.children, child4
    end

    it 'should match on conditions for original_heading' do
      mh = MESH::Mesh.find('D001471')
      assert mh.matches(original_heading: /^Barrett Esophagus$/)
    end

    it 'should not match on incorrect condition for original_heading' do
      mh = MESH::Mesh.find('D001471')
      refute mh.matches(original_heading: /^Foo$/)
    end

    it 'should match on conditions for entries' do
      mh = MESH::Mesh.find('D001471')
      assert mh.matches(entries: /Metaplasia/)
    end

    it 'should not match on incorrect conditions for entries' do
      mh = MESH::Mesh.find('D001471')
      refute mh.matches(entries: /Foo/)
    end

    it 'should match on conditions for summary' do
      mh = MESH::Mesh.find('D001471')
      assert mh.matches(summary: /the lower ESOPHAGUS resulting from chronic acid reflux \(ESOPHAGITIS, REFLUX\)\./)
    end

    it 'should not match on incorrect conditions for summary' do
      mh = MESH::Mesh.find('D001471')
      refute mh.matches(summary: /Foo/)
    end

    it 'should match on conditions for useful' do
      mh = MESH::Mesh.find('D001471')
      begin
        mh.useful = true
        assert mh.matches(useful: true)
        refute mh.matches(useful: false)
        mh.useful = false
        assert mh.matches(useful: false)
        refute mh.matches(useful: true)
      ensure
        mh.useful = true
      end
    end

    it 'should match on multiple conditions' do
      mh = MESH::Mesh.find('D001471')
      assert mh.matches(original_heading: /^Barrett Esophagus$/, summary: /the lower ESOPHAGUS/)
    end

    it 'should not match on incorrect multiple conditions' do
      mh = MESH::Mesh.find('D001471')
      refute mh.matches(original_heading: /^Barrett Esophagus$/, summary: /Foo/)
      refute mh.matches(original_heading: /^Foo/, summary: /the lower ESOPHAGUS/)
    end

    it 'should match headings that occur in given text' do
      expected_ids = %w(D001491 D001769 D001792 D001842 D001853 D001853 D002470 D002477 D002477 D002648 D002648 D002875 D002965 D002999 D003062 D003561 D003593 D003643 D004194 D004314 D004314 D004314 D004314 D004813 D004912 D005091 D005123 D005123 D005293 D005333 D005385 D005385 D005544 D005796 D006128 D006225 D006309 D006321 D006331 D006664 D007107 D007223 D007231 D007231 D007231 D007239 D007246 D007938 D008099 D008168 D008214 D008214 D008423 D008533 D008533 D008607 D008722 D009035 D009055 D009132 D009154 D009154 D009190 D009196 D009369 D009666 D010372 D010641 D011153 D012008 D012106 D012146 D012306 D012307 D012380 D012680 D012867 D013534 D013577 D013601 D013812 D013921 D013961 D014034 D014157 D014171 D014314 D014960 D015032 D015994 D015995 D016424 D016433 D017584 D017668 D018387 D018388 D019021 D019070 D019368 D019369 D032882 D036801 D036801 D038042 D041905 D052016 D055016)
      expected = expected_ids.map { |id| MESH::Mesh.find(id) }
      actual = MESH::Mesh.match_in_text(@example_text)
      assert expected, actual
    end

    it 'should only match useful headings that occur in given text' do
      expected_ids = %w(D001491 D001769 D001792 D001842 D001853 D001853 D002470 D002477 D002648 D002648 D002875 D002965 D003062 D003561 D003593 D003643 D004194 D004314 D004314 D004314 D004314 D004813 D004912 D005091 D005123 D005123 D005293 D005333 D005385 D005385 D005544 D005796 D006128 D006225 D006309 D006321 D006331  D007107 D007231 D007231 D007231 D007239 D007938 D008099 D008168 D008214 D008214 D008423 D008533 D008607 D008722 D009035 D009055 D009132 D009154 D009154 D009190 D009196 D009369 D009666 D010372 D010641 D011153 D012008 D012106 D012146 D012306 D012307 D012380 D012680 D012867 D013534 D013577 D013601 D013812 D013921 D013961 D014034 D014157 D014171 D014314  D015032 D015994 D015995 D016424 D017584 D017668 D018387 D018388 D019021 D019070 D019368 D019369 D032882 D036801 D036801 D038042 D041905 D052016)

      not_useful_ids = %w(D007246 D002477 D014960 D008533 D016433 D006664 D055016 D002999 D007223)
      not_useful_ids.each { |id| MESH::Mesh.find(id).useful = false }

      expected = expected_ids.map { |id| MESH::Mesh.find(id) }
      actual = MESH::Mesh.match_in_text(@example_text)
      assert expected, actual
    end


    it 'should match headings at start of text' do
      text = 'Leukemia, lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec pretium leo diam, quis adipiscing purus bibendum eu.'
      matches = MESH::Mesh.match_in_text(text)
      assert_equal 1, matches.length
      assert_equal MESH::Mesh.find('D007938'), matches[0][:heading]
    end

    it 'should match headings at end of text' do
      text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec pretium leo diam, quis adipiscing purus bibendum eu leukemia'
      matches = MESH::Mesh.match_in_text(text)
      assert_equal 1, matches.length
      assert_equal MESH::Mesh.find('D007938'), matches[0][:heading]
    end

    it 'should allow headings to be marked as not useful' do
      mh = MESH::Mesh.find('D055550')
      mh.useful = true
      assert mh.useful
      mh.useful = false
      refute mh.useful
      mh.useful = true
      assert mh.useful
    end

    it 'should match on useful in where' do
      begin
        expected = [MESH::Mesh.find('D012000'), MESH::Mesh.find('D064906'), MESH::Mesh.find('D064966')]
        expected.each { |mh| mh.useful = false }
        actual = MESH::Mesh.where(useful: false)
        assert_equal expected, actual
      ensure
        expected.each { |mh| mh.useful = true }
      end
    end

    it 'should only include useful headings in .each' do
      begin
        MESH::Mesh.each do |mh|
          mh.useful = false
        end
        MESH::Mesh.where(unique_id: /^D0000/).each do |mh|
          mh.useful = true
        end
        count = 0
        MESH::Mesh.each do |mh|
          assert mh.useful
          count += 1
        end
        assert_equal 95, count
      ensure
        MESH::Mesh.where(useful: false).each do |mh|
          mh.useful = true
        end
      end
    end

    it 'should override inspect to prevent issues in test diagnostics' do
      mh = MESH::Mesh.find('D001471')
      expected = "#{mh.unique_id}, #{mh.original_heading}"
      assert_equal expected, mh.inspect
    end

    it 'should allow headings to be found with a where() match on original_heading' do
      expected = [MESH::Mesh.find('D003561'), MESH::Mesh.find('D016238')]
      actual = MESH::Mesh.where(original_heading: /^Cyta/)
      assert_equal expected, actual
    end
    #MESH::Mesh.where(:entries, /.*Fish.*/)

    before do

      @example_text = 'Leukaemia in Downs Syndrome
Overview
Downs Syndrome Leukaemia The link between Downs Syndrome and Leukaemia
Epidemiology
Aetiology
Future research Implications for other leukaemias Treatment
Downs Syndrome
Originally described in 1866
Associated with Trisomy 21 in 1959
Prevalence 1/1000 births
95% due to chromosomal non-disjunction; 5% due to translocations Risk factors:
increased maternal age
1/1000 maternal age 30 years
9/1000 maternal age 40 years
infertility treatment
Clinical Features
physical appearance
intellectual disability
developmental delay
sensory abnormalities congenital heart disease
Alzheimers Disease
GI malformations
thyroid disorders
poor immune system
LEUKAEMIA
Downs Syndrome
Leukaemia
cancer
WBC proliferation in the bone marrow
Classification:
acute/chronic
type of WBC
Current leukaemia model:
2 co-operating mutations
1 leading to impaired differentiation
1 leading to increased proliferation/cell survival
Picture: Hitzler & Zipursky, 2005
Leukaemia
Acute lymphoblastic leukaemia (ALL)
derived from B lymphocyte or T lymphocyte precursors
80% childhood leukaemia
Acute myeloid leukaemia (AML)
e.g. myeloid, monocytic, megakaryocytic, erythroid
20% childhood leukaemia
Acute megakaryoblastic leukaemia (AMKL)
AML subtype: leukaemic cells have platelet precursor phenotype
6% childhood AML cases
Leukaemia in Downs Syndrome
10-20 fold increased risk of leukaemia
ALL
80% childhood leukaemia; 60% Downs Syndrome leukaemia
20 times higher incidence children with Downs Syndrome compared to children without Downs Syndrome AML
20% childhood leukaemia; 40% Downs Syndrome leukaemia AMKL
6% childhood AML; 62% Downs Syndrome AML
500 times higher incidence children with Downs Syndrome compared to children without Downs Syndrome
Leukaemia in Downs Syndrome
AML in Downs Syndrome
AMKL in most cases
younger median age of onset
2 in Downs Syndrome
8 in non-Downs Syndrome
myelodysplastic syndrome more common prior to leukaemia
Transient Leukaemia
Transient Leukaemia
Also termed: Transient Abnormal Myelopoiesis and Transient Myeloproliferative Disorder
10% newborn infants with Downs Syndrome
peripheral blood contains clonal population of megakaryoblasts
cannot be distinguished from AMKL blasts by routine methods
usually clinically silent
usually disappear within 3 months
majority of cases totally resolve
However
can be fatal
20% develop MDS and AMKL by the age of 4 yearsTransient Leukaemia
Leukaemic cells in Transient Leukaemia and AMKL can:
show variable megakaryocytic differentiation
show features of multiple haematopoietic lineages Evidence that Transient Leukaemia is a precursor for AMKL
near identical morphology, immunophenotype, ultrastructure
clone-specific GATA1 mutations
GATA1: X chromosome, zinc-finger transcription factor, essential for differentiation of megakaryocytic, erythroid and basophillic lineages
therefore have common cell of originLeukaemic cells in Transient Leukaemia and AMKL in Downs Syndrome can form megakaryocytic, erythroid or basophillic lineages
GATA1
all Transient Leukaemia and AMKL cases have GATA1 mutations
most abrogate splicing of exon 2 or produce stop codon prior to alternative start codon at position 84
lack N-terminal domain
mutations disappear upon remission
disease specific mutations
leukemogenisis model: transcription factor mutation blocks differentiation
GATA1 mutation determines haematopoietic lineage
GATA1 mutations present in Transient Leukaemia at birth
mutations in utero
proportion of Downs Syndrome fetuses acquire GATA1 mutation
large clone = Transient Leukaemia
small clone = no clinical signs
Aetiology
Three distinct steps:
fetal heamatopoietic cell with trisomy 21
rare Transient Leukaemia cases in people without Downs syndrome
acquired trisomy 21 only in haematopoietic cells
mutation of GATA1
expression of shortened
GATA1 (GATA1s) extra, as of yet unknown event
not all cases of Transient
Leukaemia progress to AMKL
Picture: Hitzler & Zipursky, 2005
Aetiology
Transient Leukaemia with clinical signs of disease
Transient Leukaemia with no clinical signs of diseasePicture: Ahmed et al, 2004
Future Research
Loss of GATA1 function in people without Downs Syndrome results in:
accumulation of abnormally differentiated megakaryocytes
thrombocytopenia
NO LEUKAEMIC TRANSFORMATION
discovered by Shivdasani et al, 1997
What is the effect of Trisomy 21
What advantage does GATA1 mutation provide to people with Downs SyndromeWhat is the second-hitImplications for other leukaemias
current acute leukaemia model:
2 co-operating mutations
1 leading to impaired differentiation
1 leading to increased proliferation/cell survival
This means that that the sequence of Transient Leukaemia to AMKL as seen in Downs Syndrome is a chance to investigate this model of leukaemia and discover the timing and nature of the 2 necessary events.
Treatment of Leukaemia in Downs Syndrome
AML (AMKL)
increased sensitivity to cytarabine
80% 5 year survival
failure usually due to toxicity (mucositis and infection)ALL
similar treatment as in AML
60-70% cure rate (75-85% in population without Downs Syndrome)
no increased sensitivity, but increased toxicity
dose reduction would increase risk of relapse
supportive care
References
Ahmed, M., Sternberg, A., Hall, G., Thomas, A., Smith, O., OMarcaigh, A., Wynn, R., Stevens, R., Addison, M., King, D., Stewart, B., Gibson, B., Roberts, I., Vyas, P. (2004). Natural History of GATA1 mutations in Down syndrome, Blood, 103(7):2480-2489.
Hitzler, J.K., Cheung, J., Li, Y., Scherer, S.W., Zipursky, A. (2003). GATA1 mutations in transient leukaemia and acute megakaryoblastic leukaemia of Down syndrome, Blood, 101(11):4301-4304.
Hitzler, J.K., Zipursky, A. (2005). Origins of leukaemia in children with down syndrome, Cancer, 5:11-20.
Puumala, S.E., Ross, J.A., Olshan, A.F., Robison, L.L., Smith, F.O., Spector, L.G. (2007). Reproductive history, infertility treatment, and the risk of acute leukaemia in children with down syndrome, Cancer, [Epub ahead of print].
Shivdasani, R.A., Fujiwara, Y., McDevitt, M.A., Orkin, S.H. (1997). A loneage-selective knockout establishes the critical role of transcription factor GATA-1 in megakaryocyte growth and platelet development, Embo J., 16:3965-3973.
Slordahl, S.H. et al. (1993). Leukaemic blasts with markers of four cell lineages in Down\'s syndrome (megakaryoblastic leukaemia), Med. Pediatr. Oncol., 21:254-258.
Vyas, P., Crispino, J.D. (2007). Molecular insights into Down syndrome-associated leukemia, Current Opinion in Pediatrics, 19:9-14.
Webb, D., Roberts, I., Vyas, P. (2007). Haematology of Down syndrome, Arch. Dis. Child. Fetal Neonatal Ed., [published online 5 Sep 2007].
http://www.intellectualdisability.info/home.htm
http://news.bbc.co.uk/nol/shared/spl/hi/pop_ups/05/health_shifting_perspectives/img/1.jpg
Originally described by John Langdon Down
Associated with Trisomy 21 by Professor Jerome Lejeune
Overall incidence is 1/1000, so 600 babies with Downs syndrome are born in the UK each year
It is estimated that there are 60,000 people living with Downs syndrome in the UK
80% of children with Downs Syndrome are born to mothers under 35 years of age
Research suggests that infertility treatment increases risk of chromosomal abnormalitiesFacial appearance: flat profile, flat nasal bridge, small nose, eyes that slant upwards and outwards often with an epicanthic fold a fold of skin that runs vertically between the lids at the inner corner of the eye), small mouth.
Body appearance: reduced muscle tone, big space between first and second toe, broad hands with short fingers and a little finger that curves inwards, often a single palmar crease.
Sensory abnormalities: visual and hearing
Congenital Heart Disease is present in 50% of people with Downs SyndromeThere are two methods of classifying leukaemias: acute/chronic or according to the type of WBC that is proliferating abnormally ALL describes leukaemia where the cancerous cell is derived from precursors of B or less commonly T lymphocytes.  ALL makes up 80% of all childhood leukaemias.
AML describes leukaemia where the cancerous cell is not B or T cell derived and the subtype is determined by the phenotype of the leukaemic cells.  AML makes up 20% of childhood leukaemias.
AMKL is a subtype of AML where the leukaemic cell looks like platelet precursors.  AMKL makes up 6% of childhood AML cases.ALL makes up 80% of childhood leukaemia, but 60% of leukaemia in children with DS.  Children with DS have a 20 fold increased risk of developing ALL when compared to children without DS.
AML makes up 20% of childhood leukaemia, but 40% of leukaemia in children with DS.
AMKL makes up 6% of childhood AML, but in children with Downs Syndrome makes up 62% of AML cases.  Children with DS have a 500 fold increased risk of developing AMKL when compared to children without DS.The rest of this talk is going to focus on AMKL in DS.  The majority of AML cases in DS are AMKL and have a younger age of onset than in the population without DS.  AMKL in DS much more commonly begins as a MDS.  This is a process of abnormal megakaryocytic differentiation.  Furthermore, children with DS are at risk of Transient Leukaemia  a condition that is almost exclusive to children with DS.Tranisent leukaemia is only found in infants with DS and is found in about 10% of newborns with DS.  These children are born with a clonal population of megakaryoblasts in their blood.  These megakaryoblasts cannot be distinguished from the blasts of AMKL by routine methods and usually spontaneously disappear within the first 3 months of life.
TL begins in utero and usually does not cause any symptoms.  The majority of cases resolve and the children do not have any lasting haematological problems.  There is no evidence as to how TL spontaneously resolves.  However, it can also be fatal due liver damage or complications in the lungs or heart and 20% of children with TL proceed to develop MDS and AMKL by the age of 4 years.mutations of GATA1 are present in the cells of TL and AMKL in Downs Syndrome and these cells can become megakaryocytes, erythroid cells or basophils!  The megakaryoctic lineage is particularly dependant on the level of expression of GATA1.
MULTIPLE HAEMATOPOIETIC LINEAGES: for example precursor cells of erythrocytes and basophils.  Ferritin is found in the cytoplasm of DS-AMKL cells.
This slide equates the aeitology to the model of leukaemia I mentioned earlier, with points 2 and 3 being the 2 mutations.
2) It is currently not known if it is the absence of normal GATA1 or the presence of GATA1s that causes leukaemic proliferation of megakaryocytes.  It could be both, because GATA1s fails to suppress some pro-proliferative genes such as GATA2 and MYC)  although these are pro-proliferative for erythrocytes.The previous slide shows us how a child with DS can progress to developing AMKL.  Of course we know that not all children with DS or indeed all children with DS and Transient Leukaemia proceed to develop AMKL.  This slide shows us all the possible routes children with DS can take.
Normal
GATA1s  small clone or large clone
clonal extinction  normal
clonal expansion plus additional genetic event  AMKL
AMKL  death or remission (normal)Although our understanding of leukaemia in DS have progressed a long way over recent years, there still remain unknowns in the aetiology.
Loss of GATA1 function has different effect on people without DS and people with DS  therefore what is the effect of Trisomy 21
why are GATA1 mutations so relatively common in children with DS  It has been postulated that there may be some selective advantage, but it is only a hypothesis.
thirdly, what is the second-hit  We know that there must be a second genetic event, with GATA1 mutation being the first, but we do not know what this is yet.NB: GATA1 mutation is the first mutation for DS-AMKL.AML  failure of treatment usually due to toxicity due to mucositis and infection.  Resistant disease and relapse are rare.
ALL  there is no increased sensitivity to treatment, but there is increased risk of toxicity.  Cannot reduce the dose because of the high risk of relapse and so the emphasis is now on improving supportive care.
'

    end


  end
end