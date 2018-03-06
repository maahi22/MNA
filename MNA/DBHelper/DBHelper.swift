//
//  DBHelper.swift
//  MNA
//
//  Created by Maahi on 29/12/17.
//  Copyright © 2017 KTeck. All rights reserved.
//

import UIKit
import CoreData


class DBHelper: NSObject {

    class func fetchRecordsForEntity(_ entity: String,  inManagedObjectContext managedObjectContext: NSManagedObjectContext , sortyby:String) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        
        let sortDescriptor = NSSortDescriptor(key: sortyby, ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }
    
    
    
    
    //SAVE ALERT data
    class   func saveAlertNotification(_ alertNotiArray :NSArray  ) -> [AlertModel] {
        var returnArray = [AlertModel]()
        for i in 0...(alertNotiArray.count-1){
            let dict1 = alertNotiArray.object(at: i) as! NSDictionary
            let alert = AlertModel()
            if let N_Id = dict1["N_Id"], !(N_Id is NSNull) {
                alert.N_Id = (N_Id as? String)!
            }
            if let S_Description = dict1["S_Description"], !(S_Description is NSNull) {
                alert.S_Description = (S_Description as? String)!
            }
            if let DT_CreatedOn = dict1["DT_CreatedOn"], !(DT_CreatedOn is NSNull) {
                alert.DT_CreatedOn = (DT_CreatedOn as? String)!
            }
            returnArray.append(alert)
        }
        return returnArray
    }
    
    
    //CORE DATA METHODS
 
    class func populateDBWithPulis(_ publish: String, Publication:String, Edit:String, AndAppData:String ){
    
    
        
        
        
        
        
        
    }
    
    
    func insertPublisher(_ publisherDict : NSDictionary , publications:NSManagedObject) -> NSManagedObject{
      
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.getContext()
        
        let entityDescription = NSEntityDescription.entity(forEntityName: CDE_publisher, in: context)
        let Publisher = NSManagedObject(entity: entityDescription!, insertInto: context)
        
        if let PublisherCode = publisherDict["PublisherCode"], !(PublisherCode is NSNull) {
            let code = (PublisherCode as? String)!
            Publisher.setValue(code, forKey: "publisher_Id")
        }else{
            Publisher.setValue("", forKey: "publisher_Id")
        }
        
        if let UpdatedOn = publisherDict["UpdatedOn"], !(UpdatedOn is NSNull) {
            let dateStr = (UpdatedOn as? String)!//Covert date
            let date = DateHelper.convertToDateFromString(dateStr)
            Publisher.setValue(date, forKey: "publisher_UpdatedOn")
        }else{
            let date = DateHelper.convertToDateFromString("")
            Publisher.setValue(date, forKey: "publisher_UpdatedOn")
        }
        
        if let PorttaitSplashScreen = publisherDict["PorttaitSplashScreen"], !(PorttaitSplashScreen is NSNull) {
            let splash = (PorttaitSplashScreen as? String)!
            Publisher.setValue(splash, forKey: "publisher_PotraitSplashscreen")
        }else{
            Publisher.setValue("", forKey: "publisher_PotraitSplashscreen")
        }
        
        if let Name = publisherDict["Name"], !(Name is NSNull) {
            let name = (Name as? String)!
            Publisher.setValue(name, forKey: "publisher_Name")
        }else{
            Publisher.setValue("", forKey: "publisher_Name")
        }
        
        if let Logo = publisherDict["Logo"], !(Logo is NSNull) {
            let logo = (Logo as? String)!
            Publisher.setValue(logo, forKey: "publisher_Logo")
        }else{
            Publisher.setValue("", forKey: "publisher_Logo")
        }
        if let LandscapeSplashScreen = publisherDict["LandscapeSplashScreen"], !(LandscapeSplashScreen is NSNull) {
            let splash = (LandscapeSplashScreen as? String)!
            Publisher.setValue(splash, forKey: "publisher_LandscapeSplashscreen")
        }else{
            Publisher.setValue("", forKey: "publisher_LandscapeSplashscreen")
        }
        
        if let Email = publisherDict["Email"], !(Email is NSNull) {
            let email = (Email as? String)!
            Publisher.setValue(email, forKey: "publisher_Email")
        }else{
            Publisher.setValue("", forKey: "publisher_Email")
        }
        
        if let Country = publisherDict["Country"], !(Country is NSNull) {
            let count = (Country as? String)!
            Publisher.setValue(count, forKey: "publisher_Country")
        }else{
            Publisher.setValue("", forKey: "publisher_Country")
        }
        
        if let ContactName = publisherDict["ContactName"], !(ContactName is NSNull) {
            let contact = (ContactName as? String)!
            Publisher.setValue(contact, forKey: "publisher_ContactName")
        }else{
            Publisher.setValue("", forKey: "publisher_ContactName")
        }
        
        if let City = publisherDict["City"], !(City is NSNull) {
            let city = (City as? String)!
            Publisher.setValue(city, forKey: "publisher_City")
        }else{
            Publisher.setValue("", forKey: "publisher_City")
        }
        
        if let Address = publisherDict["Address"], !(Address is NSNull) {
            let add = (Address as? String)!
            Publisher.setValue(add, forKey: "publisher_Address")
        }else{
            Publisher.setValue("", forKey: "publisher_Address")
        }
        
        
        Publisher.setValue(publications, forKey: "publications")//relationship
        
        do {
            try Publisher.managedObjectContext?.save()
            
        } catch {
            print("Error occured during save entity")
        }

        return Publisher
    }
    
    
    
    
    
