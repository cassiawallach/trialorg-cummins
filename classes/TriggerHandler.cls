/************************************************************
Name:  TriggerHandler
Copyright © 2019  Cummins
=============================================================
Purpose:                                                            
Handler for trigger implementation                        
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                                
1.0 -    Karthik Golakaram         05/19/2021        INITIAL DEVELOPMENT  
********************************************************************************
********************************************************************************/ 
public virtual class TriggerHandler {

// static map of handlername, times run() was invoked
private static Map<String, LoopCount> loopCountMap;
private static Set<String> bypassedHandlers;
Public static List<IAM_Trigger_Switches__mdt> triggerSettings;

// the current context of the trigger, overridable in tests
@TestVisible
private TriggerContext context;

// the current context of the trigger, overridable in tests
@TestVisible
private Boolean isTriggerExecuting;

// static initialization
static {
  loopCountMap = new Map<String, LoopCount>();
  bypassedHandlers = new Set<String>();
  triggerSettings = new List<IAM_Trigger_Switches__mdt>();
}

// constructor
public TriggerHandler() {
  this.setTriggerContext();
  triggerSettings=getTriggerSettings();
}

/***************************************
 * public instance methods
 ***************************************/

// main method that will be called during execution
public void run() {

  //Skip trigger execution if trigger switch in metadata is false.
  if(!checkTriggerIsActive()){
  System.debug('Trigger is not active');
    return;
  }  
    
  //Skip Trigger execution if it should be for specific profiles.
  if(checkForProfileSkip()){
  System.debug('Printing skipped profile');
    return;
  }

  //SKip trigger if it is being executed as queueable or batchable or future method.
  if(checkAsyncronusProcess()){
    return;
  }
  
  // if validate run retunrs false then trigger will not get executed.used for skipping in specific cases
  if(!validateRun()) {
  System.debug('Printing the run ended.');
    return;
  }
  
  //Method to check the loop Count and break the recursion.
  if(addToLoopCount()){
  System.debug('Printing add loop count Ended');
    return;
  }
  
  System.debug('Printing context'+this.context);

  // dispatch to the correct handler method
  switch on this.context {
    when BEFORE_INSERT {
      this.beforeInsert();
    }
    when BEFORE_UPDATE {
      this.beforeUpdate();
    }
    when BEFORE_DELETE {
      this.beforeDelete();
    }
    when AFTER_INSERT {
      this.afterInsert();
    }
    when AFTER_UPDATE {
      this.afterUpdate();
    }
    when AFTER_DELETE {
      this.afterDelete();
    }
    when AFTER_UNDELETE {
      this.afterUndelete();
    }
  }
}

public void setMaxLoopCount(Integer max) {
  String handlerName = getHandlerName();
  if(!TriggerHandler.loopCountMap.containsKey(handlerName+String.valueOf(this.context))) {
    TriggerHandler.loopCountMap.put(handlerName+String.valueOf(this.context), new LoopCount(max));
  } else {
    TriggerHandler.loopCountMap.get(handlerName+String.valueOf(this.context)).setMax(max);
  }
}

public void clearMaxLoopCount() {
  this.setMaxLoopCount(-1);
}

/***************************************
 * public static methods
 ***************************************/

public static void bypass(String handlerName) {
  TriggerHandler.bypassedHandlers.add(handlerName);
}

public static void clearBypass(String handlerName) {
  TriggerHandler.bypassedHandlers.remove(handlerName);
}

public static Boolean isBypassed(String handlerName) {
  return TriggerHandler.bypassedHandlers.contains(handlerName);
}

public static void clearAllBypasses() {
  TriggerHandler.bypassedHandlers.clear();
}

/***************************************
 * private instancemethods
 ***************************************/

@TestVisible
private void setTriggerContext() {
  this.setTriggerContext(null, false);
}

@TestVisible
private void setTriggerContext(String ctx, Boolean testMode) {
  if(!Trigger.isExecuting && !testMode) {
    this.isTriggerExecuting = false;
    return;
  } else {
    this.isTriggerExecuting = true;
  }
  
  if((Trigger.isExecuting    && Trigger.isBefore && Trigger.isInsert) ||
      (ctx != null && ctx == 'before insert')) {
    this.context = TriggerContext.BEFORE_INSERT;
  } else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) ||
      (ctx != null && ctx == 'before update')){
    this.context = TriggerContext.BEFORE_UPDATE;
  } else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) ||
      (ctx != null && ctx == 'before delete')) {
    this.context = TriggerContext.BEFORE_DELETE;
  } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) ||
      (ctx != null && ctx == 'after insert')) {
    this.context = TriggerContext.AFTER_INSERT;
  } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) ||
      (ctx != null && ctx == 'after update')) {
    this.context = TriggerContext.AFTER_UPDATE;
  } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) ||
      (ctx != null && ctx == 'after delete')) {
    this.context = TriggerContext.AFTER_DELETE;
  } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) ||
      (ctx != null && ctx == 'after undelete')) {
    this.context = TriggerContext.AFTER_UNDELETE;
  }
}

