parse = require "./parse"
{isFunction} = require "./helpers"

module.exports = (dict) ->
  dict = Object.keys(dict).reduce (res, key) ->
    val = dict[key]
    keyP = parse key
    if isFunction val
      res[keyP.name] = val
    else
      valP = if val is "" then keyP else parse val
      res[keyP.name] =
        remap: do ->
          inArgs = keyP.params.reduce (res, val, i) ->
            res[val] = i
            res
          , {}
          valP.params.map (x) ->
            inArgs[x]
        parts: valP.parts
    res
  , {}
  (x) ->
      o = dict[x]
      return o if isFunction o
      (args...) ->
        o.parts.reduce (res, val, i) ->
          res.concat [val, args[o.remap[i]]]
        , []
        .join ""