    func insertPublication(_ arrpublication : NSArray, publisher:NSManagedObject , arrEditions:NSArray ,appDataArr:NSArray ){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.getContext()
        
        
        for i in 0...(arrpublication.count-1){
            let dictPublication = arrpublication.object(at: i) as! NSDictionary
            
            
            
            let entityDescription = NSEntityDescription.entity(forEntityName: CDE_publication, in: context)
            let Publication = NSManagedObject(entity: entityDescription!, insertInto: context)
            
            
            
            if let Id = dictPublication["Id"], !(Id is NSNull) {
                let pid = (Id as? String)!
                Publication.setValue(pid, forKey: "publication_Id")
            }else{
                Publication.setValue("", forKey: "publication_Id")
            }
            
            if let PublicationCode = dictPublication["PublicationCode"], !(PublicationCode is NSNull) {
                let publicationCode = (PublicationCode as? String)!
                Publication.setValue(publicationCode, forKey: "publication_Code")
            }else{
                Publication.setValue("", forKey: "publication_Code")
            }
            
            if let Description = dictPublication["Description"], !(Description is NSNull) {
                let desc = (Description as? String)!
                Publication.setValue(desc, forKey: "publication_Description")
            }else{
                Publication.setValue("", forKey: "publication_Description")
            }
            
            if let Country = dictPublication["Country"], !(Country is NSNull) {
                let pCountry = (Country as? String)!
                Publication.setValue(pCountry, forKey: "publication_Country")
            }else{
                Publication.setValue("", forKey: "publication_Country")
            }
            
            if let City = dictPublication["City"], !(City is NSNull) {
                let city = (City as? String)!
                Publication.setValue(city, forKey: "publication_City")
            }else{
                Publication.setValue("", forKey: "publication_City")
            }
            
            
            
            if let UpdatedOn = dictPublication["UpdatedOn"], !(UpdatedOn is NSNull) {
                let UpdatedDateStr = (UpdatedOn as? String)!
                let date = DateHelper.convertToDateFromString(UpdatedDateStr)
                Publication.setValue(date, forKey: "publication_UpdatedOn")
            }else{
                let date = DateHelper.convertToDateFromString("")
                Publication.setValue(date, forKey: "publication_UpdatedOn")
            }
            if let Name = dictPublication["Name"], !(Name is NSNull) {
                let name = (Name as? String)!
                Publication.setValue(name, forKey: "publisher_Name")
            }else{
                Publication.setValue("", forKey: "publisher_Name")
            }
            if let Logo = dictPublication["Logo"], !(Logo is NSNull) {
                let logo = (Logo as? String)!
                Publication.setValue(logo, forKey: "publisher_Logo")
            }else{
                Publication.setValue("", forKey: "publisher_Logo")
            }
            
            
           /* if let City = dictPublication["City"], !(City is NSNull) {
                let city = (City as? String)!
                Publication.setValue("", forKey: "publication_Name")
            }else{
                Publication.setValue("", forKey: "publication_Name")
            }
            if let City = dictPublication["City"], !(City is NSNull) {
                let city = (City as? String)!
                Publication.setValue("", forKey: "publication_Logo")
            }else{
                Publication.setValue("", forKey: "publication_Logo")
            }*/
            
            
        
            
            self.insertEdition(arrEditions ,publication:Publication,arrAppData: appDataArr)
            
            
            Publication.setValue(publisher, forKey: "publishers")//relationship
            
            do {
                try Publication.managedObjectContext?.save()
                
            } catch {
                print("Error occured during save entity")
            }
            
        }
    
    
    
    }
    
