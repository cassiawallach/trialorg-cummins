/* Check if Dep Logic's filter logic text is valid */
function validateFilterLogic(filterText,objectRows){
	
	var isValid = true;
	var errors = [];
	var value = filterText;
	if(_comparingAgainstNull(objectRows)){
		isValid = false;
		errors.push('Only the Query Operators of "equals" or "not equal to" can be used to compare against a null (i.e. empty) Query Value.');
	}	
	if(value !== null && value !== '' && value !== undefined){
		if(!_parenthesisAreBalanced(value)){
			isValid = false;
			errors.push('Please check your parenthesis');
		}
		if(!_checkFormulaWords(value)){
			isValid = false;
			errors.push('Invalid words in the formula');
		}
		if(!_verifyNumbersExist(value, objectRows)){
			isValid = false;
			errors.push('Invalid row numbers or logic does not include all values');
		}
		if(!_verifyNoSpaceBtwnNum(value)){
			isValid = false;
			errors.push('Missing an "AND" or "OR" between numbers');
		}
		if(!_verifyNoMultipleSpaces(value)){
			isValid = false;
			errors.push('There cannot be more than one space between characters');
		}
		if(!_verifyNoNested(value)){
			isValid = false;
			errors.push('Nested Formulas are not allowed');
		}
		if(!_verifyNoORInParenthesis(value)){
			isValid = false;
			errors.push('The OR operator is not allowed in parenthesis');
		}
		if(!_verifyNoANDInBetweenParenthesis(value)){
			isValid = false;
			errors.push('The AND operator is not allowed between parenthesis');
		}
		if(!_verifyFormulaEndsProperly(value)){
			isValid = false;
			errors.push('The value must end with a number or )');
		}

		if(!_verifyNoMixedOperatorsIfNoParens(value)){
			isValid = false;
			errors.push('The AND and OR operators cannot both exist without parenthesis');
		}

		if(!_verifyFormulaBeginsProperly(value)){
			isValid = false;
			errors.push('The value must begin with a number or (');
		}
		
		if(!_verifyOROutsideOfParens(value)){
			isValid = false;
			errors.push('Mixing OR and AND statements');
		}
		if(!_verifyOperatorBeforeAndAfterParens(value)) {
			isValid = false;
			errors.push('There must be an operator between parentheses and the previous / next statement');
		}
		if(!_verifyElemBetweenOperators(value)) {
			isValid = false;
			errors.push('There must be a number or parenthesis after an operator (AND, OR)');
		}
		if(!_verifyNumAfterParen(value)) {
			isValid = false;
			errors.push('Parentheses must open and close with a number');
		}
	}
	else if(objectRows.length > 1){
		isValid = false;
		errors.push('Filter logic field is required if there is more than 1 conditional row');
	}
	
	return {'isValid':isValid,'errors':errors};
}

// verifies there is not both an OR and AND if there are no parens ie. (1 AND 2 OR 3)
function _verifyNoMixedOperatorsIfNoParens(filterValue) {
	if(filterValue.indexOf('(') === -1
	&& filterValue.toUpperCase().indexOf('OR') > -1
	&& filterValue.toUpperCase().indexOf('AND') > -1){
		return false;
	}
	return true;
}

//verifies there is not an OR in between parenthesis i.e (1 OR 2)
function _verifyNoORInParenthesis(filterValue){
	if(filterValue.indexOf('(') != -1){
		var regExp = /\(([^)]+)\)/g;
		var matches = filterValue.match(regExp);
		if (matches!==null) {
			for(var i=0; i<matches.length; ++i){
				if(matches[i].toUpperCase().indexOf('OR') != -1){
					return false;
				}
			}
		}
	}
	return true;
}

//verifies there is not an AND in between enclosed formulas ie. ) AND (
function _verifyNoANDInBetweenParenthesis(filterValue){
	if(filterValue.indexOf('(') != -1){
		var regExp = /\)([^)]+)\(/g;
		var matches = filterValue.match(regExp);
		if (matches!==null) {
			for(var i=0; i<matches.length; ++i){
				if(matches[i].toUpperCase().indexOf('AND') != -1){
					return false;
				}
			}
		}
	}
	return true;
}

//verifies there is nothing nested in the filter formula
function _verifyNoNested(filterValue){
	if(filterValue.indexOf('((') != -1 || filterValue.indexOf('))') != -1){
		return false;
	}
	return true;
}

//verifies the formula ends with a number or )
function _verifyFormulaEndsProperly(filterValue){
	var validChars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ')'];
	filterValue = filterValue.substring(filterValue.length - 1, filterValue.length);
	if($.inArray(filterValue, validChars) == -1){
		return false;
	}
	return true;
}

