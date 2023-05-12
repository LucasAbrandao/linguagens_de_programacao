package syntatic;

import lexical.LexicalAnalysis;
import lexical.Token;
import static lexical.Token.Type.*;

public class SyntaticAnalysis {

    private LexicalAnalysis lex;
    private Token previous;
    private Token current;
    private Token next;

    public SyntaticAnalysis(LexicalAnalysis lex) {
        this.lex = lex;
        this.previous = null;
        this.current = lex.nextToken();
        //this.next = lex.nextToken();       
    }

    public void process() {
        procCODE();
        eat(END_OF_FILE);
    }

    private void advance() {
        //System.out.println("Found " + current);
        previous = current;
        //current = next;
        current = lex.nextToken();
    }

    private void eat(Token.Type type) {
        if (type == current.type) {
            advance();
        } else {
            //System.out.println("Expected (..., " + type + ", ..., ...), found " + current);
            reportError();
        }
    }

    private boolean check(Token.Type ...types) {
        for (Token.Type type : types) {
            if (current.type == type)
                return true;
        }

        return false;
    }

    private void reportError() {
        String reason;
        switch (current.type) {
            case INVALID_TOKEN:
                reason = String.format("Lexema inválido [%s]", current.lexeme);
                break;
            case UNEXPECTED_EOF:
            case END_OF_FILE:
                reason = "Fim de arquivo inesperado";
                break;
            default:
                reason = String.format("Lexema não esperado [%s]", current.lexeme);
                break;
        }

        throw new SyntaticException(current.line, reason);
    }


    // <code> ::= { <cmd> }
    private void procCODE() {
        while (check(DEFINE,UNDEF,
        ERROR, INCLUDE, IFDEF, 
        IFNDEF, IF)) {
            procCMD();
        }

    }

    // <cmd> ::= <if> | <ifdef> | <ifndef> | <include> | <define> | <undef> | <error>
    private void procCMD() {
        
        if (check(IF)) {
            procIF();
        } else if (check(IFDEF)) {
            procIFDEF();
        } else if (check(IFNDEF)) {
            procIFNDEF();
        } else if (check(INCLUDE)) {
            procINCLUDE();
        } else if (check(DEFINE)) {
            procDEFINE();
        } else if (check(UNDEF)) {
            procUNDEF();
        } else{
            procERROR();
        }

        
    }

    // <define> ::= '#define' <name> [ <value> | <string> ]
    private void procDEFINE(){
        
        eat(DEFINE);

        procNAME();

        if (check(NUMBER)){
            procVALUE();

        }else if (check(TEXT)){
            procSTRING();
        }

    }

    // <undef> ::= '#undef' <name>
    private void procUNDEF(){
        eat(UNDEF);
        procNAME();

    }

    // <error> ::= '#error' <string>
    private void procERROR(){
        eat(ERROR);
        procSTRING();

    }
    
    // <include> ::= '#include' (<string> | '<' <nome> '>')
    private void procINCLUDE(){
        eat(INCLUDE);
        if(check(TEXT)){
            procSTRING();
        }
        else{
            eat(LOWER_THAN);
            procNAME();
            eat(GREATER_THAN);
        }


    }

    // <ifdef> ::=  '#ifdef' <nome> <macrosIF>  '#endif'
    private void procIFDEF(){
        eat(IFDEF);
        procNAME();
 
        procMACROSIF();

        eat(ENDIF);

    }

    // <ifndef> ::= '#ifndef' <nome> <macrosIF> '#endif'
    private void procIFNDEF(){
        eat(IFNDEF);
        procNAME();

        procMACROSIF();
  
        eat(ENDIF);

    }

    // <if> ::=  '#if' <args> <macrosIF> '#endif'
    private void procIF(){
        eat(IF);
        procARGS();

        procMACROSIF();

        eat(ENDIF);

    }

    // <args> ::= [ '!' ] 'defined' '(' <nome> ')'
    private void procARGS(){
        if(check(NOT)){
            eat(NOT);
        }
        eat(DEFINED);

        eat(OPEN_PAR);
        procNAME();
        eat(CLOSE_PAR);

    }

    // <macrosIF> ::= <code> { <elif> } [ <else> ]
    private void procMACROSIF(){
        procCODE();

        while(check(ELIF)){
            procELIF();

        }
        if(check(ELSE)){
            procELSE();

        }
    }

    // <elif> ::= '#elif' <args> <macrosIF>
    private void procELIF(){
        eat(ELIF);
        procARGS();
        procMACROSIF();

    }

    // <else> ::= '#else' <code>
    private void procELSE(){
        eat(ELSE);

        procCODE();

    }

    private void procVALUE() {
        eat(NUMBER);
    }

    private void procSTRING() {
        eat(TEXT);
    }

    private void procNAME() {
        eat(NAME);
    }

}