    func insertEdition(_ arrEditions : NSArray, publication:NSManagedObject , arrAppData:NSArray){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.getContext()
        
        for i in 0...(arrEditions.count-1){
            
            let dictEditions = arrEditions.object(at: i) as! NSDictionary
            
            let entityDescription = NSEntityDescription.entity(forEntityName: CDE_edition, in: context)
            let Editions = NSManagedObject(entity: entityDescription!, insertInto: context)
            
            if let Id = dictEditions["Id"], !(Id is NSNull) {
                let id = (Id as? String)!
                Editions.setValue(id, forKey: "edition_Id")
            }else{
                Editions.setValue("", forKey: "edition_Id")
            }
            
            
            if let PublicationId = dictEditions["PublicationId"], !(PublicationId is NSNull) {
                let pid = (PublicationId as? String)!
                Editions.setValue(pid, forKey: "publication_Id")
            }else{
                Editions.setValue("", forKey: "publication_Id")
            }
            
            if let UpdatedOn = dictEditions["UpdatedOn"], !(UpdatedOn is NSNull) {
                let updateDate = (UpdatedOn as? String)!
                let date = DateHelper.convertToDateFromString(updateDate)
                Editions.setValue(date, forKey: "edition_UpdatedOn")
            }else{
                let date = DateHelper.convertToDateFromString("")
                Editions.setValue(date, forKey: "edition_UpdatedOn")
            }
            if let Name = dictEditions["Name"], !(Name is NSNull) {
                let name = (Name as? String)!
                Editions.setValue(name, forKey: "edition_Name")
            }else{
                Editions.setValue("", forKey: "edition_Name")
            }
            if let Language = dictEditions["Language"], !(Language is NSNull) {
                let language = (Language as? String)!
                Editions.setValue(language, forKey: "edition_Language")
            }else{
                Editions.setValue("", forKey: "edition_Language")
            }
            if let Frequency = dictEditions["Frequency"], !(Frequency is NSNull) {
                let frequency = (Frequency as? String)!
                Editions.setValue(frequency, forKey: "edition_Frequency")
            }else{
                Editions.setValue("", forKey: "edition_Frequency")
            }
            if let Country = dictEditions["Country"], !(Country is NSNull) {
                let country = (Country as? String)!
                Editions.setValue(country, forKey: "edition_Country")
            }else{
                Editions.setValue("", forKey: "edition_Country")
            }
            if let EditionCode = dictEditions["EditionCode"], !(EditionCode is NSNull) {
                let ecode = (EditionCode as? String)!
                Editions.setValue(ecode, forKey: "edition_Code")
            }else{
                Editions.setValue("", forKey: "edition_Code")
            }
            if let City = dictEditions["City"], !(City is NSNull) {
                let city = (City as? String)!
                Editions.setValue(city, forKey: "edition_City")
            }else{
                Editions.setValue("", forKey: "edition_City")
            }
            
            
            Editions.setValue(publication, forKey: "publications")//relationship
            
            self.insertAppdata(arrAppData,edition: Editions)
            
            
            do {
                try Editions.managedObjectContext?.save()
                
            } catch {
                print("Error occured during save entity")
            }
        }
    }
    
    
    
