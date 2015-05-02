ld = require "lodash"
parse = require "./parse"

module.exports = (dict) ->
    dict = ld.transform dict, (res, val, key) ->
        keyP = parse key
        if ld.isFunction val
            res[keyP.name] = val
        else
            if val is ""
                valP = keyP
            else
                valP = parse val
            res[keyP.name] =
                remap: do ->
                    inArgs = ld.transform keyP.params, (res, val, i) ->
                        res[val] = i
                    , {}
                    ld.map valP.params, (x) -> inArgs[x]
                parts: valP.parts
    (x) ->
        o = dict[x]
        return o if ld.isFunction o
        (args...) ->
            ld.reduce o.parts, (res, val, i) ->
                res.concat [val, args[o.remap[i]]]
            , []
            .join ""
