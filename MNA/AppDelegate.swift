//
//  AppDelegate.swift
//  MNA
//
//  Created by Apple on 29/12/17.
//  Copyright © 2017 KTeck. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications
import Reachability



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate ,PdfReaderDelegate{
    
    

    var window: UIWindow?
    var navController:UINavigationController?

    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            return appDelegate.persistentContainer.viewContext
        }else{
            return appDelegate.managedObjectContext
        }
    }
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        
        IQKeyboardManager.sharedManager().enable = true
        
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){
                (granted,error) in
                if granted{
                    application.registerForRemoteNotifications()
                } else {
                    print("User Notification permission denied: \(error?.localizedDescription)")
                }
            }
        } else {
            // Fallback on earlier versions
            
            
            
        }
        
        
        
        
        
        //Create pdf directory for storing pdfs
        let filemanager = FileManager.default
        let dirPath = "\(CommonHelper.getApplicationDirectoryPath())/pdffiles"
        if !filemanager.fileExists(atPath: dirPath){
            FileHelper.createDirectory("pdffiles")
        }else{
            print("Alredy Exist")
        }
        
        //Create CanvasImage directory for storing pdfs
        
        let dirPath2 = "\(CommonHelper.getApplicationDirectoryPath())/CanvasImage"
        if !filemanager.fileExists(atPath: dirPath2){
            FileHelper.createDirectory("CanvasImage")
        }else{
            print("Alredy Exist")
        }
        
        
        
       // self.copyFolders()
        
        self.copyFolderFromThisAppMainToUserDocument(folderName: "template")
        
        let userId = DefaultDataManager.getUserName()
        
        if userId != "" {
            let mainStoryBoard = UIStoryboard(name: "Agenda", bundle: nil)
            let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "AgendaVC") as! AgendaVC
            navController = UINavigationController(rootViewController: ViewController)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = navController
            print("Already Loged in")
        } else {
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            navController = UINavigationController(rootViewController: ViewController)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = navController
            print(" Loged in")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MNA")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if #available(iOS 10.0, *) {
            
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
            
        } else {
            // iOS 9.0 and below - however you were previously handling it
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                }
            }
            
        }
    
    
    
    }

    
    // iOS 9 and below
    lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "MNA", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("MNA.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Push notification methods
    //Push Notification
    //https://makeapppie.com/2017/01/03/basic-push-notifications-in-ios-10-and-swift/
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration failed!")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        DefaultDataManager.SaveDeviceToken(deviceTokenString)
        print("didRegisterForRemoteNotificationsWithDeviceToken \(deviceTokenString)")
       
    }
    
    
   
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("didReceiveRemoteNotification")
        
        print("\(userInfo)")
        
        if let aps = userInfo ["aps"] as? NSDictionary {
            //if let alert = aps["alert"] as? NSDictionary {
            //   if let message = alert["body"] as? NSString {
            
            if let url = aps["url"] as? NSString{
                //image url
            }
            
            
           
          
        }
        
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        print("userNotificationCenter  withCompletionHandler")
        
        let userinfo =  notification.request.content.userInfo
        
        print(userinfo)
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
    }
    //Mahendra Customization
    
    
    
    
    //Customise methods
    
    
    func loadBefore(){
        let resourcePath = Bundle.main.resourcePath
        
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(CommonHelper.getApplicationDirectoryPath())/template")
        if fileManager.fileExists(atPath: paths){
            
          //  try! fileManager.removeItem(atPath: paths)
            
        }else{
            print("Already dictionary created.")
        }
        
     let subdir = Bundle.main.resourceURL!.appendingPathComponent("template").path
        
      //  let  resorcePath = "\(resourcePath!)/template"
        
        try! fileManager.copyItem(atPath: subdir, toPath: paths)
        
        
    }

    
    func copyFolders() {
        let filemgr = FileManager.default
        
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let docsURL = dirPaths[0]
        
        let folderPath = Bundle.main.resourceURL!.appendingPathComponent("template").path
        let docsFolder = docsURL.appendingPathComponent("template").path
        copyFiles(pathFromBundle: folderPath, pathDestDocs: docsFolder)
    }
    
    func copyFiles(pathFromBundle : String, pathDestDocs: String) {
        let fileManagerIs = FileManager.default
        
        
        do {
            let filelist = try fileManagerIs.contentsOfDirectory(atPath: pathFromBundle)
            try? fileManagerIs.copyItem(atPath: pathFromBundle, toPath: pathDestDocs)
            
            for filename in filelist {
                try? fileManagerIs.copyItem(atPath: "\(pathFromBundle)/\(filename)", toPath: "\(pathDestDocs)/\(filename)")
            }
        } catch {
            print("\nError\n")
        }
    }
    
    
    func copyFolderFromThisAppMainToUserDocument(folderName: String) -> Bool {
        
        let fileMgr = FileManager.default
        let userDocumentURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first!
        let urlForCopy = userDocumentURL.appendingPathComponent(folderName, isDirectory: true)
        if let bundleURL = Bundle.main.url(forResource: folderName, withExtension: "") {
           
           /*  let paths = userDocumentURL.appendingPathComponent(folderName, isDirectory: true)
            
            let urlPath = NSURL.init(fileURLWithPath: urlForCopy)
            
            if fileMgr.contentsOfDirectory(at: urlForCopy, includingPropertiesForKeys: <#T##[URLResourceKey]?#>, options: FileManager.DirectoryEnumerationOptions)(atPath: urlPath ){
                 print("Already Exist Html file and removed created.")
                  try! fileMgr.removeItem(at: paths)
            }else{
                print("Already dictionary created.")
            }
            
            */
            
            
            
            
            
           /* let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = URL(fileURLWithPath: path)
            
            let filePath = url.appendingPathComponent("\(folderName)").path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                try! fileMgr.removeItem(at: filePath)
            } else {
                print("FILE NOT AVAILABLE")
            }*/
            
            // if exist we will copy it
            do {
                try fileMgr.copyItem(at: bundleURL, to: urlForCopy)
                return true
            } catch let error as NSError { // Handle the error
                print("\(folderName) copy failed! Error:\(error.localizedDescription)")
                return false
            }
        } else {
            print("\(folderName) not exist in bundle folder")
            return false
        }
    }
    
    
    
    
    //CORE DATA part
    
    
    //Open PDF files
    func openPDF(_ filePath :String, fileName:String , NewspaperId:Int, PageNo:Int, searchStr:String ){
        
        let fileMgr = FileManager.default
        
        let documentName = "\(NewspaperId)"
        // let documentUrl = NSURL.fileURL(withPath: filePath)
        
        let path:URL = CommonHelper.getDocumentsDirectory()
        /** Set thumbnails path */
        let thumbnailsPath = path.appendingPathComponent("\(documentName)")
        
        /** Get document from the App Bundle */
        let documentUrl:URL = NSURL.fileURL(withPath: filePath)
        
        /** Instancing the documentManager */
        let documentManager:MFDocumentManager = MFDocumentManager.init(fileUrl: documentUrl as URL!)
        
        var i:Int32 = 0
        var cropBox :CGRect = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        documentManager.getCropbox(&cropBox, andRotation: &i, forPageNumber: 1, withBuffer: false)
        
        if documentManager != nil {
            
            let pdfViewController:PdfReaderViewController = PdfReaderViewController.init(documentManager: documentManager)
         //   pdfViewController.pdFdelegate = self
            pdfViewController.proofCropBox = cropBox
 //           pdfViewController.newspaperId = NewspaperId as NSNumber
            pdfViewController.fileURL = (documentUrl as NSURL) as URL!
            pdfViewController.fileName = documentName
            
            // We are adding an image overlay on the first page on the bottom left corner
            var ovManager:OverlayManager = OverlayManager()
            ovManager.documentManager = documentManager
            ovManager.searchKeyword = searchStr
            pdfViewController.add(ovManager)
            
            
            //*****ZoomSize
            if (768 / cropBox.size.width) <= (1024 / cropBox.size.height) {
                pdfViewController.minZoomScale = (Float(768 / cropBox.size.width))
                pdfViewController.yAxispadding=((1024.0 - (Float(cropBox.size.height) * Float(pdfViewController.minZoomScale))) / 2 ) / pdfViewController.minZoomScale
                if (pdfViewController.yAxispadding < 0) {
                    pdfViewController.yAxispadding = 0
                }
                pdfViewController.xAxispadding = 0
                
            }else{
                pdfViewController.minZoomScale = (Float(1024 / cropBox.size.height))
                pdfViewController.xAxispadding=((768.0 - (Float(cropBox.size.width) * Float(pdfViewController.minZoomScale))) / 2 ) / pdfViewController.minZoomScale
                if (pdfViewController.xAxispadding < 0) {
                    pdfViewController.xAxispadding = 0
                }
                pdfViewController.yAxispadding = 0
            }
            //*****END
            
            /** Set resources folder on the manager */
          //  documentManager.resourceFolder = "\(thumbnailsPath)" //String(contentsOf: thumbnailsPath)
            
            /** Set document id for thumbnail generation */
            pdfViewController.documentId = documentName
            pdfViewController.setMode(UInt(MFDocumentModeOverflow.rawValue))
            
            /** Present the pdf on screen in a modal view */
            self.navController?.pushViewController(pdfViewController, animated: false)
            
        }else{
            
            let documentsUrl: URL = CommonHelper.getDocDirPath()
            do {
                var strPath =  documentsUrl.appendingPathComponent("pdffiles/\(fileName).json")
                if  fileMgr.fileExists(atPath: strPath.relativePath){
                    try fileMgr.removeItem(atPath: strPath.relativePath)
                }
                strPath =  documentsUrl.appendingPathComponent("pdffiles/\(fileName).pdf")
                if  fileMgr.fileExists(atPath: strPath.relativePath){
                    try fileMgr.removeItem(atPath: strPath.relativePath)
                }
            } catch {
                print("Could not clear temp folder: \(error)")
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                let alert = UIAlertController(title: "Alert!", message: "Document was not found.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            })
            
        }
    }

    
    func openPDFWithNewsPaperid(_ filePath :String, fileName:String , NewspaperId:Int){
       
        let fileMgr = FileManager.default
        let documentName = "\(NewspaperId)"
       // let documentUrl = NSURL.fileURL(withPath: filePath)
        
        let path:URL = CommonHelper.getDocumentsDirectory()
        /** Set thumbnails path */
        let thumbnailsPath = path.appendingPathComponent("\(documentName)")
            
        /** Get document from the App Bundle */
        let documentUrl:URL = NSURL.fileURL(withPath: filePath)
        
        /** Instancing the documentManager */
        let documentManager:MFDocumentManager = MFDocumentManager.init(fileUrl: documentUrl as URL!)
            
        var i:Int32 = 0
        var cropBox :CGRect = CGRect(x: 0.0, y: 20.0, width: 0.0, height: 0.0)
        documentManager.getCropbox(&cropBox, andRotation: &i, forPageNumber: 1, withBuffer: false)
        
        if documentManager != nil {
           
            let pdfViewController:PdfReaderViewController = PdfReaderViewController.init(documentManager: documentManager)
          //  let pdfViewController:PdfReaderVC = PdfReaderVC.init(documentManager: documentManager)
            pdfViewController.pdfdelegate = self
            pdfViewController.proofCropBox = cropBox
            pdfViewController.newspaperId = NewspaperId as NSNumber
            pdfViewController.fileURL = (documentUrl as NSURL) as URL!
            pdfViewController.fileName = documentName
            
            //*****ZoomSize
            if (768 / cropBox.size.width) <= (1024 / cropBox.size.height) {
                pdfViewController.minZoomScale = 1.0//(Float(768 / cropBox.size.width))
                pdfViewController.yAxispadding=((1024.0 - (Float(cropBox.size.height) * Float(pdfViewController.minZoomScale))) / 2 ) / pdfViewController.minZoomScale
                if (pdfViewController.yAxispadding < 0) {
                    pdfViewController.yAxispadding = 0
                }
                pdfViewController.xAxispadding = 0
                
            }else{
                pdfViewController.minZoomScale = 1.0//(Float(1024 / cropBox.size.height))
                pdfViewController.xAxispadding=((768.0 - (Float(cropBox.size.width) * Float(pdfViewController.minZoomScale))) / 2 ) / pdfViewController.minZoomScale
                if (pdfViewController.xAxispadding < 0) {
                    pdfViewController.xAxispadding = 0
                }
                pdfViewController.yAxispadding = 0
            }
            //*****END
            let userId = DefaultDataManager.getUserName()
            pdfViewController.userId = userId
            /** Set resources folder on the manager */
            documentManager.resourceFolder = thumbnailsPath.path//"\(thumbnailsPath)" //String(contentsOf: thumbnailsPath)

            /** Set document id for thumbnail generation */
            pdfViewController.documentId = documentName
            pdfViewController.setMode(UInt(MFDocumentModeOverflow.rawValue))
        //Send annoatation data to pdf
            
            if !DBHelper.IsEmpityAnnotations(Int64(NewspaperId)) {
                
                if  let mangeObject2:NSManagedObject = DBHelper.FetchAnnotationsListFromDbByNewsPaperId(Int64(NewspaperId)){
                    pdfViewController.mangeAnnotationObject = mangeObject2
                }
            
            }
          
            
            
            /** Present the pdf on screen in a modal view */
            self.navController?.pushViewController(pdfViewController, animated: false)
            
            
            }else{
          
            let documentsUrl: URL = CommonHelper.getDocDirPath()
            do {
                var strPath =  documentsUrl.appendingPathComponent("pdffiles/\(fileName).json")
                if  fileMgr.fileExists(atPath: strPath.relativePath){
                    try fileMgr.removeItem(atPath: strPath.relativePath)
                }
                
                strPath =  documentsUrl.appendingPathComponent("pdffiles/\(fileName).pdf")
                if  fileMgr.fileExists(atPath: strPath.relativePath){
                    try fileMgr.removeItem(atPath: strPath.relativePath)
                }
                
            } catch {
                print("Could not clear temp folder: \(error)")
            }

            DispatchQueue.main.async(execute: { () -> Void in
                let alert = UIAlertController(title: "Alert!", message: "Document was not found.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            })
            
            
        }
        
       
    }
    
    
    
    func openPDF(_ filePath :String, fileName:String ){
        

        // let documentUrl = NSURL.fileURL(withPath: filePath)
        let path:URL = CommonHelper.getDocumentsDirectory()
        /** Set thumbnails path */
//        let thumbnailsPath = path.appendingPathComponent("\(documentName)")
        /** Get document from the App Bundle */
        let documentUrl:URL = NSURL.fileURL(withPath: filePath)
        /** Instancing the documentManager */
        let documentManager:MFDocumentManager = MFDocumentManager.init(fileUrl: documentUrl as URL!)
        
        var i:Int32 = 0
        var cropBox :CGRect = CGRect(x: 0.0, y: 20.0, width: 0.0, height: 0.0)
        documentManager.getCropbox(&cropBox, andRotation: &i, forPageNumber: 1, withBuffer: false)
        let fileManager = FileManager.default
        
        if documentManager != nil {
            
        let pdfViewController:PdfReaderViewController = PdfReaderViewController.init(documentManager: documentManager)
         //   pdfViewController.pdFdelegate = self
            pdfViewController.proofCropBox = cropBox
            
            pdfViewController.fileURL = (documentUrl as NSURL) as URL!
            pdfViewController.fileName = fileName
            
            
            
            
            //*****ZoomSize
            if (768 / cropBox.size.width) <= (1024 / cropBox.size.height) {
                pdfViewController.minZoomScale = (Float(768 / cropBox.size.width))
                pdfViewController.yAxispadding=((1024.0 - (Float(cropBox.size.height) * Float(pdfViewController.minZoomScale))) / 2 ) / pdfViewController.minZoomScale
                if (pdfViewController.yAxispadding < 0) {
                    pdfViewController.yAxispadding = 0
                }
                pdfViewController.xAxispadding = 0
                
            }else{
                pdfViewController.minZoomScale = (Float(1024 / cropBox.size.height))
                pdfViewController.xAxispadding=((768.0 - (Float(cropBox.size.width) * Float(pdfViewController.minZoomScale))) / 2 ) / pdfViewController.minZoomScale
                if (pdfViewController.xAxispadding < 0) {
                    pdfViewController.xAxispadding = 0
                }
                pdfViewController.yAxispadding = 0
            }
            //*****END
            
            
            
            
            /** Set documet id for thumbnail generation */
            pdfViewController.documentId = fileName
            pdfViewController.setMode(UInt(MFDocumentModeOverflow.rawValue))
            
            /** Present the pdf on screen in a modal view */
            self.navController?.pushViewController(pdfViewController, animated: false)
            
        }else{
            
            let documentsUrl: URL = CommonHelper.getDocDirPath()
            do {
                var strPath =  documentsUrl.appendingPathComponent("pdffiles/\(fileName).json")
                if  fileManager.fileExists(atPath: strPath.relativePath){
                    try fileManager.removeItem(atPath: strPath.relativePath)
                }
                
                strPath =  documentsUrl.appendingPathComponent("pdffiles/\(fileName).pdf")
                if  fileManager.fileExists(atPath: strPath.relativePath){
                    try fileManager.removeItem(atPath: strPath.relativePath)
                }
                
            } catch {
                print("Could not clear temp folder: \(error)")
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                let alert = UIAlertController(title: "Alert!", message: "Document was not found.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            })
            
        }
        
        
        
        
        
    }
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //**********        pdfController Delegate methods
    func pdf_ResetCanvas(_ selDictionary: String!) {
        
    }
    
    func pdf_SaveCanvas(_ newspaperId: Int, jsonString: String!, draw drawImage: UIImage!, fileName: String!) {
        
    
        
        print("pdf_DeleteComment App delegate ---  \(newspaperId)")
        CommonHelper.saveServerAnnotations(jsonString: jsonString, NewsPaperId: newspaperId) { (status) in
           
            //Save Image on server
            
          /*  if let imageData = UIImagePNGRepresentation(drawImage) {
                let encodedImageData = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                
                let urlString = BaseUrl + MNAUrl_fileuploadOnServer
                var request = URLRequest(url: URL(string: urlString)!)
                request.httpMethod = "POST"
               // request.httpBody = postString.data(using: .utf8)
                request.httpBody = self.createRequestBodyWith( filePathKey: "", boundary: self.generateBoundaryString(), yourImage: drawImage, fileName: fileName)
                
              //  createRequestBodyWith(parameters:nil, filePathKey:yourKey, boundary:self.generateBoundaryString,

                
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print("error=(error)")
                        return
                    }
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                        print("statusCode should be 200, but is (httpStatus.statusCode)")
                        print("response = (response)")
                    }
                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = (responseString)")
                }
                task.resume()
            }
        */
            
            
            //local save image
           // let imgfolderPath = CommonHelper.getApplicationDirectoryPath()
            let documentsUrl: URL = CommonHelper.getDocDirPath()
            let imgPath = documentsUrl.appendingPathComponent("CanvasImage/\(fileName!)")//imgfolderPath + fileName
           // let urlPath  = NSURL (string: imgPath)
            FileHelper.SaveImageAtPtah(imgPath as NSURL, image: drawImage)
            //ENDED
            
            let alert = UIAlertController(title: "Alert", message: "Canvas info save succesfully. ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                
            }))
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
      
        
        
    }
    


func createRequestBodyWith( filePathKey:String, boundary:String , yourImage:UIImage, fileName:String ) -> NSData{
    
    let body = NSMutableData()
    
    /*for (key, value) in parameters {
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        body.appendString(string: "\(value)\r\n")
    }*/
    
    body.appendString(string: "--\(boundary)\r\n")
    
    var mimetype = "image/png"
    
    let defFileName = fileName
    
    let imageData = UIImagePNGRepresentation(yourImage)
    
    body.appendString(string: "Content-Disposition: form-data; name=\"\(defFileName)\"; userfile=\"\(defFileName)\"\r\n")
    body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
    body.append(imageData!)
    body.appendString(string: "\r\n")
    
    body.appendString(string: "--\(boundary)--\r\n")
    
    return body
}



func generateBoundaryString() -> String {
    return "Boundary-\(NSUUID().uuidString)"
}









    func pdf_DeleteCanvas(_ anotationId: String!, newsPaperId: Int, fileName: String!) {
        
    
        
        print("pdf_DeleteCanvas ---  \(anotationId) id \(newsPaperId)")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.getContext()
        guard let anno = Int(anotationId) else{
            return
        }
        
        
        CommonHelper.deleteServerAnnotation(anno, NewsPaperId: newsPaperId) { (status) in
             print("deleteServerAnnotation")
            
            if status {
                let documentsUrl: URL = CommonHelper.getDocDirPath()
                let imgPath = documentsUrl.appendingPathComponent("CanvasImage/\(fileName!)")
                FileHelper.deleteImageDocumentDirectoryByPath(imgPath)
            }
            
        }
        
        
        
    }
    
    /*func pdf_ResetCanvas(_ retDict: String!) {
        
    }*/
    
    func pdf_SaveComment(_ JsonString: String!, saveCommentText:String , newspaperId :Int) {
        
        print("pdf_SaveComment ---  \(JsonString)")
        
        let reachability = Reachability()!
        if !reachability.isReachable {
            let alert = UIAlertController(title: "Alert", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
        
        
        if saveCommentText == "" {
            
            let alert = UIAlertController(title: "Alert", message: "Please insert your comments and click Apply.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }else{//Add comment
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.getContext()
            
            //first Add annoatation in server
            CommonHelper.saveServerAnnotations(jsonString: JsonString, NewsPaperId: newspaperId) { (status) in
                
                let alert = UIAlertController(title: "Alert", message: "Comment info save succesfully. ", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    
                }))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
            
            //add from local core data
            
            
            
            
            
            
            
          /*  CommonHelper.saveServerAnnotations(jsonString: JsonString, NewsPaperId: newspaperId, completion: { (status) in
                //save
            
                if status {
                    
                    let alert = UIAlertController(title: "Alert", message: "Success.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Alert", message: "Try Again.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            
            })
            */
            
            
        }
    
    
    }
    
    
    
    func pdf_DeleteComment(_ NewspaperId: UInt,  annotationId anotationId: UInt) {
     
        print("pdf_DeleteComment ---  \(NewspaperId)")
        
        //Checking annotation
        let reachability = Reachability()!
        if !reachability.isReachable {
            let alert = UIAlertController(title: "No internet connection", message: "This application requires a WiFi or cellular network to connect to the server. Please ensure that you have an active connection and/or Airplane mode is turned off.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
        
        //remove annotation Confirmation
        let alertController = UIAlertController(title: "Alert!", message: "Deleting this pushpin will also delete the comment. You cannot undo this operation.", preferredStyle: UIAlertControllerStyle.alert)
        
        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.getContext()
            //remove annotation Code
            //first delete annoatation from server
            CommonHelper.deleteServerAnnotation(Int(anotationId), NewsPaperId: Int(NewspaperId), completion: { (status) in
                
                if status {
                    
                    let alert = UIAlertController(title: "Delete", message: "Success.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Delete", message: "Try Again.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
                
                
                
            })
            
            
        }
        
        let NoAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            
        }
        alertController.addAction(yesAction)
        alertController.addAction(NoAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    

  //End Delegate method
    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
}
}
