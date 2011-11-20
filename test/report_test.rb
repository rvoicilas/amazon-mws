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
    assert_kind_of ResponseError, response
  end

  def test_request_report_raises
    assert_raise InvalidReportType do
      response = @report.request_report(:whatever)
    end
  end

  def test_get_report_list
    @report.stubs(:get).returns(
      mock_response(200, :body => File.read(report_xml_for(
                    'get_report_list_max_count_1')),
                    :content_type => 'text/xml'))
    response = @report.get_report_list('MaxCount' => 1)

    assert_kind_of GetReportListResponse, response
    assert_equal true, response.has_next?

    report = response.reports[0]
    assert Report::REPORT_TYPES.values.include?(report.type), 'Invalid report type'
  end

end
