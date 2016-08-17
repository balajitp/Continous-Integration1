Global class ScheduledUserLicenceCountAlert implements Schedulable {
  
    global void execute(SchedulableContext sct){
       // String userLimit=System.Label.User_Limit;
  
        Map<String,License__c> license= License__c.getAll();
        List<User> ActiveUser = new List<user>();
       
      String s = 'Salesforce';
       Integer totalLicenses = totalLicenses('Salesforce');
       integer usedLicenses =  usedLicenses('Salesforce'); 
       Integer totalPartnerLicenses = totalLicenses('Partner Community');
       integer usedPartnerLicenses =  usedLicenses('Partner Community');  
       Integer totalCompanyLicenses = totalLicenses('Company Communities');
       integer usedCompanyLicenses =  usedLicenses('Company Communities'); 
       
       
       If(usageValue(totalLicenses,usedLicenses) > 70 ||  usageValue(totalPartnerLicenses,usedPartnerLicenses) > 70 || usageValue(totalCompanyLicenses,usedCompanyLicenses) > 70){
 
         String[] toAddresses = new String[] {'tp.balaji@ge.com','ram.marri@ge.com','atchyutha.marri@ge.com'};
         
          String[] bccAddresses = new String[] {'tp.balaji@ge.com','tpbalaji@gmail.com'};
        
    
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
       // mail.setbccAddresses(bccAddresses);
       // mail.setSenderDisplayName('tp.balaji@ge.com');
   /* Modified by TP Balaji mail.setSubject('User Licence limit Notification');
        mail.setHtmlBody('Team, <p><p>' +
                       'The number of available '+ uType.User_Type__c + '  Licenses is less than the recommended, minimum threshold. <p><p>'+
                       'Total License :' + Integer.Valueof(uType.Available_Licenses__c)+' <p><p>'+
                       'Available License :'+ availableLicense +' <p><p>'+
                       'If needed, please escalate to purchase additional Licenses to reduce the risk of delaying User access.<p><p>'+
                       'NOTE: Immediately before and during a Release a number of licenses are assigned for testing purposes and will be returned to the pool after the Warranty period expires.<p><p>'+
                       'Thanks,<p>'+
                       'SFDC Support Team'  );*/
   String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
         System.debug('baseUrl =' + baseUrl);
          mail.setSubject('WARNING - Available SFDC User Licenses is below threshold');
          String body='Team, <p><p>';
        
        if(usageValue(totalLicenses,usedLicenses) > 0){
            decimal usage_value = usageValue(totalLicenses,usedLicenses);        
          body+='<b><u>Salesforce</b></u><br/>';
          body+= '<p>Current Available licenses are less than the minimum available threshold ('+ thresholdvalue(usage_value) +'%) of the Total Purchased Licenses. <p><p>'+'FYI - Here is the Current Snapshot: <p><p>'+
       
            '<div align="Left" style="margin-left:60px;">Total Purchased Licenses :' + totalLicenses+'</div> <p><p>'+ 
            '<div align="Left" style="margin-left:60px;">Total Used Licenses :' + usedLicenses +'</div> <p><p>'+
            '<div align="Left" style="margin-left:60px;">Available Licenses :'+ available_Licenses(totalLicenses,usedLicenses) +'</div><p><p>';
        }   

        if(usageValue(totalPartnerLicenses,usedPartnerLicenses) >= 0){

            decimal usage_value = usageValue(totalPartnerLicenses,usedPartnerLicenses);        
          body+='<b><u>Partner Community</b></u><br/>';
          body+= '<p>Current Available licenses are less than the minimum available threshold ('+ thresholdvalue(usage_value) +'%) of the Total Purchased Licenses. <p><p>'+'FYI - Here is the Current Snapshot: <p><p>'+
       
            '<div align="Left" style="margin-left:60px;">Total Purchased Licenses :' + totalPartnerLicenses+'</div> <p><p>'+ 
            '<div align="Left" style="margin-left:60px;">Total Used Licenses :' + usedPartnerLicenses +'</div> <p><p>'+
            '<div align="Left" style="margin-left:60px;">Available Licenses :'+ available_Licenses(totalPartnerLicenses,usedPartnerLicenses) +'</div><p><p>';
        }

        if(usageValue(totalCompanyLicenses,usedCompanyLicenses) > 0){
            decimal usage_value = usageValue(totalCompanyLicenses,usedCompanyLicenses);        
          body+='<b><u>Company Communities</b></u><br/>';
          body+= '<p>Current Available licenses are less than the minimum available threshold ('+ thresholdvalue(usage_value) +'%) of the Total Purchased Licenses. <p><p>'+'FYI - Here is the Current Snapshot: <p><p>'+
       
            '<div align="Left" style="margin-left:60px;">Total Purchased Licenses :' + totalCompanyLicenses+'</div> <p><p>'+ 
            '<div align="Left" style="margin-left:60px;">Total Used Licenses :' + usedCompanyLicenses +'</div> <p><p>'+
            '<div align="Left" style="margin-left:60px;">Available Licenses :'+ available_Licenses(totalCompanyLicenses,usedCompanyLicenses) +'</div><p><p>';
        }           
      
      body+='<div align="Left" style="margin-left:60px;">OrganizationName :'+ OrganizationName +'</div><p><p>'+
      '<div align="Left" style="margin-left:60px;">baseUrl  :'+ baseUrl  +'</div><p><p>'+
                       'If needed, please escalate to purchase additional Licenses to reduce the risk of delaying User access.<p></p>'+
                      
                       'Thanks,<p>'+
                       'SFDC Support Team';
                       
        mail.setHtmlBody(body);            
OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'tpbalaji@gmail.com'];
                         if ( owea.size() > 0 ) {
    mail.setOrgWideEmailAddressId(owea.get(0).Id);
}
   
                                      
                         Messaging.sendEmail(new messaging.SingleEmailMessage[] {mail});
        }
         
    }   
    public String OrganizationName = Userinfo.getOrganizationId();
    
    public Decimal usageValue (Integer totalLicenses,Integer usedLicenses){
     Decimal usage;
     if(usedLicenses>0 && totalLicenses>0){
           usage=(Decimal)usedLicenses/ (Decimal)totalLicenses;
           usage=usage*100;
      }else{
          usage=0;
      }
           
     return usage;
   }
       
   public integer thresholdvalue(Decimal Usage){
       Integer minThreshold = 100 - (integer.valueOf(usage));
    return minThreshold;
   }
   public integer available_Licenses(Integer totalLicenses, Integer usedLicenses){
       Integer availableLicense=Integer.valueof(totalLicenses-usedLicenses);
       return availableLicense;
   }
    
    public static integer totalLicenses(string licenseName){
        Integer licenses = 0;
        String html;
        Organization org = [SELECT Id FROM Organization LIMIT 1];
        // I am Getting the Company Profile page at HTML.
        PageReference pr = new PageReference('/' + org.Id);
        // getContent() cannot be called from a trigger! and in test class as well
        if(!Test.isRunningTest()){
         html = pr.getContent().toString();
        }
        else{
            html = '<tr class=" dataRow odd" onblur="if (window.hiOff){hiOff(this);}" onfocus="if (window.hiOn){hiOn(this);}" onmouseout="if (window.hiOff){hiOff(this);}" onmouseover="if (window.hiOn){hiOn(this);}"><th scope="row" class=" dataCell  ">Salesforce</th><td class=" dataCell  ">Active</td><td class=" dataCell  numericalColumn">200</td><td class=" dataCell  numericalColumn">149</td><td class=" dataCell  numericalColumn">51</td><td class=" dataCell  DateElement">6/28/2017</td></tr>';
        }
        // I am Finding the part of the page that holds the license data.
        String token = '>' + licenseName + 
        '</th><td class=" dataCell  ">Active</td>' + 
        '<td class=" dataCell  numericalColumn">';
        Integer tokenLen = token.length();
        // I am fetching and Getting the starting position of the license number.
        Integer posStart = html.indexOf(token);
        if (posStart != -1) {
        //I am Getting  the end of the number.
        posStart += tokenLen;
        Integer posEnd = html.indexOf('<', posStart);
        // I am Extracting the number and converting it to an integer.
        String val = html.substring(posStart, posStart + (posEnd - posStart));
        // These is an additional comma There may be a comma.
        val = val.replaceAll('\\,', '');

        licenses = Integer.valueOf(val);
    }
        return licenses;
    }
    public static Integer usedLicenses(string licenseName){
        Integer licenses =
      [SELECT COUNT() FROM User
     WHERE Profile.UserLicense.Name =:licenseName
       AND IsActive = true];
       return licenses;
        
    }   }