//verifies the formula begins with a number or ()
function _verifyFormulaBeginsProperly(filterValue){
	var validChars = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '('];
	filterValue = filterValue.substring(0,1);
	if($.inArray(filterValue, validChars) == -1){
		return false;
	}
	return true;
}

//verify the row numbers are correct and there are the correct number of them
function _verifyNumbersExist(filterValue, objectRows){
	var consecutiveNumbers = '';
	var numberValues = [];

	// Iterate over each character in the filterValue adding number to numberValues array
	for (var i = 0; i < filterValue.length; i++){
		var val = filterValue[i];
		// If this character is a Number, add it to the consecutiveNumbers 
		// (next character might also be a number, so don't split of 12 as 1,2 in numberValues array)
		if (typeof parseInt(val, 10) === 'number' && !isNaN(val) && val !== ' '){
			consecutiveNumbers += val;
			
			// If this is the last character in the string, push consecutiveNumbers to numberValues array
			if(i === filterValue.length - 1) {
				numberValues.push(parseInt(consecutiveNumbers));
			}
		}
		// since this character is not a Number, check if the consecutiveNumbers has an values
		// Add consecutiveNumbers to numberValues array and clear consecutiveNumbers
		else if(consecutiveNumbers !== ''){
			numberValues.push(parseInt(consecutiveNumbers));
			consecutiveNumbers = '';
		}
	}

	// Check if all row numbers are present in filter logic
	for(var i = 1; i < objectRows.length+1; i++){
		if(numberValues.indexOf(i) === -1){
			return false;
		}
	}

	// object data should be greater than number values
	if (objectRows.length > numberValues.length){
		return false;
	}

	//compare each number with the objectRows object to verify match
	if(objectRows.length > 0 && numberValues.length > 0){
		for(var i=0; i<numberValues.length; ++i){
			var found = false;
			for(var j = 1; j <= objectRows.length; ++j){
				if(numberValues[i] == j ) {
					found = true;
				}
			}
			if(!found){
				return false;
			}
		}
		return true;
	}
	return false;
}

function _comparingAgainstNull(objectRows){
	var isInvalid = false;
	for (var i = 0; i < objectRows.length; i++){
		var operator = objectRows[i].operator;
		for (var ii = 0; ii < objectRows[i].values.length; ii++) {
			var val = objectRows[i].values[ii];
			if((operator === "<=" || operator === ">=" || operator === "<" || operator === ">") && (val === "" || val === null || val === undefined)){
				isInvalid = true;
			}
		}
	}
	return isInvalid;
}

//prevents logic like this: "(1 and 3 4)  (2 and 3 and 4)""
function _verifyNoSpaceBtwnNum(value){
	// make str numbers list
	var num = ['0','1','2','3','4','5','6','7','8','9'];
	//start looking at 3rd position since problem only exists with space between 2 numbers
	if (value.length >= 3) {
		for (var i = 2; i < value.length; i++){
			if (num.includes(value[i])) {
				var val = parseInt(value[i],10);
				var prevChar = value[i - 1];
				var prevPrevChar = parseInt(value[i - 2],10);						
				if (prevChar == ' ' && !isNaN(prevPrevChar)){
					return false;
				}
			}
		}
	}
	return true;
}

//prevents multiple spaces to so that the multiple spaces don't mess up other validations
function _verifyNoMultipleSpaces(value){
	//start looking at 3rd position since problem only exists with space between 2 numbers
	if (value.length >= 3) {
		for (var i = 2; i < value.length; i++){
			var prevChar = value[i - 1];
			var prevPrevChar = value[i - 2];
			if (prevChar === ' ' && prevPrevChar === ' '){
				return false;
			}
		}
	}
	return true;
}

// Verify that operators exist before and after parens, when the parens are not the first or last elements of the filterValue
// Invalid scenarios: [ 1 AND 2 OR 3 (4 AND 5) ], [ 1 AND (2 AND 3) 4 AND 5 ]
function _verifyOperatorBeforeAndAfterParens(filterValue) {
	var beforeParenOpen;
	var afterParenClosed;
	var errorExists = false;
	for(var i = 0; i < filterValue.length; i++) {
		// If parens close and this is not the end of the statement...
		if(filterValue[i] ===')' && i !== filterValue.length -1) {
			// get remaining statement following the close paren
			afterParenClosed = filterValue.substr(i + 1).trim();
			// Check for start of AND or OR operator
			if(afterParenClosed.substr(0,1).toUpperCase() === 'A' || afterParenClosed.substr(0,1).toUpperCase() === 'O') {
				// no op
			} else {
				// set error flag
				errorExists = true;
			}
		} 
		// If parens open and this is not the start of the statement...
		else if(filterValue[i] ==='(' && i !== 0) {
			// get statement before open paren
			beforeParenOpen = filterValue.substr(0,i).trim();
			// Check for end of AND or OR operator
			if(beforeParenOpen.substr(-1).toUpperCase() === 'D' || beforeParenOpen.substr(-1).toUpperCase() === 'R') {
				// no op
			} else {
				// set error flag
				errorExists = true;
			}
		}
	}
	
	return errorExists ? false : true;
}

