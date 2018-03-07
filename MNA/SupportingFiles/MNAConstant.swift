//
//  MNAConstant.swift
//  MNA
//
//  Created by Apple on 29/12/17.
//  Copyright © 2017 KTeck. All rights reserved.
//

let     RemoteURL = "http://202.123.27.106/"
let     BaseUrl = "http://202.123.27.106/mnaservices2/webservice/"

let     FPKLicenseKey = "7c10e9a270354f39d1f99548d75bc6d0cc1d4a9f"
let     Publisher_ID = "tabitlite/"
let     Bundledisplayname = "MP Sitting MNA"
let     MNA_AnalyticsAccountId = "UA-38155974-2"
let     MNA_SignIn = "webservice_ios2.php?method=login&encode=json"
let     MNAUrl_ChangePassword = "webservice_ios2.php?method=changePassword&encode=json"
let     MNAUrl_getAnnotations = "webservice_ios2.php?method=getAnnotations&encode=json"

let     MNAUrl_SaveAnnotationsOnServer = "webservice_ios2.php?method=annotation&encode=json" //{\"UserId\":\"%@\",\"NewspaperId\":%@,\"Annotation\":%@}"
let     MNAUrl_DeleteAnnotationsOnServer = "webservice_ios2.php?method=annotation&encode=json" //{\"UserId\":\"%@\",\"NewspaperId\":%@,\"Annotation\"
let     MNAUrl_DeleteFileOnServer = "webservice_ios2.php?method=deleteFile&encode=json" //{\"FileName\":\"%@\"}
let     MNAUrl_FeatchAnnotationsfromServer = "webservice_ios2.php?method=getAnnotations&encode=json"//{\"UserId\":\"%@\",\"NewspaperId\":%d}





let     MNAUrl_DatapublisherId = "webservice_ios2.php?encode=json&publisherId="
let     MNAUrl_publisher = "&method=publisher"
let     MNAUrl_publication = "&method=publication"
let     MNAUrl_edition = "&method=edition"
let     MNAUrl_appdata = "&method=appdata"

//$(PRODUCT_NAME:c99extidentifier)

//CoreData entity
let     CDE_publisher = "Publishers"
let     CDE_publication = "Publications"
let     CDE_edition = "Editions"
let     CDE_Annotations = "Annotations"
let     CDE_DefaultEditions = "DefaultEditions"
let     CDE_MyLibrary = "MyLibrary"
let     CDE_Sections = "Sections"
let     CDE_Newspapers = "Newspapers"



/*  MNA_SignIn = ""
let  MNA_SignIn = ""
let  MNA_SignIn = ""
let  MNA_SignIn = ""
let  MNA_SignIn = ""*/


let     AlertBaseUrl = "http://202.123.27.106/mnaservices2/webservice/"
let     MNA_Alert = "webservice_notification_ios.php?"

let     MNA_RegisterToken = "http://202.123.27.106/mna-app2/ipadapp.do?method=token&dtoken=%@&userid=%@"

//http://202.123.27.106/mnaservices2/webservice/webservice.php#
//http://202.123.27.106/mnaservices2/webservice/webservice_notification_ios.php?method=notification&limit=0&userid=6
//http://202.123.27.106/mnaservices2/webservice/webservice_agenda_ios.php
//http://202.123.27.106/mnaservices2/webservice/webservice_notification_ios.php?method=notification&limit=0&userid=admin@mna.com
//https://stackoverflow.com/questions/43652331/soap-request-with-xml-response-and-body-swift-3-alamofire

//https://stackoverflow.com/questions/30606146/ios-swift-call-web-service-using-soap



//Alerts
let NoInterNetAlertTitle = "No internet connection"
let NoInterNetAlertMsg = "This application requires a WiFi or cellular network to connect to the server. Please ensure that you have an active connection and/or Airplane mode is turned off."
