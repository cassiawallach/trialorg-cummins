<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Social Security Number</label>
    <protected>false</protected>
    <values>
        <field>Nebula__ApplyToMessage__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Nebula__ApplyToRecordJson__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Nebula__IsEnabled__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Nebula__ReplacementRegEx__c</field>
        <value xsi:type="xsd:string">$1XXX-XX-$4</value>
    </values>
    <values>
        <field>Nebula__SensitiveDataRegEx__c</field>
        <value xsi:type="xsd:string">(^|[ ])(\d{3})[- ]*(\d{2})[- ]*(\d{4})</value>
    </values>
</CustomMetadata>
