# Xml Updater

XmlUpdater is a ruby tool for updating XML files. It uses Nokgiri for xml parsing and manipulation.

## Functionality

 * Get and return an xml element (will return a Nokogiri element)
 * Update date format of an xml element
 * Update content of an xml element
 * Update content with a counter
 * Remove attribute from element
 * Add child element
 * Add element to root
 * Remove element

 Refer to the tests for further usage examples.

## Example

This example takes in a
'''
  xml_updater = XmlUpdater.new('./testfile.xml')
  xml_updater.add_child_element('//test/item', 'testlevel', '0', 'double')
  xml_updater.add_child_element('//test/item', 'other', '0', 'double')
  xml_updater.add_element_to_root('dataset')
  xml_updater.add_child_element('/root/dataset', 'testid', 'XML-test1', 'char')
  xml_updater.write_xml
'''
