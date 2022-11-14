function generateZIP() {
	var zipFile = new JSZip();
	var allPackageTriggers = [];
	var allPackageClasses = [];
	var objectName;
	var triggerName;

	// for each trigger that needs to be created
	if (objectName2TriggerInfo !== null && Object.keys(objectName2TriggerInfo).length > 0) {
		for (var thisObjectName in objectName2TriggerInfo) {
			triggerName = objectName2TriggerInfo[thisObjectName].triggerName;
			className = objectName2TriggerInfo[thisObjectName].className;
			allPackageTriggers.push(triggerName);
			allPackageClasses.push(className);

			// if its a field link trigger
			if (thisObjectName.substring(0,3) === 'fl_') {
				objectName = thisObjectName.replace('fl_','');
				zipFile.file('triggers/'+triggerName+'.trigger',buildFLTrigger(triggerName,objectName,ns));
				zipFile.file('classes/'+className+'.cls',buildFLClass(className,objectName,ns));
			}
			// if its a linked section trigger
			else if (thisObjectName.substring(0,3) === 'ls_') {
				objectName = thisObjectName.replace('ls_','');
				zipFile.file('triggers/'+triggerName+'.trigger',buildLSTrigger(triggerName,objectName,ns));
				zipFile.file('classes/'+className+'.cls',buildLSClass(className,objectName,ns));
			}

			// build metadata for trigger and class
			zipFile.file('triggers/'+triggerName+'.trigger-meta.xml',buildXML('ApexTrigger'));
			zipFile.file('classes/'+className+'.cls-meta.xml',buildXML('ApexClass'));
		}

		// build package XML
		zipFile.file('package.xml',buildPackageXML(allPackageTriggers,allPackageClasses));
		
		// generate zip file
		var zipData = zipFile.generate();

		deployZip(zipData,allPackageClasses);
	}
}

function buildXML(metadataType) {
	return '<?xml version="1.0" encoding="UTF-8"?>' +
			'<'+metadataType+' xmlns="http://soap.sforce.com/2006/04/metadata">' +
				'<apiVersion>52.0</apiVersion>' + 
				'<status>Active</status>' +
			'</'+metadataType+'>';
}

function buildFLTrigger(triggerName,objectName,namespace) {
	var dedunderNS = namespace.replace('__','.');
	
	return '/* This trigger was created by the Youreka package and is integral to it. \nPlease do not delete */\n'+
			'trigger '+triggerName+' on '+objectName+' (after update){\n'+
			'    '+dedunderNS+'Util.updateObjectsFieldLinkAnswers(trigger.new,\''+objectName+'\');\n'+
			'}\n';
}

function buildLSTrigger(triggerName,objectName,namespace) {
	var dedunderNS = namespace.replace('__','.');
	return '/* This trigger was created by the Youreka package and is integral to it. \nPlease do not delete */\n'+
			'trigger '+triggerName+' on '+objectName+' (after update){\n'+
			'    '+dedunderNS+'Util.updateAnswersInLinkedSections(trigger.new,\''+objectName+'\');\n'+
			'}\n';
}

function buildFLClass(className,objectName,namespace) {
	var dedunderNS = namespace.replace('__','.');
	return'/* This class was created by the Youreka package and is integral to it. \nPlease do not delete */\n'+
		'@istest(SeeAllData=true)\n'+
		'private class '+className+'{\n'+
			'static testMethod void '+className+'test(){\n'+
				dedunderNS+'Util.testLinkedObjTrigger(\''+objectName+'\');\n'+
		'    }\n'+
		'}';
}

function buildLSClass(className,objectName,namespace) {
	var dedunderNS = namespace.replace('__','.');
	return'/* This class was created by the Youreka package and is integral to it. \nPlease do not delete */\n'+
		'@istest(SeeAllData=true)\n'+
		'private class '+className+'{\n'+
			'static testMethod void '+className+'test(){\n'+
				dedunderNS+'Util.testLinkedObjLDTrigger(\''+objectName+'\');\n'+
		'    }\n'+
		'}';
}

function buildPackageXML(allPackageTriggers,allPackageClasses) {
	var packageXML = '<?xml version="1.0" encoding="UTF-8"?>' + 
						'<Package xmlns="http://soap.sforce.com/2006/04/metadata">' + 
						'<types>';

	// add all triggers
	for (var i = 0; i < allPackageTriggers.length; i++) {
		packageXML += '<members>'+allPackageTriggers[i]+'</members>';
	}
	packageXML += '<name>ApexTrigger</name></types><types><name>ApexClass</name>';

	// add all classes
	for (var j = 0; j < allPackageClasses.length; j++) {
		packageXML += '<members>'+allPackageClasses[j]+'</members>';
	}

	packageXML += '</types>' + 
					'<version>52.0</version>' + 
				'</Package>';
	
	return packageXML;
}

function deployZip(zipData,allTestClasses) {
	Visualforce.remoting.Manager.invokeAction(  
		deployMetadataVFR,
		zipData,
		allTestClasses,
		function(result, event) {
			// used in debugging
			//checkAsyncStatus(result);
		}
	);
}

/* DONT DELETE USED IN DEBUGGING
function checkAsyncStatus(asyncID) {
	Visualforce.remoting.Manager.invokeAction(  
		checkAsyncRequestVFR,
		asyncID,
		function(result, event) {
			if (result === 'deploying') {
				console.log('result : ' + result);
				setTimeout(function() {
					checkAsyncStatus(asyncID);
				},10000);
			}
			else {
				console.log('done : ' + result);
			}
		}
	);
}*/