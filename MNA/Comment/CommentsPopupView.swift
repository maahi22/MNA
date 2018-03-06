//
//  CommentsPopupView.swift
//  MNA
//
//  Created by Apple on 29/12/17.
//  Copyright © 2017 KTeck. All rights reserved.
//

import UIKit
import  Reachability


class CommentsPopupView: UIViewController {

    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var textViewComment: UITextView!
    @IBOutlet weak var lblcreationDate: UILabel!
    @IBOutlet weak var textTitle: UILabel!
    
    var NotesDatetime = ""
    var newspaperId = 0
    var page = 0
    var pdfReader:PdfReaderVC?
    var  blDeletePushpin = false
    var isRevision = false
    var point:CGPoint = CGPoint()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func getComments(_ annotationId:Int) -> Bool{
        
        
        return true
    }
    
    
    
    
    
    @IBAction func btnCommentDone(_ sender: Any) {
    
    
        
        
        guard
            let strComment = textViewComment.text, !strComment.isEmpty
            else {
                return
        }
        
        let reachability = Reachability()!
        if !reachability.isReachable {
            let alert = UIAlertController(title: "Alert", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        let date = formatter.date(from: lblcreationDate.text!)!
    
        
        let ti = date.timeIntervalSince1970
        
        
        let x1 = 0.0
        let y1 = 0.0
        let  annotationId = 0
        let userId = DefaultDataManager.getUserName()
        
        let annotation = "{\"UserId\":\"\(userId)\",\"NewspaperId\":\(newspaperId),\"Annotation\":[{\"id\":\(annotationId),\"type\":\"text\",\"PointX\":\(x1),\"PointY\":\(y1),\"createdOn\":\(ti),\"pageNumber\":\(page),\"annotationText\":\"\(strComment)\",\"imageName\":\"\",\"borderThickness\":0,\"drawingType \": \"p\",\"lineColor\":0,\"height \":0,\"width\":0,\"lineThickness \":0,\"xInMinus\" : false,\"yInMinus\":false}]}"
        
        
        
        
    }
    
    
    @IBAction func btnCommentDelete(_ sender: Any) {
    
    
    
    }
    
    
    
    
}


//extension CommentsPopupView : UITextviewDelegate {
//    
//    
//    
//}



