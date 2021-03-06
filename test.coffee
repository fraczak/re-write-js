{buildTranslatorFn} = require "./index.coffee"
build_dict = require "./build-dict.coffee"

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
        return "one apple" if n is 1
        return "one apple" if n is "1"
        return "no apple"
    "{a} plus {b} equals {c}" : "{c} = {a} + {b}"
    "{a}{b}{c}{d}":"{a}.{a}.{b}.{b}.{c}.{c}.{d}"
globalContext =
    my_name: "Wojciech Fraczak"
    n: 172

fn = buildTranslatorFn dict, globalContext

[
    'fn("{=as is}")'
    'fn("I am {my_name}")'
    'fn("I am {name}",{name:"myself"})'
    'fn("Today is {}")'
    'fn("{x} apple(s)",{x:1})'
    'fn("{n} apple(s)")'
    'fn("{=1} apple(s)")'
    'fn("{=2} plus {=3} equals {=5}")'
    'fn("{=2}{=3}{n}{=5}")'
    'fn("{=2}{=3}{nn}{=5}")'
    'fn("{=2}{=3}{nn}{=5}",{nn:0})'
]. map (x) ->
    console.log " > #{x} =>  #{eval x}"

