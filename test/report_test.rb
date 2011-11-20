require File.join(File.dirname(__FILE__), 'test_helper')

class ReportTest < Test::Unit::TestCase
  include Amazon::MWS

  def setup
    config = YAML.load_file(File.join(File.dirname(__FILE__), 'test_config.yml'))
    @report = Base.new(config)
  end

  def test_request_report_wrong_signature
    @report.stubs(:get).returns(
      mock_response(403, :body => File.read(report_xml_for(
                    'request_report_wrong_signature')),
                    :content_type => 'text/xml'))
    response = @report.request_report(:merchant_listing, :start_date => Time.now,
                                      :end_date => Time.now.iso8601)
    assert_kind_of(ResponseError, response)
  end

  def test_request_report_raises
    assert_raise InvalidReportType do
      response = @report.request_report(:whatever)
    end
  end

end
