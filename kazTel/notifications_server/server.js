"use strict";
  
 const apn = require('apn');
 
 let options = {
   token: {
     key: "cert.p12",
     // Replace keyID and teamID with the values you've previously saved.
     keyId: "99BT53GJX6",
     teamId: "F82QYRE4N3"
   },
   production: false
 };
 
 let apnProvider = new apn.Provider(options);
 
 // Replace deviceToken with your particular token:
 let deviceToken = "355ae5ab0f1728740ba47dfd82bcbabfe9687d62c52d63360d0c6be3ef652d91";
 
 // Prepare the notifications
 let notification = new apn.Notification();
 notification.expiry = Math.floor(Date.now() / 1000) + 24 * 3600; // will expire in 24 hours from now
 notification.badge = 2;
 notification.sound = "ping.aiff";
 notification.alert = "Hello from solarianprogrammer.com";
 notification.payload = {'messageFrom': 'Solarian Programmer'};
 
 // Replace this with your app bundle ID:
 notification.topic = "com.solarianprogrammer.PushNotificationsTutorial";
 
 // Send the actual notification
 apnProvider.send(notification, deviceToken).then( result => {
 	// Show the result of the send operation:
 	console.log(result);
 });
 
 
 // Close the server
 apnProvider.shutdown();