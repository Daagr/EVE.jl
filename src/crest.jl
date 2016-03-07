using JSON

const DEFAULT_CREST_SERVER = "https://public-crest.eveonline.com/"

# TODO: typealias
type CrestCache
    cache::Dict{AbstractString, Tuple{DateTime, Any}}
end

defaultcache = CrestCache(Dict())

immutable CrestTree
    url
    data::Dict
    CrestTree(url=DEFAULT_CREST_SERVER, data=ecget(url)) = new(url, data)
end

Base.show(io::IO, tree::CrestTree) = print(io, "CrestTree"*("name" in keys(tree.data) ? ("("*tree.data["name"]*")") : "")*"{"*join(keys(tree.data), ", ")*"}")

Base.getindex(::Type{CrestTree}, key) = CrestTree()[key]

function Base.getindex(tree::CrestTree, key)
    if key in keys(tree.data)
        if isa(tree.data[key], Dict)
            if "href" in keys(tree.data[key])
                n = CrestTree(tree.data[key]["href"])
                return n
            else
                return CrestTree("", tree.data[key])
            end
        end
        if isa(tree.data[key], AbstractArray) # TODO: if elems have name, give a view
            return [CrestTree("", i) for i in tree.data[key]]
        end
        return tree.data[key]
    end
    throw(KeyError(key))
end

Base.call(tree::CrestTree) = "href" in keys(tree.data) ? CrestTree(tree.data["href"]) : tree


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
    cache.cache[href] = (now() + Dates.Minute(5), d)
    d
end

