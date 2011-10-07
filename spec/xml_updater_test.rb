require "test/unit"
require "xml_updater"
class XmlUpdaterTest < Test::Unit::TestCase
  def test_parse_xml
    xml_updater = XmlUpdater.new '/home/joe/code/3DPosModel/Heidrun/dataset.sct.xml'
    assert_equal('document', xml_updater.xml_document.name)
  end
  
  def test_get_element
    xml_updater = XmlUpdater.new '/home/joe/code/3DPosModel/Heidrun/dataset.sct.xml'
    assert_equal('Seabed', xml_updater.get_element('//dataset/seabedhorizonid').content)
  end
end