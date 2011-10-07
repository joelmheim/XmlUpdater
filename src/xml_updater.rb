require 'rubygems'
require 'nokogiri'

class XmlUpdater
  attr_accessor :xml_document
  
  def initialize(path_to_xml_file)
    @xml_file = path_to_xml_file
    parse_xml @xml_file
  end

  def get_element(element_name)
    return @xml_document.xpath(element_name).first
  end
  
  def updateDateContent(xpath, new_format)
    elements = @xml_document.xpath(xpath)
    elements.each do |element|
      element_date = Date.parse element.content
      element.content = element_date.strftime(new_format)
    end
  end
  
  def write_xml()
    File.open(@xml_file, 'w') do |f|
      f.write(@xml_document.to_xml)
    end
  end

private 
  def parse_xml(path_to_xml_document) 
    File.open(path_to_xml_document) do |f|
      @xml_document = Nokogiri::XML(f)
    end
  end

end