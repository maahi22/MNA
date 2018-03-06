//
//  CanvasVC.swift
//  MNA
//
//  Created by Apple on 29/12/17.
//  Copyright © 2017 KTeck. All rights reserved.
//

import UIKit
//import SwiftSignatureView



protocol CanvasDelegate {
    func returnSignatureImage(_ image : UIImage)
}



class CanvasVC: UIViewController {

    
    
   /* var lastPoint:CGPoint?
    var red:CGFloat?
    var green:CGFloat?
    var blue:CGFloat?
    var brush:CGFloat?
    var opacity:CGFloat?
    var mouseSwiped:Bool*/
  //  @IBOutlet weak var canvasView: SwiftSignatureView!
    var delegate:CanvasDelegate?
    
    
    
    
    
    
    
    
    
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
    
    
    @IBAction func pencilPressed(_ sender: Any) {
    }
    
    
    @IBAction func eraserPressed(_ sender: Any) {
    }
    
    
    
    @IBAction func reset(_ sender: Any) {
    }
    
    @IBAction func save(_ sender: Any) {
    }
    

    /*@IBAction func delete(_ sender: Any) {
    }*/
    
    
    //Extra methods
    func getCommentImage(_ annotationId:NSNumber)-> Bool{
        
            return false
    }
    
}
