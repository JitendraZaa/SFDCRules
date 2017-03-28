/**
 * @Author		:	Jitendra Zaa
 * @Date		:	25-March-2017
 * @Desc		:	Classes to implement BPM (Business Process Management ) rule engine
 * 	 		
 * @Known Issue	:	1. String values cannot have spaces 
 * 				:	3. All operators should have spaces , before and after, else it would raise an error.
 * 				:		There is no code written yet to auto format expression. 

Examples :
( Val1 == 1 && Val1 == 2 && Val1 == 3 ) && ( Val1 == 4 && Val1 == 5 && Val1 == 6 && Val1 == 7 ) && Val1 == 8  && Val1 == 900 && Val1 == 9 && ( Val1 == 10 && Val1 == 11 && Val1 == 12 ) && Val1 == 13 && Val1 == 14 &&  ( Val1 == 15 && Val1 == 16 ) 

Val1 == 900,990,897.32,-3322,345,3223,556,3334,66777,43456,6754,66778,433456,443335,78865,333455,778665,34556,4332,456777,57887,654446,1,45,544

Val1 == 900,990,897.32,-3322,345,3223,556,3334,66777,43456,6754,66778,433456,443335,78865,333455,778665,34556,4332,456777,57887,654446,1,45,544 && Val2 == 2 

Val1 == 900,990,897.32,-3322,345,3223,556,3334,66777,43456,6754,66778,433456,443335,78865,333455,778665,34556,4332,456777,57887,654446,1,45,544 && Val2 == 2 && Val3 == 3

Val1 == 900,990,897.32,-3322,345,3223,556,3334,66777,43456,6754,66778,433456,443335,78865,333455,778665,34556,4332,456777,57887,654446,1,45,544 && Val2 == 2 && Val3 == 3 && Val4 == 4

Val1 == 900,990,897.32,-3322,345,3223,556,3334,66777,43456,6754,66778,433456,443335,78865,333455,778665,34556,4332,456777,57887,654446,1,45,544 && Val2 == 2 && Val3 == 3 && Val4 == 4 && Val5 == 5

Val1 == 900,990,897.32,-3322,345,3223,556,3334,66777,43456,6754,66778,433456,443335,78865,333455,778665,34556,4332,456777,57887,654446,1,45,544 && Val2 == 2 && Val3 == 3 && Val4 == 4 && Val5 == 5  && Val6 == 6

Val1 == 900,990,897.32,-3322,345,3223,556,3334,66777,43456,6754,66778,433456,443335,78865,333455,778665,34556,4332,456777,57887,654446,1,45,544 && Val2 == 2 && Val3 == 3 && Val4 == 4 && Val5 == 5  && Val6 == 6 && Val7 == 7
 * */
@isTest
public class TestRuleEngineInBulk {
    
    static Map<String, String> initBindings() {
        Map<String, String> bindings = new Map<String, String>();
        //Create around 21k variables
        for(Integer i=0;i<20000;i++){
            bindings.put('Val'.toLowerCase()+i, String.valueOf(i)); 
        }         return bindings;
    } 
    
     static Operations initOperations() {
		Operations opObj = Operations.getInstance(); 
        opObj.registerOperation(OperationFactory.getInstance('&&'));
        opObj.registerOperation(OperationFactory.getInstance('==')); 
        opObj.registerOperation(OperationFactory.getInstance('!=')); 
        opObj.registerOperation(OperationFactory.getInstance('||'));
        opObj.registerOperation(OperationFactory.getInstance('('));
        opObj.registerOperation(OperationFactory.getInstance(')'));
        opObj.registerOperation(OperationFactory.getInstance('<'));
        opObj.registerOperation(OperationFactory.getInstance('<='));
        opObj.registerOperation(OperationFactory.getInstance('>'));
        opObj.registerOperation(OperationFactory.getInstance('>='));
        return opObj; 
	}
    
    public static testmethod void condition_TestBulk(){  
        
        Map<String, String> bindings = initBindings();
    	Operations opObj = initOperations();
        
        //declaration
        String expr ;
        Rule r = new Rule() ;
        Boolean retVal;
       
        //As number starts with 22k, it would be always false
        for(Integer i = 1; i<3300;i++){ 
        	expr  = 'Val1 == 900,990,897.32,-3322,345,3223,556,3334,66777,43456,6754,66778,433456,443335,78865,333455,778665,34556,4332,456777,57887,654446,1,45,544 && Val2 == 2 && Val3 == 3 && Val4 == 4 && Val5 == 5 && Val6 == 6 && Val7 == 7'; 
            //expr  = 'Val1 == 19000000 || Val1 == 19000000';
            r.setExpression(expr);    
            retVal = r.eval(bindings) ;
            System.assertEquals(true, retVal);    
        } 
    }

}