//
//  HomeVC.swift
//  MNA
//
//  Created by Apple on 29/12/17.
//  Copyright © 2017 KTeck. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    //@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   // @IBOutlet weak var webview: UIWebView!
    
    @IBOutlet weak var btnBits: UIButton!
    @IBOutlet weak var btnAgenda: UIButton!
    @IBOutlet weak var btnDebate: UIButton!
    @IBOutlet weak var btnActs: UIButton!
    @IBOutlet weak var btnPQ: UIButton!
    @IBOutlet weak var detailView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        let rotate = CGAffineTransform(rotationAngle: -1.5)
        let stretchAndRotate = rotate.scaledBy(x: 1.0, y: 1.0)
        
        btnAgenda.transform = stretchAndRotate
        btnBits.transform = stretchAndRotate
        btnDebate.transform = stretchAndRotate
        btnActs.transform = stretchAndRotate
        btnPQ.transform = stretchAndRotate
        
        
        
        
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
    
    
    
    
    @IBAction func sidebarClick(_ sender: UIButton) {
   
        if sender.tag == 1 {
            let mainStoryBoard = UIStoryboard(name: "Agenda", bundle: nil)
            let controller = mainStoryBoard.instantiateViewController(withIdentifier: "AgendaVC") as! AgendaVC
            controller.view.frame = self.view.bounds;
            controller.willMove(toParentViewController: self)
            self.detailView.addSubview(controller.view)
            self.addChildViewController(controller)
            controller.didMove(toParentViewController: self)

           // navigationController?.pushViewController(ViewController,  animated: true)
            
        }else if sender.tag == 2 {
            let mainStoryBoard = UIStoryboard(name: "Detail", bundle: nil)
            let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            navigationController?.pushViewController(ViewController,  animated: true)
            
        }else if sender.tag == 3 {
            let mainStoryBoard = UIStoryboard(name: "Library", bundle: nil)
            let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LibraryVC") as! LibraryVC
            navigationController?.pushViewController(ViewController,  animated: true)
            
        }else if sender.tag == 4 {
            let mainStoryBoard = UIStoryboard(name: "Library", bundle: nil)
            let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LibraryVC") as! LibraryVC
            navigationController?.pushViewController(ViewController,  animated: true)
            
        }else if sender.tag == 5 {
            let mainStoryBoard = UIStoryboard(name: "OP", bundle: nil)
            let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "OPVC") as! OPVC
            navigationController?.pushViewController(ViewController,  animated: true)
            
        }else if sender.tag == 6 {
            
        }
        
        
    
    }
    
    
    
    
    
    
    
    
    
    //
    @IBAction func btnToolbarMyLibraryClicked(_ sender: Any) {
        
        
        
    }
    
    @IBAction func btnToolbarLogOutClicked(_ sender: Any) {
        
        
        
    }
    

}


