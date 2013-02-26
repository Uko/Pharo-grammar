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

identifier: UALPHA UALPHANUMERIC*;

methodSequence: PERIOD* pragmas PERIOD* temporaries PERIOD* pragmas PERIOD* statements;

temporaries: '|' variable* '|';

statements: 
	expression (PERIOD* | (PERIOD+ statements)) |
	return PERIOD* |
	PERIOD*;

return: '^' expression;
	
expression: assignment* cascadeExpression;

assignment: variable ':=';
cascadeExpression: 'stub';

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
	nilLiteral |
	trueLiteral | 
	falseLiteral;
	
numberLiteral: (DIGITS 'r')? '-'? DIGITS (PERIOD DIGITS)? ('e' '-'? DIGITS)?;
stringLiteral: '\'' ('\'\'' | ~'\'')* '\'';
charLiteral: '$' .;
arrayLiteral: '#(' arrayItem ')';
byteLiteral: '#[' numberLiteral ']';
symbolLiteral: '#'+ symbol;
nilLiteral: 'nil';
trueLiteral: 'true';
falseLiteral: 'false';

symbol: unary | binary | multiword | stringLiteral;

symbolLiteralArray: symbol;
arrayLiteralArray: '(' arrayItem* ')';
byteLiteralArray: '[' arrayItem* ']';

PERIOD:	'.';
fragment ALPHA: 'a'..'z' | 'A'..'Z';
UALPHA: ALPHA | '_' ;
DIGIT:	'0'..'9';
DIGITS:	DIGIT+;
ALPHANUMERIC: ALPHA | DIGIT;
UALPHANUMERIC: UALPHA | DIGIT;
BINARYSYMBOL: '!'|'%'|'&'|'*'|'+'|','|'-'|'/'|'<'|'='|'>'|'?'|'@'|'\\'|'|'|'~';