parse = require "./parse"
build_dict = require "./build-dict"
{isFunction} = require "./helpers"

class Translator
  constructor: (@dict = (-> ( -> "" )), @context = {}, @errFn) ->
    if not @errFn
      @errFn = (err, pattern, context) ->
        console.error "Translation error: #{err}"
        console.error "   pattern: '#{pattern}'"
        console.error "   context: #{context}"
        return "[#{pattern}]_i18n"
    if not isFunction @dict
      @dict = build_dict @dict


  translate: (pattern = "", context) ->
    # console.log JSON.stringify {pattern, context}
    c = Object.assign {}, @context, context
    {name, params} = parse pattern
    f = @dict name
    a = params.map (val) ->
      if val.charAt(0) is "="
        val.substring 1
      else
        c[val]
    try
      return f(a...)
    catch err
      @errFn(err,pattern,context)

Translator.buildTranslatorFn = (args...) ->
  translator = new Translator args...
  translator.translate.bind translator

module.exports = Translator
