grammar Pharo;

method:	methodDeclaration methodSequence;

methodDeclaration: keywordMethod | unaryMethod | binaryMethod;

keywordMethod: (keyword variable)+;
unaryMethod: identifier;
binaryMethod: binary variable;

keyword: identifier COLON;
variable: identifier;

unary: identifier ~COLON;
binary: (BINARYSYMBOL)+;
multiword: keyword+;

identifier: UNDERSCORE_ALPHA UNDERSCORE_ALPHANUMERIC*;

methodSequence: PERIOD* pragmas PERIOD* temporaries PERIOD* pragmas PERIOD* statements;

temporaries: PIPE variable* PIPE;

statements: 
	expression (PERIOD* | (PERIOD+ statements)) |
	return PERIOD* |
	PERIOD*;

return: RETURN expression;
	
expression: assignment* cascadeExpression;

assignment: variable ASSIGN;

cascadeExpression: keywordExpression cascadeMessage*;

cascadeMessage: SEMICOLON message;

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

parens: LPAREN expression RPAREN;
array: LCURLY expression (PERIOD expression)* PERIOD RCURLY;

block: LBRACKET blockBody RBRACKET;
blockBody: blockArguments? sequence;
blockArguments: blockArgument+ PIPE;
blockArgument: COLON variable;

sequence: temporaries PERIOD* statements;

pragmas: pragma*;
pragma:  LT pragmaMessage GT;
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
	
numberLiteral: (DIGITS RADIX)? MINUS? DIGITS (PERIOD DIGITS)? (EXP MINUS? DIGITS)?;
stringLiteral: QUOTE (QUOTE QUOTE | ~QUOTE)* QUOTE;
charLiteral: DOLAR .;
arrayLiteral: BEGIN_ARRAY arrayItem RPAREN;
byteLiteral: BEGIN_BIN_ARRAY numberLiteral RBRACKET;
symbolLiteral: HASH+ symbol;

symbol: unary | binary | multiword | stringLiteral;

symbolLiteralArray: symbol;
arrayLiteralArray: RPAREN arrayItem* RPAREN;
byteLiteralArray: LBRACKET arrayItem* RBRACKET;

PERIOD:	'.';
ASSIGN: ':=';
COLON: ':';
SEMICOLON: ';';
DOLAR: '$';
RETURN: '^';
QUOTE: '\'';
NIL: 'nil';
TRUE: 'true';
FALSE: 'false';
PIPE: '|';
LT: '<';
GT: '>';
HASH: '#';
BEGIN_ARRAY: HASH LPAREN;
LPAREN: '(';
RPAREN: ')';
BEGIN_BIN_ARRAY: HASH LPAREN;
LBRACKET: ']';
RBRACKET: '[';
LCURLY: '{';
RCURLY: '}';
MINUS: '-';
RADIX: 'r';
EXP: 'e';
fragment ALPHA: 'a'..'z' | 'A'..'Z';
fragment UNDERSCORE_ALPHA: ALPHA | '_' ;
fragment DIGIT:	'0'..'9';
DIGITS:	DIGIT+;
ALPHANUMERIC: ALPHA | DIGIT;
UNDERSCORE_ALPHANUMERIC: UNDERSCORE_ALPHA | DIGIT;
BINARYSYMBOL: '!'|'%'|'&'|'*'|'+'|','|'-'|'/'|'<'|'='|'>'|'?'|'@'|'\\'|'|'|'~';