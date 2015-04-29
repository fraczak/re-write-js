
var translator_gen = require("./"),
    ld = require("lodash");

var dict = {
    "{}": function(x){ return x;},
    "1" : function(){ return "one"; },
    "I am {}": function(x){
        return "I am "+x.toLocaleString();
    },
    "Success" : function(){ return "Success"; },
    "Today is {}" : function() {
        return "Today is "+(new Date()).toLocaleString();
    },
    "{} apple(s)": function(n){
        return (n > 1) ? (n+" apples") : (n==1) ? "one apple" : "no apple";
    }
};
var globalContext = {my_name: "Wojciech Fraczak", n: 172};
var txt = translator_gen(dict, globalContext);

ld.each([
    'txt("{=as is}")',
    'txt("I am {my_name}")',
    'txt("I am {name}",{name:"myself"})',
    'txt("Today is {}")',
    'txt("{=1} apple(s)")',
    'txt("{n} apple(s)")'],
        function(x) {
            console.log(" ",">", x);
            console.log("\033[32m ",eval(x),"\033[0m ");
        });
