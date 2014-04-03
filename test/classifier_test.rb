require_relative 'test_helper'

module MESH

  class ClassiferTest < Minitest::Test

    def test_it_should_classify_title
      c = MESH::Classifier.new()
      expected = {'A' => MESH::Mesh.find('D005542'), 'H' => MESH::Mesh.find('D000715')}
      assert_equal expected, c.classify(title: 'Posterior forearm muscular anatomy')
      expected = {'H' => MESH::Mesh.find('D002309')}
      assert_equal expected.sort, c.classify(title: 'Cardiology in a Heartbeat').sort
    end

    def test_it_should_classify_poor_abstract
      abstract = 'This is a guide to performing a cardiovascular examination in the context of an OSCE exam. It was created by a group of medical students for the free revision website www.geekymedics.com where you can find a written guide to accompany the video. The way in which this examination is carried out varies greatly between individuals & institutions therefore this should be used as a rough framework which you can personalise to suit your own style.'

      c = MESH::Classifier.new()
      expected = {'I' => MESH::Mesh.find('D013337'), 'M' => MESH::Mesh.find('D013337')}
      assert_equal expected.sort, c.classify(abstract: abstract).sort
    end

    def test_it_should_classify_good_abstract
      abstract = 'The “Arterial Schematic” represents the intricate three-dimensional human arterial system in a highly simplified two-dimensional design reminiscent of the London Underground Map. Each “line” represents an artery within the body; a black circle marks a major vessel, whilst “stubs” stemming from the main lines represent the distal vasculature. The coloured “zones” represent the main divisions of the human body, for example; the yellow zone indicates the neck. The schematic was inspired by Henry Beck’s work on the first diagrammatic London Underground Map. His aim was to represent complex geographical distribution in a simple and accessible form. He achieved this aim by omitting swathes of information that had plagued previous designers’ versions. Beck’s approach was succinct yet produced a design that was immediately successful in clearly portraying to commuters how to traverse London most efficiently. The “Arterial Schematic” hopes to culminate this idea of communicating complex concepts in a concise manner, mirroring what is expected of medical professionals on a daily basis. The schematic is a prototype design intended to be part of a series of images that will diagrammatically represent the various systems of the human body. The prototype was inspired by a desire to teach anatomy via a fresh and engaging visual medium. Recent years have seen significant debate over reduced undergraduate anatomy teaching and its later consequences. The hope is that the “Arterial Schematic” and its sister diagrams will inspire students to learn anatomy and encourage them to further their knowledge via other sources. PLEASE NOTE: This image is available for purchase in print, please contact l.farmery1@gmail.com if interested. Please follow LFarmery on Twitter and considering sharing the Arterial Schematic on Facebook etc. Many Thanks.'

      c = MESH::Classifier.new()
      expected = {
        'A' => MESH::Mesh.find('D001158'),
        'B' => MESH::Mesh.find('D006801'),
        'F' => MESH::Mesh.find('D014836'),
        'H' => MESH::Mesh.find('D000715'),
        'I' => MESH::Mesh.find('D018594'),
        'K' => MESH::Mesh.find('D018594'),
        'L' => MESH::Mesh.find('D019359'),
        'M' => MESH::Mesh.find('D035781'),
        'Z' => MESH::Mesh.find('D008131')
      }
      assert_equal expected.sort, c.classify(abstract: abstract).sort
    end

    def test_it_should_classify_content
      c = MESH::Classifier.new()
      expected = {
        'A' => MESH::Mesh.find('D001829'),
        'B' => MESH::Mesh.find('D027861'),
        'C' => MESH::Mesh.find('D000163'),
        'D' => MESH::Mesh.find('D007854'),
        'E' => MESH::Mesh.find('D004562'),
        'F' => MESH::Mesh.find('D011579'),
        'G' => MESH::Mesh.find('D055585'),
        'I' => MESH::Mesh.find('D014937'),
        'K' => MESH::Mesh.find('D019368'),
        'L' => MESH::Mesh.find('D009275'),
        'M' => MESH::Mesh.find('D010361'),
        'N' => MESH::Mesh.find('D014919'),
        'V' => MESH::Mesh.find('D017203'),
        'Z' => MESH::Mesh.find('D014481')
      }

      assert_equal expected.sort, c.classify(content: @texts[0]).sort
    end

    def test_it_should_classify_other_content_as_well
      c = MESH::Classifier.new()
      expected = {
        'A' => MESH::Mesh.find('D004064'),
        'D' => MESH::Mesh.find('D002241'),
        'F' => MESH::Mesh.find('D005190'),
        'G' => MESH::Mesh.find('D012621'),
        'I' => MESH::Mesh.find('D005190'),
        'J' => MESH::Mesh.find('D008420'),
        'L' => MESH::Mesh.find('D005246'),
        'N' => MESH::Mesh.find('D012621')
      }

      assert_equal expected.sort, c.classify(content: @texts[1]).sort
    end

    def test_it_should_classify_title_abstract_and_content
      c = MESH::Classifier.new()

      doc = {
        title: 'Rotation',
        abstract: 'Oxygen',
        content: 'Nose'
      }

      expected = {
        'G' => MESH::Mesh.find('D012399'),
        'D' => MESH::Mesh.find('D010100'),
        'A' => MESH::Mesh.find('D009666')
      }

      assert_equal expected.sort, c.classify(doc).sort

    end

    def test_uses_given_clarifier
      skip
    end

    def setup
      @texts = [
        'hi in this tutorial I\'m you talk about electrocardiography so we\'ll be looking at the first principles open electrocardiogram more commonly known as an the CD or an ekgs in the United States there\'s a fairly the information in this tutorial but I\'ll try make it as simple as possible the first people were gonna look at where you attached leave them a CG machine to a patient crucible there are four leaves which are attached to the limbs the patient these are abbreviated LA left arm are a a ride home L the left leg and are I\'ll right leg there are also six leaves which we attach to the chest the patient these called chest leads missed the point of confusion for many people went first learning the PCG their these 10 leads which we\'ve attached to the patient but this is not what we mean when we talk about EC jail aids and EC Jade lead is an mathematically determined recording which is made up from a combination of these physically that are attached to the patient so from here on in when I talk about and a CG laid I\'m going to be talking about these mathematically determined recordings you don\'t need to know how these lead the calculated just know they\'re not the same thing as the lead attached to the patient so in a 12 lead the CJ which is the standard PCG they are 12 they\'d leave and each lead shows the heart from a different view so if I drop a heart like this and we\'re looking at it from me anterior aspect we can thinking these leads as little lies the h3 the heart from a different angle so there are 60 these eyes look at the heart in a corona plane and they look at the heart in the directions are shown here each of these leaves has a name this is laid one this is lead to this is lead gray and the other thing called abe et al I V on and a bf this stands for augmented Victor left right and Fort the chest leads look at the heart in a transverse plane so again these work like little eyes that each look at the heart from a different angle these are labeled much more simply they called v1 v2 b3 be full be polite and basics and that\'s the front and the back the two author now let\'s have a think about the limb leads again if I drop a diagram a the lead directions without the hard we get an image that looks like this if we extend these lines that in the opposite direction to which they point we will see that we have every direction coveted in 30 degree increments now would be a good time to talk about what I mean by looking at the heart the EC G carb see the heart in the wind x-ray came it sees it electrically that is to say it sees whether there is electrical deep polarization all repolarization occurring in the direction of peach laid if you don\'t know what I mean by D polarized nation and repolarization I\'m talking about the flow of cardiac action potentials through the heart you can check out the action potential series at WWW dot hand written tutorials dot com for more information so let me explain this a little further I\'m you draw up a hot here and we\'re gonna look at recordings the taken from lead to lead 3 and aber and we\'re going to look at the polarized nation which is occurring in this direction so any deep polarization that occurs in the direction of the lead cause away from the graph which is positive in nature that is and up with deflection so because lead to is roughly the same direction as the deep polarization the wave on the graph will look like this because lead 3 is perpendicular to the direction the polarization there will be no change in the graph and finally because aber is in the direction opposite to the direction people organization there\'s an inverted way or damn would deflection and that\'s an interview the first principles been a CG in the next tutorial will be looking at the normal patton Albany CG during the cardiac cycle for more free tutorials and the PDF this tutorial visit WWW dot hand written tutorials dot com',

        'diabetes drug families suck my big NO inhibited gray Taurus suck my big a new inhibiting Glee Taurus so finally arias tells the pancreas you need to release more insulin so fun mines are antibiotics medics mimic natural hormones like interest in Emelin that have similar functions to insulin big one-eyed decreases the liver from making more glucose the liver is a big organ analogues have gone make peptide-1 hookah gone a comedian the increases blood sugar by releasing starch sugar in be eventually lowers blood sugar the feedback stimulate insulin release a great drug would be like glue guns eventual function be but not do function hey that drug is a GOP won analog inhibitors about the glucoside ace glucoside a season enzyme that cuts big sugars into small sugars that food in your blood it\'s the small sugars that cause problems if you give it a glucoside et sans I\'m you have less to be small problem causing sugars good his own perfect DNA use see less insulin resistant magical glitter changes your DNA per superpowers help it go help hippocampus in'
      ]
    end

  end

end