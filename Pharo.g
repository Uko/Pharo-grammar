grammar Pharo;

method:	methodDeclaration methodSequence;

methodDeclaration: keywordMethod | unaryMethod | binaryMethod;

keywordMethod: (keyword variable)+;
unaryMethod: identifier;
binaryMethod: binary variable;

keyword: identifier ':';
variable: identifier;

unary: identifier ~':';
binary: (BINARYSYMBOL)+;
multiword: keyword+;

identifier: UNDERSCORE_ALPHA UNDERSCORE_ALPHANUMERIC*;

methodSequence: PERIOD* pragmas PERIOD* temporaries PERIOD* pragmas PERIOD* statements;

temporaries: '|' variable* '|';

statements: 
	expression (PERIOD* | (PERIOD+ statements)) |
	return PERIOD* |
	PERIOD*;

return: RETURN expression;
	
expression: assignment* cascadeExpression;

assignment: variable ASSIGN;

cascadeExpression: keywordExpression cascadeMessage*;

cascadeMessage: ';' message;

message:
	keywordMessage |
	binaryMessage |
	unaryMessage;

keywordExpression: binaryExpression keywordMessage?;
keywordMessage: (keyword binaryExpression)+;

binaryExpression: unaryExpression binaryMessage*;
binaryMessage: binary unaryExpression;

unaryExpression: primary unaryMessage*;
unaryMessage: unary;

primary: literal | variable | block | parens | array;

parens: '(' expression ')';
array: '{' expression (PERIOD expression)* PERIOD'}';

block: '[' blockBody ']';
blockBody: blockArguments? sequence;
blockArguments: blockArgument+ '|';
blockArgument: ':' variable;

sequence: temporaries PERIOD* statements;

pragmas: pragma*;
pragma:  '<' pragmaMessage '>';
pragmaMessage: keywordPragma | unaryPragma | binaryPragma;

keywordPragma: (keyword arrayItem)+;
unaryPragma: identifier;
binaryPragma:  binary arrayItem;

arrayItem: literal | symbolLiteralArray | arrayLiteralArray | byteLiteralArray;

literal:
	numberLiteral |
	stringLiteral |
	charLiteral |
	arrayLiteral |
	byteLiteral |
	symbolLiteral |
	NIL |
	TRUE | 
	FALSE;
	
numberLiteral: (DIGITS 'r')? '-'? DIGITS (PERIOD DIGITS)? ('e' '-'? DIGITS)?;
stringLiteral: '\'' ('\'\'' | ~'\'')* '\'';
charLiteral: '$' .;
arrayLiteral: '#(' arrayItem ')';
byteLiteral: '#[' numberLiteral ']';
symbolLiteral: '#'+ symbol;

symbol: unary | binary | multiword | stringLiteral;

symbolLiteralArray: symbol;
arrayLiteralArray: '(' arrayItem* ')';
byteLiteralArray: '[' arrayItem* ']';

PERIOD:	'.';
ASSIGN: ':=';
RETURN: '^';
NIL: 'nil';
TRUE: 'true';
FALSE: 'false';
fragment ALPHA: 'a'..'z' | 'A'..'Z';
fragment UNDERSCORE_ALPHA: ALPHA | '_' ;
fragment DIGIT:	'0'..'9';
DIGITS:	DIGIT+;
ALPHANUMERIC: ALPHA | DIGIT;
UNDERSCORE_ALPHANUMERIC: UNDERSCORE_ALPHA | DIGIT;
BINARYSYMBOL: '!'|'%'|'&'|'*'|'+'|','|'-'|'/'|'<'|'='|'>'|'?'|'@'|'\\'|'|'|'~';