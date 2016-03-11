#import Requests
import HTTPClient

dict2t(d) = map(p -> (p.first, p.second), d)

headers = Dict("User-Agent" => "EVE.jl/$EVE_JL_VERSION (https://github.com/Daagr/EVE.jl)")
function eget(url; query = Dict())
    r = HTTPClient.get(url; headers = dict2t(headers), query_params = dict2t(query))

    if r.http_code ≠ 200
        error("Request failed $r.http_code")
    end
    bytestring(r.body)
end
