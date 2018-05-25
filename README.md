re-write-js
===========


Yet another `translator`, created because I needed something simple.

This is just a syntax for writing simple String transformation functions.
For example:

    var translate = require("re-write-js").buildTranslatorFn({
      "Hi {x}!"                 : "Salut {x} !",
      "{x} plus {y} equals {z}" : "L'addition de {x} et {y} donne {z}",
      '"{}"'                    : "« {} »",
      "I have {} apples"        : function(x){
        if (x < 0) return "J'ai un déficit de pommes";
        if (x == 0) return "Je n'ai pas de pommes";
        if (x == 1) return "J'ai une pomme";
        if (x == 2) return "J'ai deux pommes";
        return "J'ai "+x+" pommes"; }
    }, {name: "Wojtek"});

    translate('Hi {name}!');
    // Salut Wojtek !
    translate('Hi {name}!', {name: "Anne"});
    // Salut Anne !
    translate('Hi {=Ben}!');
    // Salut Ben !

    translate('{x} plus {y} equals {z}', {x:1, y:2, z: 1 + 2});
    // L'addition de 1 et 2 donne 3
    translate(`{=2} plus {=2} equals {=${2+2}}`);
    // L'addition de 2 et 2 donne 4

    translate('"{str}"', {str: "Bonjour!"});
    // « Bonjour! »
    translate('{=Bonsoir!}');
    // « Bonsoir! »

    translate("I have {y} apples",{y:2+3});
    // J'ai 5 pommes
    translate("I have {=0} apples");
    // Je n'ai pas de pommes
    translate("I have {y} apples",{y:'Ho!'});
    // J'ai Ho! pommes

