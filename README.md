# SFDCRules
Simple yet powerful Rule Engine for Salesforce - SFDCRules

![SFDC Rule Engine](http://www.jitendrazaa.com/blog/wp-content/uploads/2017/03/SFDCRules-1024x447.jpg)

#### [Read Blog post here](http://www.jitendrazaa.com/blog/salesforce/sfdcrules-simple-yet-powerful-rule-engine-for-salesforce/)

## How to use SFDCRules
* Define set of all allowed operators. We can move this step to some helper method to skip this step
* Define set of binding values, which will replace variable or merge fields in rule
* call eval() method of Rule class and it will return Boolean value indicating that rule evaluated is true or false
* 
## Example
```java
//Define set of all allowed operators
//Mostly we don't need to change this, it can be added in setup method
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

//Define bindings, which will replace variables while
//evaluating rules		
Map<String, String>bindings = new Map<String, String>();
bindings.put('Case.OwnerName__c'.toLowerCase(), 'Jitendra');   
bindings.put('Case.IsEscalated'.toLowerCase(), 'false');  
bindings.put('Case.age_mins__c'.toLowerCase(), '62'); 

//Define rule
String expr  = 'Case.OwnerName__c == Minal || ( Case.age_mins__c &lt; 75 &amp;&amp; Case.IsEscalated == false )' ; 

//Initialize Rule Engine
Rule r = new Rule().setExpression(expr);   

//Evaluate rule with Binding values
Boolean retVal = r.eval(bindings) ;

//Check if expected result is correct
System.assertEquals(true, retVal);  
```
## Capabilities, Considerations and Limitations
* All Operators, variables and values must be separated by one or more spaces. Spaces are used to tokenize expression. We fix this by introducing some normalizing method however it would cost some CPU time.
* Instead of writing *Value1 == 100* OR *Value1 == 200* we can use comma separated values. So, it can be written as *Value1 == 100,200*. 
Comma separated value is only supported for Integer and Decimal datatype, not for Strings.
* Arithmetic operations like *Value1 < 2*3* not supported.
* Binding variables must be used as lower case.
* Spaces in string values are not allowed. So, *Value1 == ‘My Bad’* is not supported.
* Code does not support short circuit execution of logic yet.
    *  Example : *Value1 == 100 && Value2 == 400* . In this case, if first condition fails, we should not evaluate second, as result will always be false.

## Performance
We are talking about lots of string manipulations and comparison in **Salesforce BRMS rule engine (SFDCRules)**. If its not used wisely, chances of hitting **CPU limit** are high. Lengthy expression size will result in using more CPU time. In Synchronous Apex, we get **10 sec** before hitting CPU time limit error. Speaking about performance, around **7k expressions with 3 to 4 conditions** can be evaluated before hitting 10 sec.
