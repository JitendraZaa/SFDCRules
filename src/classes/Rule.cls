/**
	 * @Author	:	Jitendra Zaa
	 * @Date	:	25-March-2017
	 * @Desc	:	Classes to implement BPM (Business Process Management ) rule engine
	 * 	 		:	Simple Marker interface to achieve run time polymorphism
	 * */
	public class Rule { 
		private String expressionString ; 
		private static BaseType falseBaseType = null;
		private static BaseType trueBaseType = null;
		
		public static Map<String,BaseType> mpPreviousCalculatedBaseType = new Map<String,BaseType>();
		
		public Rule setExpression(String expressionString )
		{
			this.expressionString = expressionString;  
			return this;
		} 
		
		public static BaseType getResultBaseType(Boolean val){
			if(falseBaseType == null){
				falseBaseType = new BaseType(false , BaseType.enumType.RESULT_TYPE) ;
			}
			if(trueBaseType == null){
				trueBaseType = new BaseType(true , BaseType.enumType.RESULT_TYPE) ;
			}
			if(val){
				return trueBaseType;
			}
			return 	falseBaseType;
		}

		public boolean eval(Map<String, Object> bindings)
		{
			//Datetime startTime = Datetime.now();
			boolean eval = false; 
				Operations opObj = Operations.getInstance();
				Operation Oparenthesis = null;
				Operation op = null;
				Stack  st = new Stack(); 
				
				String[] tokens = expressionString.split('\\s');
				
				Expression stackElement = null;
				Expression chkOpeningBracket = null;
				BaseType leftVal = null;
				BaseType rightVal = null;
				Operation opertn = null;
				BaseType resType = null;
				Boolean res = null;
				 
				//Datetime stStTime = Datetime.now();
				for (Integer i=0; i < tokens.size(); i++)
				{
					//System.debug(Logginglevel.ERROR,'**NEXT TOKEN '+tokens[i]);
					op = opObj.getOperation(tokens[i]);
					//System.debug(Logginglevel.ERROR,op);
					if ( op != null )
					{
						if(tokens[i] == '('){ 
							st.push(op);
						}else if( tokens[i] == '&&' || tokens[i] == '||' ){ 
							st.push(op);
						} 
						else if(tokens[i] == ')'){ 
							//iterate till openeing parenthesis found
							Oparenthesis = null;
							while(Oparenthesis == null){
								stackElement = st.pop();
								
								// if Next character is closing bracket, 
								// that means existing element is already result
								chkOpeningBracket = st.peek();
								//Found opening bracket
								if(chkOpeningBracket instanceOf OparenthesisOperation ){ 
									Oparenthesis = (OparenthesisOperation) chkOpeningBracket; 
									st.pop(); 
									//push result back so that can be used in remainig portion
									st.push(stackElement);
									continue;
								} 
								
								rightVal = (BaseType) stackElement; 
								//We already checked that if its opening bracket, so safe to pop
								opertn = (Operation) st.pop(); 
								 
								//We already checked that if its opening bracket, so safe to pop
								stackElement = st.pop();
								leftVal = (BaseType) stackElement;
								
								res = opertn.resolve(leftVal,rightVal);    
								
								resType = Rule.getResultBaseType(res); 
								 
								stackElement = st.peek();
								//Found opening bracket
								if(stackElement instanceOf OparenthesisOperation){ 
									Oparenthesis = (OparenthesisOperation) stackElement;
									st.pop();
								}
								st.push(resType);
								//System.debug(Logginglevel.ERROR,'----- 73');
								//st.printStack();
							} 
						}
						else if( tokens[i] == '==' || 
								tokens[i] == '!=' || tokens[i] == '<' || tokens[i] == '<=' || 
								tokens[i] == '>' || tokens[i] == '>='){   
							//System.debug(tokens[i]);	 
							Object obj = bindings.get(tokens[i-1].toLowerCase()); 
							//System.debug(Logginglevel.ERROR,'*****'+obj);
							//System.debug(Logginglevel.ERROR,'*** FOUND **'+tokens[i-1]);
							if(obj != null){
								leftVal = BaseType.instantiate((String)obj); 
								rightVal = BaseType.instantiate(tokens[i+1]);
								//System.debug(Logginglevel.ERROR,'*** FOUND right value**'+tokens[i+1]); 
								//System.debug(Logginglevel.ERROR,'*** FOUND RiGHT BaseType**'+rightVal); 
								res = op.resolve(leftVal,rightVal);
								//System.debug('** Res ***'+res); 
								
								resType = Rule.getResultBaseType(res);  
								 
								//System.debug('** Going to push result ***');
								st.push(resType);
								//System.debug(Logginglevel.ERROR,'----- 91');
								//st.printStack();
							}  
						}
					} 
				}
				//Datetime endStTime = Datetime.now();
				//System.debug(Logginglevel.ERROR,'--------------- Finished in ms '+decimal.valueOf(endStTime.getTime() - stStTime.getTime()));
				//System.debug('----- 97'); 
				//st.printStack();
				Expression sEle = st.peek();
				//Found opening bracket, pop it
				if(sEle instanceOf OparenthesisOperation){ 
					st.pop();
				}
								
				//All tokens finish, now process stack 
				While(!st.isEmpty()){ 
				//System.debug(Logginglevel.ERROR,'----- 107');
					//st.printStack();
					stackElement = st.pop();
					if(st.isEmpty()){
						BaseType finalResult = null; 
						finalResult = (BaseType) stackElement;
						eval = Boolean.valueOf(finalResult.getValue());
					}else{ 
					
						rightVal = (BaseType) stackElement;
						opertn = (Operation) st.pop();
								
						stackElement = st.pop();
						leftVal = (BaseType) stackElement; 
						res = opertn.resolve(leftVal,rightVal);   
								
						resType = Rule.getResultBaseType(res); 
						 
						stackElement = st.peek();
						//Found opening bracket, pop it
						if(stackElement instanceOf OparenthesisOperation){ 
							st.pop();
						}
						st.push(resType); 
						//System.debug(Logginglevel.ERROR,'----- 132');
						//st.printStack();
					}
				} 
			//Datetime endTime = Datetime.now();
			//System.debug(Logginglevel.ERROR,'--------------- Finished in ms '+decimal.valueOf(endTime.getTime() - startTime.getTime()));
			return eval;
		}
	}