require_relative 'test_helper'
require 'MESH/translator'

module MESH
  describe 'Testing MESH:Translator core functions' do

    it 'should translate a single word' do
      tr = MESH::Translator.new(MESH::Translator.enus_to_engb)
      assert_equal 'oesophagus', tr.translate('esophagus')
      assert_equal 'aluminium', tr.translate('aluminum')
      assert_equal 'gynaecology', tr.translate('gynecology')
      tr = MESH::Translator.new(MESH::Translator.engb_to_enus)
      assert_equal 'esophagus', tr.translate('oesophagus')
      assert_equal 'aluminum', tr.translate('aluminium')
      assert_equal 'gynecology', tr.translate('gynaecology')
    end

    it 'should translate within a body of text' do
      tr = MESH::Translator.new(MESH::Translator.enus_to_engb)
      input = 'a condition with damage to the lining of the lower esophagus resulting from chronic acid reflux (esophagitis, reflux). through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the intestine or the salmon-pink mucosa of the stomach. barrett\'s columnar epithelium is a marker for severe reflux and precursor to adenocarcinoma of the esophagus.'
      expected = 'a condition with damage to the lining of the lower oesophagus resulting from chronic acid reflux (oesophagitis, reflux). through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the intestine or the salmon-pink mucosa of the stomach. barrett\'s columnar epithelium is a marker for severe reflux and precursor to adenocarcinoma of the oesophagus.'

      assert_equal expected, tr.translate(input)
    end

    it 'should match uppercase' do
      tr = MESH::Translator.new(MESH::Translator.enus_to_engb)
      input = 'A condition with damage to the lining of the lower ESOPHAGUS resulting from chronic acid reflux (ESOPHAGITIS, REFLUX). Through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the INTESTINE or the salmon-pink mucosa of the STOMACH. Barrett\'s columnar epithelium is a marker for severe reflux and precursor to ADENOCARCINOMA of the esophagus.'
      expected = 'A condition with damage to the lining of the lower OESOPHAGUS resulting from chronic acid reflux (OESOPHAGITIS, REFLUX). Through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the INTESTINE or the salmon-pink mucosa of the STOMACH. Barrett\'s columnar epithelium is a marker for severe reflux and precursor to ADENOCARCINOMA of the oesophagus.'
      assert_equal expected, tr.translate(input)
    end

    it 'should match title case' do
      tr = MESH::Translator.new(MESH::Translator.enus_to_engb)
      input = 'A condition with damage to the lining of the lower Esophagus resulting from chronic acid reflux (Esophagitis, REFLUX). Through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the INTESTINE or the salmon-pink mucosa of the STOMACH. Barrett\'s columnar epithelium is a marker for severe reflux and precursor to ADENOCARCINOMA of the esophagus.'
      expected = 'A condition with damage to the lining of the lower Oesophagus resulting from chronic acid reflux (Oesophagitis, REFLUX). Through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the INTESTINE or the salmon-pink mucosa of the STOMACH. Barrett\'s columnar epithelium is a marker for severe reflux and precursor to ADENOCARCINOMA of the oesophagus.'
      assert_equal expected, tr.translate(input)
    end

    it 'should not change the input string' do
      tr = MESH::Translator.new(MESH::Translator.enus_to_engb)
      input = 'esophagus'
      assert_equal 'oesophagus', tr.translate(input)
      assert_equal 'esophagus', input
    end

    it 'should maintain punctuation' do
      tr = MESH::Translator.new(MESH::Translator.enus_to_engb)
      input = 'Esophagus, Barrett'
      assert_equal 'Oesophagus, Barrett', tr.translate(input)
    end

  end
end


