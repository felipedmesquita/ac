invalid_response = Typhoeus::Response.new(
  code: 200,
  status_message: "",
  body: "{notjson",
  headers: {"date"=>"Wed, 01 Nov 2023 18:46:21 GMT", "content-type"=>"application/json", "content-length"=>"31", "server"=>"gunicorn/19.9.0", "access-control-allow-origin"=>"*", "access-control-allow-credentials"=>"true"},
  effective_url: "https://httpbin.org/ip",
  options: {:httpauth_avail=>0, :total_time=>1.250812, :starttransfer_time=>1.250412, :appconnect_time=>1.106504, :pretransfer_time=>1.10667, :connect_time=>0.688653, :namelookup_time=>0.544151, :redirect_time=>0.0, :effective_url=>"https://httpbin.org/ip", :primary_ip=>"54.204.25.77", :response_code=>200, :request_size=>111, :redirect_count=>0, :redirect_url=>nil, :size_upload=>0.0, :size_download=>31.0, :speed_upload=>0.0, :speed_download=>24.0, :return_code=>:ok, :response_headers=>"HTTP/2 200 \r\ndate: Wed, 01 Nov 2023 18:46:21 GMT\r\ncontent-type: application/json\r\ncontent-length: 31\r\nserver: gunicorn/19.9.0\r\naccess-control-allow-origin: *\r\naccess-control-allow-credentials: true\r\n\r\n", :response_body=>"{notjson", :debug_info=>""}
)

valid_response = Typhoeus::Response.new(
  code: 200,
  status_message: "",
  body: "{\n  \"origin\": \"177.62.66.90\"\n}\n",
  headers: {"date"=>"Wed, 01 Nov 2023 18:46:21 GMT", "content-type"=>"application/json", "content-length"=>"31", "server"=>"gunicorn/19.9.0", "access-control-allow-origin"=>"*", "access-control-allow-credentials"=>"true"},
  effective_url: "https://httpbin.org/ip",
  options: {:httpauth_avail=>0, :total_time=>1.250812, :starttransfer_time=>1.250412, :appconnect_time=>1.106504, :pretransfer_time=>1.10667, :connect_time=>0.688653, :namelookup_time=>0.544151, :redirect_time=>0.0, :effective_url=>"https://httpbin.org/ip", :primary_ip=>"54.204.25.77", :response_code=>200, :request_size=>111, :redirect_count=>0, :redirect_url=>nil, :size_upload=>0.0, :size_download=>31.0, :speed_upload=>0.0, :speed_download=>24.0, :return_code=>:ok, :response_headers=>"HTTP/2 200 \r\ndate: Wed, 01 Nov 2023 18:46:21 GMT\r\ncontent-type: application/json\r\ncontent-length: 31\r\nserver: gunicorn/19.9.0\r\naccess-control-allow-origin: *\r\naccess-control-allow-credentials: true\r\n\r\n", :response_body=>"{\n  \"origin\": \"177.62.66.90\"\n}\n", :debug_info=>""}
)

Typhoeus.stub("https://httpbin.org/ip", {:method=>:get})
.and_return([invalid_response, valid_response])
