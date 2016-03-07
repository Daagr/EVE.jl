# TODO: use https
const IMAGE_SERVER = "http://image.eveonline.com"

img_get(endpoint, id, size, filetype = endpoint == "Character" ? "jpg" : "png") = eget("$IMAGE_SERVER/$endpoint/$(id)_$size.$filetype")
