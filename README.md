re-write-js
===========


Yet another `translator`, created because I needed something simple.

This is just a syntax for writing simple String functions.
For example:

    var Translator = require("re-write-js");

    var translator = new Translator();
    translator.dict = function(p) {
      if (p == "{}")
        return function(x) {
          return x;
        }
    };
    var fn = translator.translator.bind(translator);

    fn("{x}",{x:"Hi!"});
    // 'Hi!'

    fn("{=x}",{x:"hey!"});
    // 'x'

    translator.context["x"] = "Ho!";
    fn("{x}");
    // 'Ho!'

    translator.dict = function(p) {
      if (p == "I have {} apples")
        return function(x) {
            if (x < 0)
               return "I have a deficit of apples";
            if (x == 0)
               return "I don't have apples";
            if (x == 1)
               return "I have one apple";
            return "I have "+x+" apples";
        };
    };

    fn("I have {y} apples",{y:2+3});
    // 'I have 5 apples'

    fn("I have {x} apples");
    // 'I have Ho! apples'
