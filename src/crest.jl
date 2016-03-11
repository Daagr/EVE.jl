using JSON

const DEFAULT_CREST_SERVER = "https://public-crest.eveonline.com/"

# TODO: typealias
type CrestCache
    cache::Dict{AbstractString, Tuple{DateTime, Any}}
end

defaultcache = CrestCache(Dict())

immutable Crest
    url
    data::Dict
    Crest(url=DEFAULT_CREST_SERVER, data=ecget(url)) = new(url, data)
end

Base.show(io::IO, tree::Crest) = print(io, "Crest"*("name" in keys(tree.data) ? ("("*tree.data["name"]*")") : "")*"{"*join(keys(tree.data), ", ")*"}")

Base.getindex(::Type{Crest}, key) = Crest()[key]

function Base.getindex(tree::Crest, key)
    if key in keys(tree.data)
        if isa(tree.data[key], Dict)
            if "href" in keys(tree.data[key])
                n = Crest(tree.data[key]["href"])
                return n
            else
                return Crest("", tree.data[key])
            end
        end
        if isa(tree.data[key], AbstractArray) # TODO: if elems have name, give a view
            return [Crest("", i) for i in tree.data[key]]
        end
        return tree.data[key]
    end
    throw(KeyError(key))
end

Base.call(tree::Crest) = "href" in keys(tree.data) ? Crest(tree.data["href"]) : tree


function ecget(href, cache::CrestCache=defaultcache)
    if href in keys(cache.cache)
        hit = cache.cache[href]
        if hit[1] > now()
            println("Cache hit ", href)
            return hit[2]
        end
    end
    println("Downloading ", href)
    
    data = eget(href)
    d = JSON.parse(data)
    # TODO: better caching
    # TODO: utc times
    cache.cache[href] = (now() + Dates.Minute(5), d)
    d
end