    func insertAppdata(_ arrAppData : NSArray ,edition:NSManagedObject){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.getContext()
        
        for i in 0...(arrAppData.count-1){
            
            let dictNews = arrAppData.object(at: i) as! NSDictionary
            
            let entityDescription = NSEntityDescription.entity(forEntityName: CDE_Newspapers, in: context)
            let Newspaper = NSManagedObject(entity: entityDescription!, insertInto: context)
            
            
            
            if let EditionCode = dictNews["EditionCode"], !(EditionCode is NSNull) {
                let code = (EditionCode as? String)!
                Newspaper.setValue(code, forKey: "edition_Code")
            }else{
                Newspaper.setValue("", forKey: "edition_Code")
            }
            
            if let UploadedDate = dictNews["UploadedDate"], !(UploadedDate is NSNull) {
                let dateStr = (UploadedDate as? String)!
              let date = DateHelper.convertToDateFromString(dateStr)
                Newspaper.setValue(date, forKey: "newspaper_Date")
            }else{
                let date = DateHelper.convertToDateFromString("")
                Newspaper.setValue(date, forKey: "newspaper_Date")
            }
            if let UploadId = dictNews["UploadId"], !(UploadId is NSNull) {
                let nId = (UploadId as? String)!
                Newspaper.setValue(nId, forKey: "newspaper_Id")
            }else{
                Newspaper.setValue("", forKey: "newspaper_Id")
            }
            if let ImagePath = dictNews["ImagePath"], !(ImagePath is NSNull) {
                let imgPath = (ImagePath as? String)!
                Newspaper.setValue(imgPath, forKey: "newspaper_Image")
            }else{
                Newspaper.setValue("", forKey: "newspaper_Image")
            }
            if let NextReleaseDate = dictNews["NextReleaseDate"], !(NextReleaseDate is NSNull) {
                let relese = (NextReleaseDate as? String)!
                Newspaper.setValue(relese, forKey: "newspaper_NextRelease")
            }else{
                Newspaper.setValue("", forKey: "newspaper_NextRelease")
            }
            if let newspaper_Date = dictNews["newspaper_Date"], !(newspaper_Date is NSNull) {
                let orderDate = (newspaper_Date as? String)!
               let date = DateHelper.convertToDateFromString(orderDate)
                Newspaper.setValue(date, forKey: "newspaper_OrderDate")
            }else{
                let date = DateHelper.convertToDateFromString("")
                Newspaper.setValue(date, forKey: "newspaper_OrderDate")
            }
            if let Noofpages = dictNews["Noofpages"], !(Noofpages is NSNull) {
                let pages = (Noofpages as? String)!
                Newspaper.setValue(pages, forKey: "newspaper_PageCount")
            }else{
                Newspaper.setValue("", forKey: "newspaper_PageCount")
            }
            if let PdfPath = dictNews["PdfPath"], !(PdfPath is NSNull) {
                let pathPdf = (PdfPath as? String)!
                Newspaper.setValue(pathPdf, forKey: "newspaper_Pdf")
            }else{
                Newspaper.setValue("", forKey: "newspaper_Pdf")
            }
            
            
            Newspaper.setValue(edition, forKey: "editions")//relationship
            
            do {
                try Newspaper.managedObjectContext?.save()
                
            } catch {
                print("Error occured during save entity")
            }
            
        }
    
}
    
    
    
    
    
    class func UpdateServerAnnotations(_ arrAnotation : NSArray, objAnotation:NSManagedObject){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.getContext()
        
        
        for i in 0...(arrAnotation.count-1){
            let dictAnotation = arrAnotation.object(at: i) as! NSDictionary
            //Add data
            if let annotationObject = dictAnotation["annotationObject"], !(annotationObject is NSNull) {
                let pid = (annotationObject as? String)!
                objAnotation.setValue(pid, forKey: "annotationObject")
            }else{
                objAnotation.setValue("", forKey: "annotationObject")
            }
            
            if let annotation_Sync = dictAnotation["annotation_Sync"], !(annotation_Sync is NSNull) {
                let publicationCode = (annotation_Sync as? Bool)!
                objAnotation.setValue(publicationCode, forKey: "annotation_Sync")
            }else{
                objAnotation.setValue(false, forKey: "annotation_Sync")
            }
            
            if let newspaper_Id = dictAnotation["newspaper_Id"], !(newspaper_Id is NSNull) {
                let desc = (newspaper_Id as? Int)!
                objAnotation.setValue(desc, forKey: "newspaper_Id")
            }else{
                objAnotation.setValue("", forKey: "newspaper_Id")
            }
            
            do {
                try objAnotation.managedObjectContext?.save()
            } catch {
                print("Error occured during save entity")
            }
        }
        
    }
    
    
    
    
    
    
    class func saveServerAnnotations(_ arrAnotation : NSArray ,NewspaperId:Int64, userId:String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.getContext()
        
        let annotationsList:[NSManagedObject] = DBHelper.fetchRequestForAnnotation("Annotations",FilterExpression: "(newspaper_Id == \(NewspaperId))")
        if annotationsList.count > 0 {
            let mangObj = annotationsList[0]
            guard let json = mangObj.value(forKey: "annotationObject") as? String ,let arrAnnObj = CommonHelper.convertToDictionary(text:json ) else{
                return
                
            }
                
                
               /* CommonHelper.convertArraytoJsonString((mangObj.value(forKey: "annotationObject") as? NSArray)!) else{
                return
            }*/
            
            var arrAnnObj1 = NSMutableArray()
            
            for aDict in arrAnnObj {
              /*
                let dicAnnotate = aDict as Dictionary
                var dicAnnotate1:NSMutableDictionary = dicAnnotate as NSDictionary
                if dicAnnotate.valu  {
                    
                    let dict = arrAnnObj[0] as Dictionary
                    dicAnnotate1.setValue(dict.va, forKey: "createdOn")
                    dicAnnotate1.setValue(annotationObject[0], forKey: "annotationText")
                    
                }
                
                arrAnnObj1.add(dicAnnotate1)
                
                if([[dicAnnotate objectForKey:@"id"] isEqualToNumber:[NSNumber numberWithInt:[[[annotationObject objectAtIndex:0] objectForKey:@"id"] intValue]]]){
                    
                    [dicAnnotate1 setValue:[[annotationObject objectAtIndex:0] objectForKey:@"createdOn"] forKey:@"createdOn"];
                    [dicAnnotate1 setValue:[[annotationObject objectAtIndex:0] objectForKey:@"annotationText"] forKey:@"annotationText"];
                    isFound=true;
                }
                [arrAnnObj1 addObject:dicAnnotate1];
                */
                
            }
            
            
            
            
            
        }else{
        
            let entityDescription = NSEntityDescription.entity(forEntityName: CDE_Annotations, in: context)
            let Annotations = NSManagedObject(entity: entityDescription!, insertInto: context)
            //Add data
            Annotations.setValue(NewspaperId , forKey: "newspaper_Id")
            Annotations.setValue(true, forKey: "annotation_Sync")
            let jsonStr = CommonHelper.convertArraytoJsonString(arrAnotation)
            Annotations.setValue(jsonStr, forKey: "annotationObject")
            
            
            do {
                try Annotations.managedObjectContext?.save()
            } catch {
                print("Error occured during save entity")
            }
            
            
        }
      
        
    }
    
    
    
    
    
