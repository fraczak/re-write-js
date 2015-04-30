Translator = require "./index.coffee"
ld = require "lodash"

dict =
    "{}": (x) -> x
    "1" : -> "one"
    "I am {}": (x) ->
        "I am #{x.toLocaleString()}"
    "Success" : -> "Success"
    "Today is {}" : ->
        "Today is #{new Date().toLocaleString()}"
    "{} apple(s)": (n) ->
        return "#{n} apples" if n > 1
        return "one apple" if n == 1
        return "no apple"

globalContext =
    my_name: "Wojciech Fraczak"
    n: 172

translator = new Translator (x) ->
    dict[translator.extractPattern(x).name]
, globalContext

fn = translator.translator.bind translator

ld.each [
    'fn("{=as is}")'
    'fn("I am {my_name}")'
    'fn("I am {name}",{name:"myself"})'
    'fn("Today is {}")'
    'fn("{=1} apple(s)")'
    'fn("{n} apple(s)")' ]
, (x) ->
    console.log " ",">", x
    console.log " ",eval(x)
