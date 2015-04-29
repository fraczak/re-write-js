re-write-js
===========


Yet another `translator`, created because I needed something simple.

This is a syntax for writing simple first-order String functions.
For exemple:

        var fn = require("re-write-js")({"{}":function(x) {return x;}});

        fn("{x}",{x:"Hi!"});
        // 'Hi!'

        fn("{=x}",{x:"hey!"});
        // 'x'

        fn.__context["x"] = "Ho!";
        fn("{x}");
        // 'Ho!'

        fn.__dict["I have {} apples"] = function(x) {
            if (x < 0)
               return "I have a deficit of apples";
            if (x == 0)
               return "I don't have apples";
            if (x == 1)
               return "I have one apple";
            return "I have "+x+" apples";
        };
        fn("I have {y} apples",{y:2+3});
        // 'I have 5 apples'

        fn("I have {x} apples");
        // 'I have Ho! apples'