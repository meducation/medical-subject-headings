require_relative 'test_helper'
require 'MESH/translator'

module MESH
  describe 'Testing MESH:Translator core functions' do

    it 'should translate a single word' do
      tr = MESH::Translator.new
      assert_equal 'oesophagus', tr.translate('esophagus')
      assert_equal 'aluminium', tr.translate('aluminum')
      assert_equal 'gynaecology', tr.translate('gynecology')
    end

    it 'should translate within a body of text' do
      tr = MESH::Translator.new
      input = 'a condition with damage to the lining of the lower esophagus resulting from chronic acid reflux (esophagitis, reflux). through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the intestine or the salmon-pink mucosa of the stomach. barrett\'s columnar epithelium is a marker for severe reflux and precursor to adenocarcinoma of the esophagus.'
      expected = 'a condition with damage to the lining of the lower oesophagus resulting from chronic acid reflux (oesophagitis, reflux). through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the intestine or the salmon-pink mucosa of the stomach. barrett\'s columnar epithelium is a marker for severe reflux and precursor to adenocarcinoma of the oesophagus.'

      assert_equal expected, tr.translate(input)
    end

    it 'should maintain capitalization' do
      skip
    end

  end
end