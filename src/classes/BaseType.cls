/**
 * @Author	:	Jitendra Zaa
 * @Date	:	25-March-2017
 * @Desc	:	Classes to implement BPM (Business Process Management ) rule engine 
 * */
public class BaseType implements Expression {
   
    public enum enumType {STRING_TYPE,INTEGER_TYPE,DECIMAL_TYPE,BOOLEAN_TYPE,RESULT_TYPE,LIST_DECIMAL}    
    public Object value;  
    public enumType valType;	
	public Set<Decimal> setDecimalval = null;
	

    public BaseType(Object value, enumType valType)
    {
		if(valType == enumType.LIST_DECIMAL){
			this.setDecimalval = new Set<Decimal>();
			for(String s : ((String)value).split(',')){
				this.setDecimalval.add(Decimal.valueOf(s));
			}
		}else{
			this.value = value; 
		} 
		this.valType = valType;
    }
	
	public Set<Decimal> getValuesSet(){
		if(valType == enumType.LIST_DECIMAL && setDecimalval != null){
			return setDecimalval;
		}
		return null;
	}

    public Object getValue()
    {
        /*
        if(getType() == enumType.STRING_TYPE){
            String s = String.valueOf(this.value) ; 
        } */
        return this.value;
    }
    
    public Boolean getBooleanValue() 
    { 
        return Boolean.valueOf(getValue());
    }

    public enumType getType() 
    {
        return this.valType;
    } 

    public static BaseType instantiate(String str)
    {
        if (str == null){
            throw new ExpressionException('The provided string must not be null');
        } 
		//is Base type all calculated and saved in static map
		BaseType ret = Rule.mpPreviousCalculatedBaseType.get(str);
		if(ret != null){
			return ret;
		}
        if (str.toLowerCase() == 'true' || str.toLowerCase() == 'false'){
			ret = new BaseType(Boolean.valueOf(str),BaseType.enumType.BOOLEAN_TYPE);
			Rule.mpPreviousCalculatedBaseType.put(str,ret);
            return ret; 
        } else  if (Pattern.matches('^[-+]?[0-9]+$', str) ){
            ret = new BaseType( Integer.valueOf(str),BaseType.enumType.INTEGER_TYPE);
			Rule.mpPreviousCalculatedBaseType.put(str,ret);
            return ret; 
        } else if (Pattern.matches('^[-+]?[0-9]*\\.?[0-9]+$', str) ) {
            ret = new BaseType(Decimal.valueOf(str),BaseType.enumType.DECIMAL_TYPE); 
			Rule.mpPreviousCalculatedBaseType.put(str,ret);
            return ret; 
        } else if (Pattern.matches('^(\\s*-?\\d+(\\.\\d+)?)(\\s*,\\s*-?\\d+(\\.\\d+)?)+$', str) ) {
            ret = new BaseType(str,BaseType.enumType.LIST_DECIMAL); 
			Rule.mpPreviousCalculatedBaseType.put(str,ret);
            return ret; 
        }else if (str.startsWith('\'') || str.startsWith('"') || str.isAlphanumeric() || str.isAlpha())
        {
            //remove first and last single quotes
            if( (str.startsWith('\'') && str.endsWith('\'')) || (str.startsWith('"') && str.endsWith('"')) ){
                str = str.substring(1, str.length()-1) ;
            }
			ret = new BaseType (str,BaseType.enumType.STRING_TYPE);
			Rule.mpPreviousCalculatedBaseType.put(str,ret);
            return ret; 
            
        } 
        return null;
    }
}