// increment the loop count
@TestVisible
private Boolean addToLoopCount() {
  String handlerName = getHandlerName();
  Boolean exceeded=false;
  if(TriggerHandler.loopCountMap.containsKey(handlerName+String.valueOf(this.context))) {
    exceeded = TriggerHandler.loopCountMap.get(handlerName+String.valueOf(this.context)).increment();
    if(exceeded) {
      Integer max = TriggerHandler.loopCountMap.get(handlerName+String.valueOf(this.context)).max;
      //Since we need to execute trigger only once for each context. Instead of throwing error we will skip trigger execution.
      //Commenting the original statement.
      //throw new TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName+String.valueOf(this.context));
        System.debug('Printing exception for max loop'+'Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName+String.valueOf(this.context));
    }
  }
  return exceeded;
}

// make sure this trigger should continue to run if all the below conditions are true if any one is false return false and trigger will 
// not get executed.
//Skip if a specific profile is mentioned in Custom settings.
//Skip if trigger is disable in Custom Metadata.

@TestVisible
private Boolean validateRun() {
  if(!this.isTriggerExecuting || this.context == null) {
    throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
  }
  return !TriggerHandler.bypassedHandlers.contains(getHandlerName());
}

//Method to check if trigger Setting is active or not.
private Boolean checkTriggerIsActive(){
    Boolean isTriggerActive= false;
    if(!triggerSettings.isEmpty()){
        if(triggerSettings[0].IAM_Active__c){
            isTriggerActive=True;
        }
    }
    return isTriggerActive;
}

private Boolean checkForProfileSkip(){
    Boolean skipProfile=false;
    if(!TriggerSettings.isEmpty()){
        if(String.isNotBlank(triggerSettings[0].IAM_Profile_to_skip_trigger_execution__c)){
            List<String> allProfileIds=triggerSettings[0].IAM_Profile_to_skip_trigger_execution__c.split(';');
            if(!allProfileIds.isEmpty()){
                if(!allProfileIds.Contains(UserInfo.getProfileId())){
                  skipProfile=true;
                }
            }
        }
    } 
  return skipProfile;  
}

private Boolean checkAsyncronusProcess(){
 

  boolean isAsynchronusProcuss=false;
  if(System.isBatch()&&triggerSettings[0].IAM_Skip_for_isBatchable_execution__c){
      isAsynchronusProcuss=True;
  }

  if(System.isFuture()&&triggerSettings[0].IAM_Skip_for_isFuture_execution__c){
    isAsynchronusProcuss=True;
  }

  if(System.isQueueable()&&triggerSettings[0].IAM_Skip_for_isQueueable_Execution__c){
    isAsynchronusProcuss=True;
  }

  return isAsynchronusProcuss;
}

@TestVisible
private String getHandlerName() {
  return String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
}

/***************************************
 * context methods
 ***************************************/

// context-specific methods for override
@TestVisible
protected virtual void beforeInsert(){}
@TestVisible
protected virtual void beforeUpdate(){}
@TestVisible
protected virtual void beforeDelete(){}
@TestVisible
protected virtual void afterInsert(){}
@TestVisible
protected virtual void afterUpdate(){}
@TestVisible
protected virtual void afterDelete(){}
@TestVisible
protected virtual void afterUndelete(){}

/***************************************
 * inner classes
 ***************************************/

// inner class for managing the loop count per handler
@TestVisible
private class LoopCount {
  private Integer max;
  private Integer count;

  public LoopCount() {
    this.max = 5;
    this.count = 0;
  }

  public LoopCount(Integer max) {
    this.max = max;
    this.count = 0;
  }

  public Boolean increment() {
    this.count++;
    return this.exceeded();
  }

  public Boolean exceeded() {
    return this.max >= 0 && this.count > this.max;
  }

  public Integer getMax() {
    return this.max;
  }

  public Integer getCount() {
    return this.count;
  }

  public void setMax(Integer max) {
    this.max = max;
  }
}

// possible trigger contexts
@TestVisible
private enum TriggerContext {
  BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
  AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
  AFTER_UNDELETE
}

public List<IAM_Trigger_Switches__mdt> getTriggerSettings(){
   return( [SELECT id
            , IAM_Active__c
            , IAM_Loop_Count__c
            , IAM_Object_Name__c
            , IAM_Skip_for_isBatchable_execution__c
            , IAM_Skip_for_isFuture_execution__c
            , IAM_Skip_for_isQueueable_Execution__c
            , IAM_Profile_to_skip_trigger_execution__c
            , IAM_Record_Types_Names__c
             FROM IAM_Trigger_Switches__mdt 
             WHERE IAM_Object_Name__c=:getHandlerName().substringBetween('IAM_','Trigger') LIMIT 1]);
}
// exception class
public class TriggerHandlerException extends Exception {}

}