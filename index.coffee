ld = require "lodash"
parse = require "./parse"
build_dict = require "./build-dict" 

class Translator
    constructor: (@dict = (-> ( -> "" )), @context = {}, @errFn) ->
        if not @errFn
            @errFn = (err, pattern, context) ->
                console.error "Translation error: #{err}"
                console.error "   pattern: '#{pattern}'"
                console.error "   context: #{context}"
                return "[#{pattern}]_i18n"


    translator: (pattern = "", context) ->
        # throw new Error "Need a pattern to translate!" unless pattern
        c = ld.assign {}, @context, context
        {name, params} = parse pattern
        f = @dict name
        a = ld.map params, (val) ->
            if 0 is val.indexOf "="
                val. substring 1
            else
                c[val]
        try
            return f(a...)
        catch err
            @errFn(err,pattern,context)

module.exports = Translator
