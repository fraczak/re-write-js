ld = require "lodash"

re = /[{]([^}]*)[}]/g

class Translator
    constructor: (@dict = (-> ( -> )), @context = {}) ->

    extractPattern: (pattern) ->
        parts = pattern.split re
        ld.transform parts, (res, val, i) ->
            if i % 2
                res.name += "{}"
                res.params.push val
            else
                res.name += val
            res
        , {name:"", params:[]}
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
            console.error "Translation error!!! Called with pattern: '#{pattern}', context: #{context}"
            return "_invalide_i18n_#{pattern}"

module.exports = Translator
