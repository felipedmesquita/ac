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
.and_return([invalid_response, invalid_response, invalid_response, valid_response])

response = Typhoeus::Response.new(
  code: 401,
  status_message: "",
  body: "{\"message\":\"missing or invalid token\",\"error\":\"unauthorized_scopes\",\"status\":401,\"cause\":[]}",
  headers: {"content-type" => "application/json; charset=utf-8", "content-length" => "92", "date" => "Tue, 11 Mar 2025 11:18:33 GMT", "x-content-type-options" => "nosniff", "x-request-id" => "6b9fa399-f0b3-49c4-b3e4-116ce0eabd2f", "strict-transport-security" => "max-age=15552000; includeSubDomains;", "x-frame-options" => "DENY", "x-xss-protection" => "1; mode=block", "access-control-allow-origin" => "*", "access-control-allow-headers" => "Content-Type", "access-control-allow-methods" => "PUT, GET, POST, DELETE, OPTIONS", "access-control-max-age" => "86400", "x-cache" => "Error from cloudfront", "via" => "1.1 97709c0fcba512e9c9f6cf6f0e63e36a.cloudfront.net (CloudFront)", "x-amz-cf-pop" => "GRU3-P4", "x-amz-cf-id" => "DT5Ay5lCrHLY4lzAFdyDeWdbW2fv2TdKeB-7OYRSCdcYzxI90yE6UQ=="},
  effective_url: "https://api.mercadolibre.com/items/MLB1",
  options: {httpauth_avail: 0, total_time: 0.216233, starttransfer_time: 0.215726, appconnect_time: 0.086843, pretransfer_time: 0.086945, connect_time: 0.018004, namelookup_time: 0.010012, redirect_time: 0.0, effective_url: "https://api.mercadolibre.com/items/MLB1", primary_ip: "3.162.246.64", response_code: 401, request_size: 128, redirect_count: 0, redirect_url: nil, size_upload: 0.0, size_download: 92.0, speed_upload: 0.0, speed_download: 425.0, return_code: :ok, response_headers: "HTTP/2 401 \r\ncontent-type: application/json; charset=utf-8\r\ncontent-length: 92\r\ndate: Tue, 11 Mar 2025 11:18:33 GMT\r\nx-content-type-options: nosniff\r\nx-request-id: 6b9fa399-f0b3-49c4-b3e4-116ce0eabd2f\r\nstrict-transport-security: max-age=15552000; includeSubDomains;\r\nx-frame-options: DENY\r\nx-xss-protection: 1; mode=block\r\naccess-control-allow-origin: *\r\naccess-control-allow-headers: Content-Type\r\naccess-control-allow-methods: PUT, GET, POST, DELETE, OPTIONS\r\naccess-control-max-age: 86400\r\nx-cache: Error from cloudfront\r\nvia: 1.1 97709c0fcba512e9c9f6cf6f0e63e36a.cloudfront.net (CloudFront)\r\nx-amz-cf-pop: GRU3-P4\r\nx-amz-cf-id: DT5Ay5lCrHLY4lzAFdyDeWdbW2fv2TdKeB-7OYRSCdcYzxI90yE6UQ==\r\n\r\n", response_body: "{\"message\":\"missing or invalid token\",\"error\":\"unauthorized_scopes\",\"status\":401,\"cause\":[]}", debug_info: ""}
)
Typhoeus.stub("https://api.mercadolibre.com/items/MLB1", {method: :get})
.and_return(response)

