var ld = require("lodash");

/************
 * To generate a "translator", call the exported function `translator` with
 * @param: dict - a map from pattern names (Strings) to functions returning String
 * @param: globalContext - default values for parameters
 *
 * E.g.,
 * var dict = {
 *       "One": function(){ return "Un";}, 
 *       "{} apple(s)": function(n){ return (n > 1) ? (n+" apples") : (n) ? "one apple" : "no apple"; } },
 *     globalContext: {n:100};
 * translator(dict,globalContext)("{n} apple(s)");
 * //--> "100 apples"
 ****************/
var translator = function(dict,globalContext){
    var re = /[{]([^}]*)[}]/g,
        extractPattern = function(pattern) {
            var parts = pattern.split(re);
            return ld.transform(parts, function( res, val, i ) {
                if (i % 2) {
                    res.name += "{}";
                    res.params.push(val);
                } else {
                    res.name += val;
                };
            }, {name:"",params:[]});
        };
    dict = dict || {};
    globalContext = globalContext || {};
    var translatorFn = function(pattern,context) {
        if (! pattern)
            throw new Error("Need a pattern to translate!");
        var c = ld.assign({}, globalContext, context),
            p = extractPattern(pattern),
            f = dict[p.name],
            a = ld.map(p.params, function(val) {
                if (val.indexOf("=") === 0)
                    return val.substring(1);
                else
                    return c[val] || "???";
            });
        try {
            return f.apply(null, a);
        } catch(e) {
            console.error("Translation error!!! Called with pattern: '"+pattern+"', context: "+context+")");
            return "_invalide_i18n_"+pattern;
        }
    };
    translatorFn.__dict = dict;
    translatorFn.__context = globalContext;

    return translatorFn;
};

module.exports = translator;
