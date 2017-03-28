/**
 * @Author	:	Jitendra Zaa
 * @Date	:	25-March-2017
 * @Desc	:	Classes to implement BPM (Business Process Management ) rule engine
 * 	 		:	Simple Marker interface to achieve run time polymorphism
 * */
public class Operations {
     
	private static Operations instance = null;  
    private final Map<String, Operation> mpOperations = new Map<String, Operation>();
    
    public static Operations getInstance(){
        if(instance == null){
            instance = new Operations();
        }
        return instance;
    }
 
    public void registerOperation(Operation op) 
    {
        if (!mpOperations.containsKey(op.getSymbol())) 
            mpOperations.put(op.getSymbol(), op);
    }

    public Operation getOperation(String symbol)
    {
        return this.mpOperations.get(symbol); 
    }
 
}