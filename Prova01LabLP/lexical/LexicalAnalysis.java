package lexical;

import java.io.InputStream;
import java.io.PushbackInputStream;
import java.util.HashMap;
import java.util.Map;

public class LexicalAnalysis implements AutoCloseable {

    private int line;
    private PushbackInputStream input;
    private static Map<String, Token.Type> keywords;

    static {
        keywords = new HashMap<String, Token.Type>();
        // Symbols.
        keywords.put("(", Token.Type.OPEN_PAR);
        keywords.put(")", Token.Type.CLOSE_PAR);
        
        // Operators.

        keywords.put("<", Token.Type.LOWER_THAN);
        keywords.put(">", Token.Type.GREATER_THAN);
        keywords.put("!", Token.Type.NOT);
        keywords.put("defined", Token.Type.DEFINED);


        // Keywords.
        keywords.put("#define", Token.Type.DEFINE);
        keywords.put("#undef", Token.Type.UNDEF);
        keywords.put("#error", Token.Type.ERROR);
        keywords.put("#include", Token.Type.INCLUDE);
        keywords.put("#ifdef", Token.Type.IFDEF);
        keywords.put("#ifndef", Token.Type.IFNDEF);
        keywords.put("#if", Token.Type.IF);
        keywords.put("#elif", Token.Type.ELIF);
        keywords.put("#else", Token.Type.ELSE);
        keywords.put("#endif", Token.Type.ENDIF);
    }

    public LexicalAnalysis(InputStream is) {
        input = new PushbackInputStream(is);
        line = 1;
    }

    public void close() {
        try {
            input.close();
        } catch (Exception e) {
            throw new LexicalException("Unable to close file");
        }
    }

    public int getLine() {
        return this.line;
    }

    public Token nextToken() {
        Token token = new Token("", Token.Type.END_OF_FILE);

        int state = 1;
        while (state != 4 && state != 6 && state != 9) {
            int c = getc();
            // System.out.printf("  [%02d, %03d ('%c')]\n",
            //     state, c, (char) c);

            switch (state) {
                case 1:
                    if(c == '\t' || c == '\r' || c == '\n' || c == ' '){
                        state = 1;
                    }
                    else if(c == '#'){
                        state = 7;
                        token.lexeme += (char) c;
                    }
                    else if(c == '_' || c == '.' || Character.isLetter(c)){
                        state = 5;
                        token.lexeme += (char) c;
                    }
                    else if(c == '!' || c == '<' || c == '>' || c == '(' || c == ')'){
                        state = 6;
                        token.lexeme += (char) c;
                    }
                    else if(Character.isDigit(c)){
                        state = 2;
                        token.lexeme += (char) c;
                    }
                    else if(c == '"'){
                        state = 3;
                    } else if (c == -1) {
                        state = 4;
                        token.type = Token.Type.END_OF_FILE;

                    } else {
                        state = 4;
                        token.lexeme += (char) c;
                        token.type = Token.Type.INVALID_TOKEN;
                    }
                    break;

                case 2:
                    if(Character.isDigit(c)){
                        state = 2;
                        token.lexeme += (char) c;
                    }
                    else{
                        state = 4;
                        ungetc(c);
                        token.type = Token.Type.NUMBER;
                    }
                    break;

                case 3:
                    if(c != '"'){
                        state = 3;
                        token.lexeme += (char) c;
                    } else if(c == -1){
                        state = 14;
                        token.type = Token.Type.UNEXPECTED_EOF;
                    }
                    else{
                        state = 4;
                        token.type = Token.Type.TEXT;
                    }
                    break;

                case 5:
                    if(c == '_' || c == '.' || Character.isLetter(c) || Character.isDigit(c)){
                        state = 5;
                        token.lexeme += (char) c;
                    }
                    else{
                        state = 6;
                        ungetc(c);
                    }
                    break;

                case 7:
                    if(c == '\t' || c == ' '){
                        state = 7;
                    }
                    else{
                        state = 8;
                        ungetc(c);
                    }
                    break;

                case 8:
                    if(Character.isLetter(c)){
                        state = 8;
                        token.lexeme += (char) c;
                    }
                    else{
                        state = 9;
                        ungetc(c);
                    }
                    break;

                default:
                    throw new RuntimeException("Unreachable");
            }
        }

        if (state == 9){
            token.type = keywords.containsKey(token.lexeme) ?
                keywords.get(token.lexeme) : Token.Type.INVALID_TOKEN;
        }

        if(state == 6){
            token.type = keywords.containsKey(token.lexeme) ?
                keywords.get(token.lexeme) : Token.Type.NAME;
        }

        token.line = this.line;

        return token;
    }
    private int getc() {
        try {
            return input.read();
        } catch (Exception e) {
            throw new LexicalException("Unable to read file");
        }
    }

    private void ungetc(int c) {
        if (c != -1) {
            try {
                input.unread(c);
            } catch (Exception e) {
                throw new LexicalException("Unable to ungetc");
            }
        }
    }

}