// Verifies Operators are not next to each other 
// Invalid scenarios: [ 1 AND AND 2 ], [ 1 OR OR 2]
function _verifyElemBetweenOperators(filterValue) {
	var afterOperator;
	var errorExists;
	for(var i = 0; i < filterValue.length; i++) {
		// If we are at the end of an operator (AND,OR)
		if(filterValue[i].toUpperCase() === 'D' || filterValue[i].toUpperCase() === 'R') {
			// Get statement following the operator
			afterOperator = filterValue.substr(i + 1).trim();
			// Check if next character is open paren or number
			if(afterOperator[0] === '(' || $.isNumeric(afterOperator[0])) {
				// no op
			} else {
				errorExists = true;
			}
		}
	}
	
	return errorExists ? false : true;
}

// check that operators are not the first or last element inside parens
// Invalid scenarios: [ (AND1AND2) ], [ (1AND2AND) ]
function _verifyNumAfterParen(filterLogic) {
	var afterParenOpen;
	var beforeParenClose;
	var errorExists;
	for(var i = 0; i < filterLogic.length; i++) {
		// check for start of parens
		if(filterLogic[i] === '(') {
			afterParenOpen = filterLogic.substr(i+1).trim();
			// check that first element after open paren is a number
			if(!$.isNumeric(afterParenOpen[0])) {
				errorExists = true;
			}
		} else if(filterLogic[i] === ')') {
			beforeParenClose = filterLogic.substr(0,i).trim();
			// check that last element before close paren is a number
			if(!$.isNumeric(beforeParenClose.substr(-1))) {
				errorExists = true;
			}
		}
	}
	
	return errorExists ? false : true;
}

//checks to make sure the words in input are only either and or
function _checkFormulaWords(value){
	value = value.replace(/\(/g, ' ( ');
	value = value.replace(/\)/g, ' ) ');
	value = value.replace(/\d+/g, ' ');
	var valueWords = value.split(' ');
	for(var i = 0; i < valueWords.length; i++) {
		if(valueWords[i].toUpperCase().trim() != 'AND' && valueWords[i].toUpperCase().trim() != 'OR'
		 && valueWords[i].trim() !== '' && valueWords[i].trim() !== ')' && valueWords[i].trim() != '('){
			return false;
		}
	}
	return true;
}

//verifies the parenthesis are balanced, an open parenthesis has a closed parenthesis associated with it
function _parenthesisAreBalanced(value){
  var parenthesis = "()",
	stack = [], //parenthesis stack
	index, //Index in the string
	character; //Character in the string

  for (index = 0; index < value.length; index++){
	character = value[index];
	var bracePosition = parenthesis.indexOf(character),
	  braceType;
	//~ is truthy for any number but -1
	if (!~bracePosition)
	  continue;

	braceType = bracePosition % 2 ? 'closed' : 'open';

	if (braceType === 'closed')
	{
	  //If there is no open parenthese at all, return false OR
	  //if the opening parenthese does not match ( they should be neighbours )
	  if (!stack.length || parenthesis.indexOf(stack.pop()) != bracePosition - 1)
		return false;
	}
	else
	{
	  stack.push(character);
	}
  }
  //If anything is left on the stack <- not balanced
  return !stack.length;
}

// OR statment must be outside of parens -- ex:(1 AND 2) OR (3 AND 4)
// unless it is just a number -- ex: (1 AND 2) OR 3
function _verifyOROutsideOfParens(value) {
	var upperCaseValue = value.toUpperCase();
	if(upperCaseValue.indexOf('OR') > -1) {
		// create array splitting on OR -- ex: (1 AND 2) OR (3 AND 4) = ['(1 AND 2)', '(3 AND 4)']
		var groupingArr = upperCaseValue.split('OR');
		// Iterate over each grouping
		for(var i = 0; i < groupingArr.length; i++) {
			// Remove any whitespace
			var grouping = groupingArr[i].trim();
			// Check if this grouping starts and ends with parens
			if((grouping[0] !== '(' && grouping[grouping.length -1] !== ')')) {
				// If no parens, check if it is just a number
				if(!grouping.match(/^\d+$/g)) {
					// if conditions are matched, fail this test
					return false;
				}
			}
		}
	}
	return true;
}