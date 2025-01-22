Language = _* s:Sentence* _* { return s.join("\n") }

Sentence = On_event_sentence

On_event_sentence = 
 token1:(_* "on event" _*)
 event:Jsblock
 then:Subsentence_then
  { return `triggers.register(${event}, (event) => { ${then} });` }

Subsentence_then = 
 token1:(_* "then" _*)
 then:(Anyblock)
  { return then }

Anyblock = Jsblock / Innerblock

Innerblock = 
 token1:(_* "{" _*)
 s:Inner_sentence*
 token2:(_* "}" )
  { return s.join("\n") }

Inner_sentence = Always_sentence
/ If_sentence
/ On_process_sentence
/ Break_process_sentence
/ Continue_process_sentence
/ Return_sentence
/ Throw_sentence
/ Try_catch_finally_sentence
/ Switch_on_sentence

Switch_on_sentence =
 token1:(_* "switch on" _*)
 switchOn:Jsblock
 token2:(_* "using" _*)
 using:Jsblock
 token3:(_* "passing" _*)
 passing:Jsblock
  { return `${switchOn}[${using}](${passing});` }

Try_catch_finally_sentence = 
 _try:Subsentence_try
 _catch:Subsentence_catch
 _finally:Subsentence_finally?
  { return _try + _catch + (_finally ?? '')}

Subsentence_try = 
 token1:(_* "try" _*)
 block:Anyblock
  { return `try {\n ${ block }; \n}` }

Subsentence_catch = 
 token1:(_* "catch" _*)
 block:Anyblock
  { return ` catch(error) {\n ${ block }; \n}` }

Subsentence_finally = 
 token1:(_* "finally" _*)
 block:Anyblock
  { return ` finally {\n ${ error }; \n}` }

Throw_sentence = 
 token1:(_* "throw" _*)
 error:Jsblock
  { return `throw ${ error };` }

Return_sentence = 
 token1:(_* "return" _*)
 value:Jsblock
  { return `return ${ value };` }

Break_process_sentence = 
 token1:(_* "break process" _*)
 process:Anyblock
  { return `break ${ process };` }

Continue_process_sentence = 
 token1:(_* "continue process" _*)
 process:Anyblock
  { return `continue ${ process };` }

Always_sentence = 
 token1:(_* "always" _*)
 block:Jsblock
  { return block }

Subsentence_on_process =
 token1:(_* "on process" _*)
 name:Jsblock
  { return name }

On_process_sentence = 
 process:Subsentence_on_process
 block:Subsentence_then
  { return `${process}: {\n ${block} \n}` }

LogicExpression
  = OrExpression

OrExpression
  = left:AndExpression _* "or" _* right:OrExpression { return `(${left} || ${right})`; }
  / AndExpression

AndExpression
  = left:PrimaryExpression _* "and" _* right:AndExpression { return `(${left} && ${right})`; }
  / PrimaryExpression

PrimaryExpression
  = "(" _* expr:LogicExpression _* ")" { return `(${expr})`; }
  / Jsblock

If_sentence = 
 process:Subsentence_on_process?
 token1:(_* "if" _*)
 cond1:LogicExpression
 cons1:Subsentence_then
 condsN:Else_if_sentence*
 exclud:Else_sentence?
  { return `${ process ? process + ": " : '' }if( ${cond1} ) {\n ${cons1} \n}${ condsN ? condsN.join("\n") : '' }${ exclud ?? '' }`; }

Else_if_sentence = 
 token1:(_* "else if" _*)
 cond1:LogicExpression
 cons1:Subsentence_then
  { return ` else if( ${cond1} ) {\n ${cons1} \n}`; }

Else_sentence =
 token:(_* "else" _*)
 cons:Subsentence_then
  { return ` else {\n ${cons} }`; }

Jsblock = _* "{{" js:Jsblock_unclosed "}}" { return js.trim() }
Jsblock_unclosed = (!("}}") "\\"? .)+ { return text() }

Comentario = Comentario_unilinea / Comentario_multilinea

Comentario_unilinea = "//" (!(___) .)* ___ { return { comment: text() } }
Comentario_multilinea = "/*" (!("*/") .)* "*/" { return { comment: text() } }

_ = __ / ___ / Comentario
__ = "\t" / " "
___ = "\r\n" / "\r" / "\n"