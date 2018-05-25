re = /[{]([^}]*)[}]/g

module.exports = (pattern) ->
  parts = (""+pattern).split re
  (parts or []).reduce (res, val, i) ->
    if i % 2
      res.name += "{}"
      res.params.push val
    else
      res.name += val
      res.parts.push val
    res
  , {name:"", params:[], parts:[]}
