/**
 * @Author	:	Jitendra Zaa
 * @Date	:	25-March-2017
 * @Desc	:	Classes to implement BPM (Business Process Management ) rule engine
 * 	 		:	This class will return the appropriate implementation of Operations based on symbol
 * */
public class OperationFactory {
 
    public static Operation getInstance(String symbol){
        if(symbol == 'AND' || symbol == '&&'){
            return new AndOperation(symbol);
        }else if(symbol == '!='){
            return new NotOperation(symbol);  
        }else if(symbol == '=' || symbol == '=='){ 
            return new EqualsOperation(symbol);
        } else if(symbol == 'OR' || symbol == '||'){
            return new OROperation(symbol);
        } else if(symbol == '(' ){
            return new OparenthesisOperation();
        } else if(symbol == ')' ){
            return new CparenthesisOperation();
        } else if(symbol == '<' ){
            return new LessOperation(symbol);
        } else if(symbol == '<=' ){
            return new LessEqualOperation(symbol);
        } else if(symbol == '>' ){
            return new GreaterOperation(symbol);
        } else if(symbol == '>=' ){
            return new GreaterEqualOperation(symbol);
        } 
        return null;
    }
}