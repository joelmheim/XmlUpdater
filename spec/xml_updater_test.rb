require "test/unit"
require "xml_updater"

class XmlUpdaterTest < Test::Unit::TestCase
  def test_parse_xml_file
    xml_updater = XmlUpdater.new 'spec/test.xml'
    assert_equal('document', xml_updater.xml_document.name)
  end
  
  def test_parse_xml_string
    xml_updater = XmlUpdater.new "<?xml version=\"1.0\"?>\n<root><horizons><item><id>1</id></item></horizons></root>"
    assert_equal('document', xml_updater.xml_document.name)
  end
  
  def test_get_element
    xml_updater = XmlUpdater.new "<?xml version=\"1.0\"?>\n<root><horizons><item><id>1</id></item></horizons></root>"
    assert_equal('1', xml_updater.get_element('//horizons/item/id').content)
  end
  
  def test_update_date_format
    expected_xml = "<?xml version=\"1.0\"?>
<root>
  <dates>
    <item>
      <date>2010-11-01 00:00:00</date>
    </item>
    <item>
      <date>2010-11-01 00:00:00</date>
    </item>
    <item>
      <date>2010-11-01 00:00:00</date>
    </item>
  </dates>
</root>\n"
    actual_xml = "<?xml version=\"1.0\"?>
<root>
  <dates>
    <item>
      <date>2010-11-01</date>
    </item>
    <item>
      <date>2010-11-01</date>
    </item>
    <item>
      <date>2010-11-01</date>
    </item>
  </dates>
</root>"
    xml_updater = XmlUpdater.new actual_xml
    xml_updater.update_date_format('//dates/item/date', '%Y-%m-%d %H:%M:%S')
    assert_equal(expected_xml, xml_updater.to_xml)
  end
  
  def test_update_date_format_with_time
    expected_xml = "<?xml version=\"1.0\"?>
<root>
  <dates>
    <item>
      <date>2009-11-06 22:05:55</date>
    </item>
    <item>
      <date>2009-11-06 13:04:55</date>
    </item>
    <item>
      <date>2009-11-06 11:04:55</date>
    </item>
  </dates>
</root>\n"
    actual_xml = "<?xml version=\"1.0\"?>
<root>
  <dates>
    <item>
      <date>Fri Nov 06 22:05:55 CET 2009</date>
    </item>
    <item>
      <date>Fri Nov 06 13:04:55 CET 2009</date>
    </item>
    <item>
      <date>Fri Nov 06 11:04:55 CET 2009</date>
    </item>
  </dates>
</root>"
    xml_updater = XmlUpdater.new actual_xml
    xml_updater.update_date_format('//dates/item/date', '%Y-%m-%d %H:%M:%S')
    assert_equal(expected_xml, xml_updater.to_xml)
  end
  
  def test_update_date_format_with_empty_date_elements
    expected_xml = "<?xml version=\"1.0\"?>
<root>
  <dates>
    <item>
      <date/>
    </item>
    <item>
      <date>2009-11-06 13:04:55</date>
    </item>
    <item>
      <date/>
    </item>
  </dates>
</root>\n"
    actual_xml = "<?xml version=\"1.0\"?>
<root>
  <dates>
    <item>
      <date/>
    </item>
    <item>
      <date>Fri Nov 06 13:04:55 CET 2009</date>
    </item>
    <item>
      <date/>
    </item>
  </dates>
</root>"
    xml_updater = XmlUpdater.new actual_xml
    xml_updater.update_date_format('//dates/item/date', '%Y-%m-%d %H:%M:%S')
    assert_equal(expected_xml, xml_updater.to_xml)
  end
  
  def test_update_content_with_counter
    expected_xml = "<?xml version=\"1.0\"?>
<root>
  <names>
    <item>
      <name>Test1</name>
    </item>
    <item>
      <name>Test2</name>
    </item>
    <item>
      <name>Test3</name>
    </item>
  </names>
</root>\n"
    actual_xml = "<?xml version=\"1.0\"?>
<root>
  <names>
    <item>
      <name>Un</name>
    </item>
    <item>
      <name>Deux</name>
    </item>
    <item>
      <name>Trois</name>
    </item>
  </names>
</root>"
    xml_updater = XmlUpdater.new actual_xml
    xml_updater.update_content_with_counter('//names/item/name', 'Test')
    assert_equal(expected_xml, xml_updater.to_xml)
  end
  
  def test_remove_attribute
    expected_xml = "<?xml version=\"1.0\"?>
<root>
  <names>
    <item>
      <name>Test1</name>
    </item>
    <item>
      <name>Test2</name>
    </item>
    <item>
      <name>Test3</name>
    </item>
  </names>
</root>\n"
    actual_xml = "<?xml version=\"1.0\"?>
<root>
  <names>
    <item>
      <name id=\"1\">Test1</name>
    </item>
    <item>
      <name id=\"2\">Test2</name>
    </item>
    <item>
      <name id=\"3\">Test3</name>
    </item>
  </names>
</root>"
    xml_updater = XmlUpdater.new actual_xml
    xml_updater.remove_attribute('//names/item/name', 'id')
    assert_equal(expected_xml, xml_updater.to_xml)
  end
  
  def test_update_content
    expected_xml = "<?xml version=\"1.0\"?>
<root>
  <names>
    <item>
      <value>999</value>
    </item>
    <item>
      <value>999</value>
    </item>
    <item>
      <value>999</value>
    </item>
  </names>
</root>\n"
    actual_xml = "<?xml version=\"1.0\"?>
