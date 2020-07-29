ngx.req.set_header("reqfoo", "reqbar")
ngx.log(ngx.WARN, "YEP")
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
      ngx.log(ngx.WARN, ans.name, " ", ans.address or ans.cname,
              " type:", ans.type, " class:", ans.class,
              " ttl:", ans.ttl)


  local http = require "resty.http"
  local httpc = http.new()
  local ok, err = httpc:connect(ans.address, 80)
  if not ok then
    ngx.log(ngx.WARN, err)
    return
  end
  local res, err = httpc:proxy_request()
  if not res then
    ngx.log(ngx.WARN, err)
    return
  end
  local b = require("cjson").decode(res:read_body())
  t[#t+1] = {node = ans.address, response = b}
end
ngx.print(require("cjson").encode(t))
