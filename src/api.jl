using QDXML

const DEFAULT_API_SERVER = "https://api.eveonline.com/"
const SINGULARITY_API_SERVER = "https://api.testeveonline.com/"

type Character
    id::Int
    name::AbstractString
    apikey
    apiVcode
    apiServer
end

function getCharacters(key, vCode)
    empty_char = Character(0, "", key, vCode, DEFAULT_API_SERVER)
    r = apiget(empty_char, "account/Characters")
end

# example endpoint char/SkillQueue ?
function apiget(character::Character, endpoint)
    query = Dict("keyID" => character.apikey, "vCode" => character.apiVcode)
    if character.id ≠ 0
        query["characterID"] = character.id
    end
    r = eget("$DEFAULT_API_SERVER$endpoint.xml.aspx", query = query)
end
