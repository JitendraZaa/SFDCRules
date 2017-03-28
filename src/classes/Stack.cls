public class Stack {
    
    private List<Expression> lstValues ;
    private Integer index = -1;
    
    public Stack(){
        lstValues = new List<Expression>();
        index = -1;
    }
    
    public Expression pop(){
        if(index <= -1){
            return null;
        } 
        else{
            Expression e = lstValues[index]; 
            lstValues.remove(index); 
            index--;
            return e;
        }
    }
    
    /**
     * used to look at the object at the top of this stack 
     * without removing it from the stack.
     * */
    public Expression peek(){
        if(index <= -1){
            return null;
        } 
        else{
            Expression e = lstValues[index]; 
        	return e;
        } 
    }
    
    public void push(Expression e){
        lstValues.add(e);
        index++;
    }
    
    public Boolean isEmpty(){
        if(index <= -1){
            return true;
        } 
        else{
            return false;
        } 
    }
    
    public void printStack(){
        System.debug(Logginglevel.ERROR,'----- stack print start ----- ');
        Integer tmpCounter = index;
        while(tmpCounter > -1){
            System.debug(Logginglevel.ERROR,lstValues[tmpCounter]);
            tmpCounter--;
        } 
        System.debug(Logginglevel.ERROR,'----- stack print finish ----- ');
    }
}