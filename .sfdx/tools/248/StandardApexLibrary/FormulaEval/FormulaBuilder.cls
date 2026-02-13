global class FormulaBuilder {
	global formulaeval.FormulaInstance build() { }
	global static formulaeval.FormulaBuilder builder() { }
	global Object clone() { }
	global formulaeval.FormulaBuilder treatNumericNullAsZero(Boolean treatNumericNullAsZero) { }
	global formulaeval.FormulaBuilder withFormula(String formulaText) { }
	global formulaeval.FormulaBuilder withGlobalVariables(List<formulaeval.FormulaGlobal> formulaGlobals) { }
	global formulaeval.FormulaBuilder withReturnType(formulaeval.FormulaReturnType returnType) { }
	global formulaeval.FormulaBuilder withType(System.Type contextType) { }

}