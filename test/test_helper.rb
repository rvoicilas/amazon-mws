require 'mocha'
require 'pathname'
require 'yaml'
require 'test/unit'

require File.join(File.dirname(__FILE__), '..', 'lib', 'amazon', 'mws')

def xml_for(api, name)
  Pathname.new(File.dirname(__FILE__)).expand_path.join("fixtures/#{api}/#{name}.xml")
end

def report_xml_for(name)
  return xml_for('report', name)
end

def mock_response(code, options={})
  body = options[:body]
  content_type = options[:content_type]

  response = Net::HTTPResponse.send(:response_class, code.to_s).new("1.0", code.to_s, "message")
  response.instance_variable_set(:@body, body)
  response.instance_variable_set(:@read, true)
  response.content_type = content_type
  return response
end
