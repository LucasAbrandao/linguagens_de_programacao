package lexical;

public class Token {

    public static enum Type {
        // SPECIALS
        UNEXPECTED_EOF,
        INVALID_TOKEN,
        END_OF_FILE,
    
        // Symbols.
        OPEN_PAR,          // (
        CLOSE_PAR,         // )

        // Operators.
        LOWER_THAN,        // <
        GREATER_THAN,      // >
        NOT,               // !
        DEFINED,

        // KEYWORDS
        DEFINE,
        UNDEF,
        ERROR,
        INCLUDE,
        IFDEF,
        IFNDEF,
        IF,
        ELIF,
        ELSE,
        ENDIF,
    
        // OTHERS
        NAME,          // identifier
        NUMBER,        // integer
        TEXT           // string
    };

    public String lexeme;
    public Type type;
    public int line;

    public Token(String lexeme, Type type) {
        this.lexeme = lexeme;
        this.type = type;
        this.line = 0;
    }

    public String toString() {
        return new StringBuffer()
            .append("(\"")
            .append(this.lexeme)
            .append("\", ")
            .append(this.type)
            .append(", ")
            .append(this.line)
            .append(")")
            .toString();
    }

}
