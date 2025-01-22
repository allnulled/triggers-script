const fs = require("fs");

const file = __dirname + "/triggers-script.parser.js";

const fixedContent = fs.readFileSync(file).toString().replace("\n})(this);", "\n})(typeof window !== 'undefined' ? window : global);")

fs.writeFileSync(file, fixedContent, "utf8");