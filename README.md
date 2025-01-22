# triggers-script

Top-level language to define events and main events behaviour.

## Installation

```sh
npm i -s @allnulled/triggers-script
```

## Importation

In node.js:

```js
require("@allnulled/triggers-script");
```

In html:

```js
<script src="node_modules/@allnulled/triggers-script/triggers-script.js"></script>
```

Once done this, you have available under `window` or `global`: `TriggersScriptParser` which is a typical pegjs parser.

## Usage

```js
require(__dirname + "/triggers-script.parser.js");

describe("TriggersScript Parser API Test", function() {
  
  it("can parse a simple event", async function() {
    TriggersScriptParser.parse(`
      on event {{ "wherever" }} as {{ "TR001" }} then {
        break process {{ p1 }}
      }
    `);
  });

  it("can parse all basic sentences", async function() {
    const js = TriggersScriptParser.parse(`
     // Comentarios válidos como en JavaScript
     // On event:
     on event {{ "wherever" }} as {{ "TR001" }} priority {{ 100 }} then {
      // Try-catch-finally:
      try {
       // Always:
       always {{ Events.by.model[event.model]("stage 1", 200, "ok") }}
       // Return:
       return {{ 500 }}
       // Throw:
       throw {{ new Error("Wherever") }}
       // On process sentence:
       on process {{ p1 }} then {
        always {{ console.log("ok, in p1") }}
        // Break process:
        break process {{ p1 }}
       }
       // On process label for if structure:
       on process {{ wherever }}
       if {{ 0 }} and ({{ 0 }} or {{ 0 }}) then {{ console.log("ok!") }}
       else if {{ 0 }} then {{ console.log("ok!") }}
       else if {{ 0 }} then {{ console.log("ok!") }}
       else then {{ console.log("ok!") }}
       // If without label:
       if {{ 0 }} then {{ console.log(0) }}
       switch on {{ Events.by.model }} using {{ event.model }} passing {{ "stage 1", 200, "ok" }}
      } catch {}
     }
    `);
    require("fs").writeFileSync(__dirname + "/test-output.js", js, "utf8");
  });

});
```