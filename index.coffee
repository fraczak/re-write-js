ld = require "lodash"

re = /[{]([^}]*)[}]/g

class Translator
    constructor: (dict = (-> ( -> )), @context = {}) ->
        if ld.isFunction dict
            @dict = dict
        else
            dict = ld.transform dict, (res, val, key) =>
                keyP = @extractPattern key
                if ld.isFunction val
                    res[keyP.name] = val
                else
                    if val is ""
                        valP = keyP
                    else
                        valP =  @extractPattern val
                    res[keyP.name] =
                        remap: do ->
                            inArgs = ld.transform keyP.params, (res, val, i) ->
                                res[val] = i
                            , {}
                            ld.map valP.params, (x) -> inArgs[x]
                        parts: valP.parts
                res
            @dict = (x) ->
                o = dict[x]
                return o if ld.isFunction o
                (args...) ->
                    ld.reduce o.parts, (res, val, i) ->
                        res.concat [val, args[o.remap[i]]]
                    , []
                    .join ""

    extractPattern: (pattern) ->
        parts = (""+pattern).split re
        ld.transform parts, (res, val, i) ->
            if i % 2
                res.name += "{}"
                res.params.push val
            else
                res.name += val
                res.parts.push val
            res
        , {name:"", params:[], parts:[]}
    translator: (pattern, context) ->
        throw new Error "Need a pattern to translate!" unless pattern
        c = ld.assign {}, @context, context
        {name, params} = @extractPattern pattern
        f = @dict name
        a = ld.map params, (val) ->
            if 0 is val.indexOf "="
                val. substring 1
            else
                c[val] or "???"
        try
            return f(a...)
        catch e
            console.error "Translation error: #{e}"
            console.error "Called with pattern: '#{pattern}', context: #{context}"
            return "[#{pattern}]_i18n"

module.exports = Translator
