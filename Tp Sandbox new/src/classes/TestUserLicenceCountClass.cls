@isTest
private class TestUserLicenceCountClass {
  // public static String CRON_EXP = '0 0 0 15 3 ? 2015';
public static String CRON_EXP = '0 0 0 15 8 ? 2016';
   static testmethod void test() {
      Test.startTest();
       list<License__c> licenses=new   list<License__c>();//bulk List of custom setting object for bulk insert
       

     License__c license=new License__c(); //Custom Setting 
       license.Name='salesforce';//Static record 1 of custom setting
       license.Available_Licenses__c=10;
       license.License_Type__c='sales';
       license.Threshold__c=10;
       license.User_Type__c='sales';
       licenses.add(license);

   License__c license1=new License__c(); 
          license1.name='portal';//Static Record 2 of custom settings
        license1.Available_Licenses__c=5;
       license1.License_Type__c='portal';
       license1.Threshold__c=5;
       license1.User_Type__c='portal';
       licenses.add(license1);

insert licenses;
      String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new ScheduledUserLicenceCountAlert());
         
      Test.stopTest();
   }
}