require 'spec_helper'

describe MeshHeadingGraph do

  it 'should throw if configured without a filename' do
    expect { MeshHeadingGraph.configure({}) }.to raise_error(RuntimeError, 'MeshHeadingGraph requires a filename in order to configure itself')
  end

  it 'should throw if not configured' do
    expect { MeshHeadingGraph.find('D000001') }.to raise_error(RuntimeError, 'MeshHeadingGraph.configure must be called before use')
  end

  it 'should configure in less than 10s' do
    start = Time.now
    MeshHeadingGraph.configure(filename: Rails.root.join('mesh_data_2014', 'd2014.bin'))
    finish = Time.now
    configuration_time = finish - start
    configuration_time.should be < 10
  end

  it 'should yield to a block for each' do
    block_called = false
    MeshHeadingGraph.each do |h|
      block_called = true
      break
    end
    assert block_called
  end

  it 'should not have nil headings' do
    MeshHeadingGraph.each do |h|
      assert_not_nil h
    end
  end

  it 'should not throw once configured' do
    #Relies on sequential test execution :(
    expect { MeshHeadingGraph.find('D000001') }.to_not raise_error
  end

  it 'should find by unique id' do
    mh = MeshHeadingGraph.find('D000001')
    mh.should_not be_nil
  end

  it 'should find by tree number' do
    mh = MeshHeadingGraph.find_by_tree_number('G14.640.079')
    mh.should_not be_nil
    mh.unique_id.should == 'D000065'
  end

  it 'should have the correct unique id' do
    mh = MeshHeadingGraph.find('D000001')
    mh.unique_id.should == 'D000001'
  end

  it 'should have the correct tree number' do
    mh = MeshHeadingGraph.find('D000001')
    mh.tree_numbers.should have(1).items
    mh.tree_numbers.should include 'D03.438.221.173'
  end

  it 'should have the correct tree numbers' do
    mh = MeshHeadingGraph.find('D000224')
    mh.tree_numbers.should have(2).items
    mh.tree_numbers.should include 'C19.053.500.263'
    mh.tree_numbers.should include 'C20.111.163'
  end

  it 'should have the correct original heading' do
    mh = MeshHeadingGraph.find('D000224')
    mh.original_heading.should == 'Addison Disease'
    mh = MeshHeadingGraph.find('D000014')
    mh.original_heading.should == 'Abnormalities, Drug-Induced'
  end

  it 'should have anglicised original heading' do
    mh = MeshHeadingGraph.find('D001471')
    mh.original_heading.should == 'Barrett Esophagus'
    mh.original_heading('en-GB').should == 'Barrett Oesophagus'
  end

  it 'should have natural language name' do
    mh = MeshHeadingGraph.find('D000224')
    mh.natural_language_name.should == 'Addison Disease'
    mh = MeshHeadingGraph.find('D000014')
    mh.natural_language_name.should == 'Drug-Induced Abnormalities'
  end

  it 'should have anglicised natural language name' do
    mh = MeshHeadingGraph.find('D001471')
    mh.natural_language_name.should == 'Barrett Esophagus'
    mh.natural_language_name('en-GB').should == 'Barrett Oesophagus'
  end

  it 'should have the correct summary' do
    mh = MeshHeadingGraph.find('D000238')
    mh.summary.should == 'A benign tumor of the anterior pituitary in which the cells do not stain with acidic or basic dyes.'
  end

  it 'should have anglicised summary' do
    mh = MeshHeadingGraph.find('D001471')
    mh.summary.should == 'A condition with damage to the lining of the lower ESOPHAGUS resulting from chronic acid reflux (ESOPHAGITIS, REFLUX). Through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the INTESTINE or the salmon-pink mucosa of the STOMACH. Barrett\'s columnar epithelium is a marker for severe reflux and precursor to ADENOCARCINOMA of the esophagus.'
    mh.summary('en-GB').should == 'A condition with damage to the lining of the lower OESOPHAGUS resulting from chronic acid reflux (OESOPHAGITIS, REFLUX). Through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the INTESTINE or the salmon-pink mucosa of the STOMACH. Barrett\'s columnar epithelium is a marker for severe reflux and precursor to ADENOCARCINOMA of the oesophagus.'
  end

  it 'should have the correct entries' do
    expected_entries = ['Activity Cycles', 'Ultradian Cycles', 'Activity Cycle', 'Cycle, Activity', 'Cycle, Ultradian', 'Cycles, Activity', 'Cycles, Ultradian', 'Ultradian Cycle']
    expected_entries.sort!
    mh = MeshHeadingGraph.find('D000204')
    assert_equal expected_entries, mh.entries
  end

  it 'should have anglicised entries' do
    expected_entries = ['Barrett Esophagus', 'Barrett Syndrome', 'Esophagus, Barrett', 'Barrett Epithelium', 'Barrett Metaplasia', 'Barrett\'s Esophagus', 'Barrett\'s Syndrome', 'Barretts Esophagus', 'Barretts Syndrome', 'Epithelium, Barrett', 'Esophagus, Barrett\'s', 'Syndrome, Barrett', 'Syndrome, Barrett\'s']
    expected_entries_en = ['Barrett Oesophagus', 'Barrett Syndrome', 'Oesophagus, Barrett', 'Barrett Epithelium', 'Barrett Metaplasia', 'Barrett\'s Oesophagus', 'Barrett\'s Syndrome', 'Barretts Oesophagus', 'Barretts Syndrome', 'Epithelium, Barrett', 'Oesophagus, Barrett\'s', 'Syndrome, Barrett', 'Syndrome, Barrett\'s']
    expected_entries.sort!
    mh = MeshHeadingGraph.find('D001471')
    assert_equal expected_entries, mh.entries
    assert_equal expected_entries, mh.entries('en-GB')
  end

  it 'should have the correct parent' do
    mh = MeshHeadingGraph.find('D000001')
    mh.parents.should have(1).items
    mh.parents[0].unique_id.should == 'D001583'
  end

  it 'should have the correct parents' do
    mh = MeshHeadingGraph.find('D000224')
    p1 = MeshHeadingGraph.find('D000309')
    p2 = MeshHeadingGraph.find('D001327')
    mh.parents.should have(2).items
    mh.parents.should include p1
    mh.parents.should include p2
  end

  it 'should have the correct children' do
    parent = MeshHeadingGraph.find_by_tree_number('C19.053.500')
    child1 = MeshHeadingGraph.find_by_tree_number('C19.053.500.263')
    child2 = MeshHeadingGraph.find_by_tree_number('C19.053.500.270')
    child3 = MeshHeadingGraph.find_by_tree_number('C19.053.500.480')
    child4 = MeshHeadingGraph.find_by_tree_number('C19.053.500.740')

    parent.children.should have(4).items
    parent.children.should include child1
    parent.children.should include child2
    parent.children.should include child3
    parent.children.should include child4
  end

end