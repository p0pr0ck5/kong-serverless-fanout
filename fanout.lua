local ns = require("resty.dns.utils").parseResolvConf().nameserver
local resolver = require "resty.dns.resolver"
local r, err = resolver:new({ nameservers = ns })
if not r then
  ngx.log(ngx.WARN, err)
  return
end
local answers, err = r:query("httpbin", nil, {})
if not answers then
  ngx.log(ngx.WARN, err)
  return
end
if answers.errcode then
  ngx.log(ngx.WARN, "server returned error code: ", answers.errcode,
    ": ", answers.errstr)
  return
end

local t = {}
for i, ans in ipairs(answers) do
  local b
  local http = require "resty.http"
  local httpc = http.new()
  local ok, err = httpc:connect(ans.address, 80)
  if not ok then
    ngx.log(ngx.WARN, err)
  else
    local res, err = httpc:proxy_request()
    if not res then
      ngx.log(ngx.WARN, err)
    else
      local body = res:read_body()
      b, err = require("cjson.safe").decode(body)
      if not b then
        b = body
      end
    end
  end
  t[#t+1] = {node = ans.address, response = b, err = err}
end
ngx.print(require("cjson").encode(t))
