require_relative 'test_helper'

module MESH
  describe 'Testing MESH:Mesh core functions' do

    before do
      start = Time.now
      MESH::Mesh.configure(filename: File.expand_path('../../data/mesh_data_2014/d2014.bin.gz', __FILE__))
      finish = Time.now
      configuration_time = finish - start
      assert configuration_time < 10
    end

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

    it 'should match headings that occur in given text' do
      assert false
    end

  end
end