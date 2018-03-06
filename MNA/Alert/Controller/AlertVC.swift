//
//  AlertVC.swift
//  MNA
//
//  Created by Apple on 29/12/17.
//  Copyright © 2017 KTeck. All rights reserved.
//

import UIKit
import Reachability



class AlertVC: UIViewController {

    @IBOutlet weak var alertTableView: UITableView!
    
    var alertList:[AlertModel] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertTableView.estimatedRowHeight = 44.0
        alertTableView.rowHeight = UITableViewAutomaticDimension
        
        getAlertList()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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

    
    func getAlertList(){
        
        let reachability = Reachability()!
        if !reachability.isReachable {
            let alert = UIAlertController(title: "Alert", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
           
            
            
            
            DispatchQueue.main.async(execute: { [weak self] () -> Void  in
                guard let strongSelf = self else { return }
                //strongSelf.activityIndicator.stopAnimating()
            })
            return
        }
        
        
        
        let userId = DefaultDataManager.getUserName() // qwe167
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //activityIndicator.startAnimating()
        let urlString = AlertBaseUrl + MNA_Alert + "method=notification&limit=0&userid=\(userId)"
        
        MNAConnectionHelper.GetRequestFromJson(url: urlString) { (responce, status) in
            DispatchQueue.main.async(execute: { () -> Void  in
               // self.activityIndicator.stopAnimating()
               
            })
            
            if responce.count > 0 {
                self.alertList = DBHelper.saveAlertNotification(responce)
                DispatchQueue.main.async(execute: { () -> Void  in
                    // self.activityIndicator.stopAnimating()
                    self.alertTableView.reloadData()
                })
            }else{
                //error
            }
        }
    
        
    }
    
    
    
    
    
    
}





extension AlertVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1.0
        }else{
            return 2.0
        }
    }
    
   /* func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) -> CGFloat  {
        return 70.0
    }*/
                   
    func tableView(tableView: UITableView,
                   heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        
        return UITableViewAutomaticDimension
    }

                   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return alertList.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath ) as! UITableViewCell
        
        let alert :  AlertModel = alertList[indexPath.row] as AlertModel
       
        if let date = alert.DT_CreatedOn {
            cell.textLabel?.text = date
            cell.textLabel?.textColor = .blue
        }
        
        if let desc = alert.S_Description {
            cell.detailTextLabel?.text = desc
        }
        
        return cell
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    
    
}
