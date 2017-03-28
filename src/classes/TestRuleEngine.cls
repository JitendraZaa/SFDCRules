/**
 * @Author		:	Jitendra Zaa
 * @Date		:	25-March-2017
 * @Desc		:	Classes to implement BPM (Business Process Management ) rule engine
 * 	 		
 * @Known Issue	:	1. String values cannot have spaces 
 * 				:	3. All operators should have spaces , before and after, else it would raise an error.
 * 				:		There is no code written yet to auto format expression. 
 * */
@isTest
public class TestRuleEngine { 
    
    static Map<String, String> initBindings() {
        Map<String, String> bindings = new Map<String, String>();
        bindings.put('Val1'.toLowerCase(), '100');   
        bindings.put('Val2'.toLowerCase(), '200');  
        bindings.put('Val3'.toLowerCase(), '300');
        bindings.put('Val4'.toLowerCase(), 'RuleEngine');
        bindings.put('Val5'.toLowerCase(), 'false');
        return bindings;
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
     
    public static testmethod void condition_Test_All_Operators(){  
        
        Map<String, String> bindings = initBindings();
    	Operations opObj = initOperations();
        
        //declaration
        String expr ;
        Rule r = new Rule() ;
        Boolean retVal;
        
        expr  = 'Val1 != 800' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(true, retVal); 
        
        expr  = 'Val1 != 800 ||     ( Val2 != 200 &&       Val3 != 200 )' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ; 
        System.assertEquals(true, retVal);  
        
        expr  = 'Val1 < 110' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(true, retVal); 
        
        expr  = 'Val1 <= 100' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(true, retVal); 
        
        expr  = 'Val2 > 110.5' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(true, retVal); 
        
        expr  = 'Val2 >= 110' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(true, retVal); 
        
        expr  = 'Val3 == 300' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(true, retVal); 
        
        expr  = 'Val3 == 300.0' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(true, retVal);
        
        expr  = 'Val4 == RuleEngine' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(true, retVal);
        
        expr  = 'Val4 == "ruleengine"' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(true, retVal);
        
        expr  = 'Val4 == ruleEngine' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(true, retVal);
        
        expr  = 'Val5 == false' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(true, retVal);
        
        //As below comparision is not valid, return false
        expr  = 'Val5 > false' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(false, retVal);
        
        //As below comparision is not valid, return false
        expr  = 'Val5 >= false' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(false, retVal);
        
        //As below comparision is not valid, return false
        expr  = 'Val5 < false' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(false, retVal);
        
        //As below comparision is not valid, return false
        expr  = 'Val5 <= false' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(false, retVal);
        
        expr  = 'Val1 == 100 || ( Val2 == 300 && Val3 == 200 && Val4 == ruleEngine )' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(true, retVal);
        
        expr  = 'Val1 == 300 || ( Val2 == 300 && Val3 == 200 && Val4 == ruleEngine )' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(false, retVal);
        
        expr  = 'Val1 == 300 || ( Val2 == 300 ) && ( Val3 == 200 ) && ( Val4 == ruleEngines )' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(false, retVal);
        
        expr  = 'Val1 == 300 || ( ( Val2 == 300 ) && ( Val3 == 200 ) && ( Val4 == ruleEngines && Val1 == 120 ) ) || Val1 == 100' ; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(true, retVal);
        
        expr  = 'Val1 == 1500 || Val1 == 1400 || Val1 == 1300 || Val1 == 1200 || Val1 == 1100 || Val1 == 1200 || Val1 == 1100 || Val1 == 1000'+
            ' || Val1 == 900 || Val1 == 800 || Val1 == 700 || Val1 == 600 || Val1 == 500 || Val1 == 400 || Val1 == 300 || Val1 == 200 || Val1 == 100'; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(true, retVal);
        
        expr  = 'Val1 == 1500 && Val1 == 1400 && Val1 == 1300 && Val1 == 1200 && Val1 == 1100 && Val1 == 1200 && Val1 == 1100 && Val1 == 1000'+
            ' && Val1 == 900 && Val1 == 800 && Val1 == 700 && Val1 == 600 && Val1 == 500 && Val1 == 400 && Val1 == 300 && Val1 == 200 && Val1 == 100'; 
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(false, retVal);
    }
    
    public static testmethod void debugTest(){
        Map<String, String> bindings = initBindings();
    	Operations opObj = initOperations();
        
        //declaration
        String expr ;
        Rule r = new Rule() ;
        Boolean retVal;
        
        expr  = 'Val4 == "ruleengine"' ;
        r.setExpression(expr);   
        retVal = r.eval(bindings) ;
        System.assertEquals(true, retVal);
    }
    

}