    //Db featching Annotation entity data
    class func fetchRequestForAnnotation(_ EntityName:String, FilterExpression:String) -> [NSManagedObject] {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName)
        fetchRequest.returnsObjectsAsFaults = false
        if FilterExpression != "" {
            let predicate = NSPredicate.init(format: FilterExpression)
            fetchRequest.predicate = predicate
        }
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            if let records = records as? [NSManagedObject] {
                result = records
            }
        } catch {
            print("Unable to fetch managed objects for entity \(EntityName).")
        }
        
        return result
    }
    
    
    
    
    //Db featching Common entity data
    class func fetchRequestForEntityForName(_ EntityName:String, FilterExpression:String, SortBy:String, Ascending:Bool, Limit:Int) -> [NSManagedObject] {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.getContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName)
        let sortDescriptor = NSSortDescriptor(key: SortBy, ascending: Ascending)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        
        if FilterExpression != "" {
            let predicate = NSPredicate.init(format: FilterExpression)
            fetchRequest.predicate = predicate
        }
        
        if Limit != 0 {
           fetchRequest.fetchLimit = Limit
        }
        
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            if let records = records as? [NSManagedObject] {
                result = records
            }
        } catch {
            print("Unable to fetch managed objects for entity \(EntityName).")
        }
        
        return result
        
    }
    
    
    
    //check Annotaion respect to newid exist or not
    class func checkRecordsExistWithNewspaperId(_ NewspaperId:Int)-> Bool{
        let annotationsList:[NSManagedObject] = DBHelper.fetchRequestForAnnotation("Annotations",FilterExpression: "(newspaper_Id == \(NewspaperId))")
        if annotationsList.count > 0 {
            return true
        }
        return false
    }
    
    
    //*****     Database interaction Methods
    class func FetchAnnotationsListFromDbByNewsPaperId(_ newspaperId:Int64) -> NSManagedObject{
        
        let annotationsList:[NSManagedObject] = self.fetchRequestForAnnotation("Annotations",FilterExpression: "(newspaper_Id == \(newspaperId))")
        if annotationsList.count > 0 {
            return annotationsList[0]
        }else{
            return NSManagedObject()
        }
        
    }
    
    
    //*****     Database interaction Methods
    class func IsEmpityAnnotations(_ newspaperId:Int64) -> Bool{
        
        let annotationsList:[NSManagedObject] = self.fetchRequestForAnnotation("Annotations",FilterExpression: "(newspaper_Id == \(newspaperId))")
        if annotationsList.count > 0 {
            return false
        }else{
            return true
        }
        
    }
    
    
    
    
    
    
}
