require 'rubygems'
require 'nokogiri'
require 'fileutils'
require 'date'

class XmlUpdater
  attr_accessor :xml_document
  
  def initialize(string_or_xml_file)
    parse_xml string_or_xml_file
  end

  def get_element(element_name)
    return @xml_document.xpath(element_name).first
  end
  
  def update_date_format(xpath, new_format)
    elements = @xml_document.xpath(xpath)
    elements.each do |element|
      element_date = DateTime.parse element.content
      element.content = element_date.strftime(new_format)
    end
  end
  
  def update_content(xpath, new_content)
    elements = @xml_document.xpath(xpath)
    elements.each do |element|
      element.content = new_content
    end
  end
  
  def update_content_with_counter(xpath, new_content)
    elements = @xml_document.xpath(xpath)
    counter = 0
    elements.each do |element|
      counter += 1
      element.content = new_content + counter.to_s
    end
  end
  
  def remove_attribute(xpath, attribute_name)
    elements = @xml_document.xpath(xpath)
    elements.each do |element|
      element.delete(attribute_name)
    end
  end

  def remove_element(xpath)
    elements = @xml_document.xpath(xpath)
    elements.each do |element|
      element.remove
    end
  end
  
  def write_xml()
    FileUtils.cp(@xml_file, @xml_file + '.bak')
    File.open(@xml_file, 'w') do |f|
      f.write(to_xml)
    end
    rescue Exception
      puts "You shouldn't call write_xml() when you haven't passed a filename as argument."
  end

  def to_xml()
    @xml_document.to_xml.gsub(/\n(\s*\n)+/, "\n")
  end

private 
  def parse_xml(string_or_xml_file)
    File.open(string_or_xml_file) do |f|
      @xml_file = string_or_xml_file
      @xml_document = Nokogiri::XML(f)
    end
    rescue Exception 
      @xml_document = Nokogiri::XML(string_or_xml_file)  
  end
end