<root>
  <names>
    <item>
      <value>123</value>
    </item>
    <item>
      <value>213</value>
    </item>
    <item>
      <value>312</value>
    </item>
  </names>
</root>"
    xml_updater = XmlUpdater.new actual_xml
    xml_updater.update_content('//names/item/value', '999')
    assert_equal(expected_xml, xml_updater.to_xml)
  end
  
  def test_add_element
    expected_xml = "<?xml version=\"1.0\"?>
<root>
  <names>
    <item>
      <name>Test1</name>
      <value>999</value>
    </item>
    <item>
      <name>Test2</name>
      <value>999</value>
    </item>
    <item>
      <name>Test3</name>
      <value>999</value>
    </item>
  </names>
</root>\n"
    actual_xml = "<?xml version=\"1.0\"?>
<root>
  <names>
    <item>
      <name>Test1</name>
    </item>
    <item>
      <name>Test2</name>
    </item>
    <item>
      <name>Test3</name>
    </item>
  </names>
</root>"
    xml_updater = XmlUpdater.new actual_xml
    xml_updater.add_child_element('//names/item', 'value', '999')
    assert_equal(expected_xml, xml_updater.to_xml)
  end

  def test_add_element_with_type
    expected_xml = "<?xml version=\"1.0\"?>
<root>
  <names>
    <item>
      <name>Test1</name>
      <value type=\"double\">999</value>
    </item>
    <item>
      <name>Test2</name>
      <value type=\"double\">999</value>
    </item>
    <item>
      <name>Test3</name>
      <value type=\"double\">999</value>
    </item>
  </names>
</root>\n"
    actual_xml = "<?xml version=\"1.0\"?>
<root>
  <names>
    <item>
      <name>Test1</name>
    </item>
    <item>
      <name>Test2</name>
    </item>
    <item>
      <name>Test3</name>
    </item>
  </names>
</root>"
    xml_updater = XmlUpdater.new actual_xml
    xml_updater.add_child_element('//names/item', 'value', '999', 'double')
    assert_equal(expected_xml, xml_updater.to_xml)
  end

  def test_add_element_when_existing
    expected_xml = "<?xml version=\"1.0\"?>
<root>
  <names>
    <item>
      <name>Test1</name>
      <value>999</value>
    </item>
    <item>
      <name>Test2</name>
      <value>999</value>
    </item>
    <item>
      <name>Test3</name>
      <value>999</value>
    </item>
  </names>
</root>\n"
    actual_xml = "<?xml version=\"1.0\"?>
<root>
  <names>
    <item>
      <name>Test1</name>
      <value>999</value>
    </item>
    <item>
      <name>Test2</name>
      <value>999</value>
    </item>
    <item>
      <name>Test3</name>
      <value>999</value>
    </item>
  </names>
</root>"
    xml_updater = XmlUpdater.new actual_xml
    xml_updater.add_child_element('//names/item', 'value', '999')
    assert_equal(expected_xml, xml_updater.to_xml)
  end

  def test_add_element_to_root_with_child
    expected_xml = "<?xml version=\"1.0\"?>
<root>
  <test/>
  <foo><bar>1</bar></foo>
</root>\n"
    actual_xml = "<?xml version=\"1.0\"?>
<root>
  <test/>
</root>"
    xml_updater = XmlUpdater.new actual_xml
    xml_updater.add_element_to_root('foo')
    xml_updater.add_child_element('//foo', 'bar', 1)
    assert_equal(expected_xml, xml_updater.to_xml)
  end

  def test_add_element_to_root_where_exists
    expected_xml = "<?xml version=\"1.0\"?>
<root>
  <test/>
  <foo>
    <bar>1</bar>
  </foo>
</root>\n"
    actual_xml = "<?xml version=\"1.0\"?>
<root>
  <test/>
  <foo>
    <bar>1</bar>
  </foo>
</root>"
    xml_updater = XmlUpdater.new actual_xml
    xml_updater.add_element_to_root('foo')
    xml_updater.add_child_element('//foo', 'bar', 1)
    assert_equal(expected_xml, xml_updater.to_xml)
  end

  def test_add_element_to_root_where_another_root_element_has_same_child
    expected_xml = "<?xml version=\"1.0\"?>
<root>
  <test>
    <foo>0</foo>
  </test>
  <foo><bar>1</bar></foo>
</root>\n"
    actual_xml = "<?xml version=\"1.0\"?>
<root>
  <test>
    <foo>0</foo>
  </test>
</root>"
    xml_updater = XmlUpdater.new actual_xml
    xml_updater.add_element_to_root('foo')
    xml_updater.add_child_element('/root/foo', 'bar', 1)
    assert_equal(expected_xml, xml_updater.to_xml)
  end

  def test_remove_element
    expected_xml = "<?xml version=\"1.0\"?>
<root>
  <names>
    <item>
      <value>999</value>
    </item>
    <item>
      <value>999</value>
    </item>
    <item>
      <value>999</value>
    </item>
  </names>
</root>\n"
    actual_xml = "<?xml version=\"1.0\"?>
<root>
  <names>
    <item>
      <name>Test1</name>
      <value>999</value>
    </item>
    <item>
      <name>Test2</name>
      <value>999</value>
    </item>
    <item>
      <name>Test3</name>
      <value>999</value>
    </item>
  </names>
</root>"
    xml_updater = XmlUpdater.new actual_xml
    xml_updater.remove_element('//names/item/name')
    assert_equal(expected_xml, xml_updater.to_xml)
  end
end