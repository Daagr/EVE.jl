using QDXML

const DEFAULT_API_SERVER = "https://api.eveonline.com/"
const SINGULARITY_API_SERVER = "https://api.testeveonline.com/"

type Character
    id::Int
    name::AbstractString
    apikey
    apiVcode
    apiServer
    cache::Dict{AbstractString, Tuple{DateTime, Any}}
end

function getCharacters(key, vCode, apiserver=DEFAULT_API_SERVER)
    empty_char = Character(0, "", key, vCode, DEFAULT_API_SERVER, Dict())
    r = apiget(empty_char, "account/Characters")
    [Character(parse(Int, c.attrs["characterID"]), c.attrs["name"], key, vCode, apiserver, Dict()) for c in r["row", :]]
end

# example endpoint char/SkillQueue ?
function apiget(character::Character, endpoint)
    if endpoint in keys(character.cache) && character.cache[endpoint][1] > now(Dates.UTC)
        x = character.cache[endpoint][2]
    else
        query = Dict("keyID" => character.apikey, "vCode" => character.apiVcode)
        if character.id ≠ 0
            query["characterID"] = character.id
        end
        r = eget("$DEFAULT_API_SERVER$endpoint.xml.aspx", query = query)
        x = XML(r)
    end

    # TODO: what if there is no cachedUntil
    # TODO: plus a few seconds
    cachetime = DateTime(x["cachedUntil"].elems[1], "y-m-d H:M:S")
    character.cache[endpoint] = (cachetime, x)
    
    x
end

# TODO: what is a sane type? should this return it as a string?
balance(character::Character, parsetype=Float64) = parse(parsetype, apiget(character, "char/AccountBalance")["key"].attrs["balance"])
