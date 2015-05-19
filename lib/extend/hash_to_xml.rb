class Hash

  def to_xml_str
    xml_str = "<xml>\n"
    xml_str << xml_format
    xml_str << "</xml>"
  end


  def xml_format
    format = ""
    keys = self.keys
    self.each do |key,value|
      format << "<#{key}>"
      if value.instance_of?(Hash)
        format << value.xml_format
      else
        format << value.to_s
      end
      format << "</#{key}>\n"
    end

    return format
  end


end

