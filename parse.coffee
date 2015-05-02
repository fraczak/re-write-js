ld = require "lodash"

re = /[{]([^}]*)[}]/g

module.exports = (pattern) ->
    parts = (""+pattern).split re
    ld.transform parts, (res, val, i) ->
        if i % 2
            res.name += "{}"
            res.params.push val
        else
            res.name += val
            res.parts.push val
    , {name:"", params:[], parts:[]}
