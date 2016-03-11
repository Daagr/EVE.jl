# EVE

*Work in progress.*

Julia utility library for all things EVE Online.

## Features

- [ ] XML API
- [x] Crest
- [ ] Authed Crest
- [ ] SDE
- [ ] zKillboard
- [ ] Eve Who
- [ ] High level map operations
- [ ] Industry

## Crest

```julia
using EVE

Crest["userCounts"]["eve"]
```

## XML API

```julia
c = EVE.getCharacters(key, vCode)
# something something work in progress...
# return type and name will probably change
EVE.balance(c[1])
```
