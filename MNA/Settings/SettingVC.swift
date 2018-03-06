//
//  SettingVC.swift
//  MNA
//
//  Created by Apple on 29/12/17.
//  Copyright © 2017 KTeck. All rights reserved.
//

import UIKit
import Reachability



class SettingVC: UIViewController {

    
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    
    
    var isLogout:Bool =  true
    
    
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

    
    
    @IBAction func btnSaveClicked(_ sender: Any) {
    
        let userId = DefaultDataManager.getUserName()
        let savePassword = DefaultDataManager.getPassword()
        //Check network Connection
        guard
            let oldPassword = txtOldPassword.text, !oldPassword.isEmpty,
            let newPassword = txtNewPassword.text, !newPassword.isEmpty,
            let confirmPassword = txtConfirmPassword.text, !confirmPassword.isEmpty
            else {
                
                let alert = UIAlertController(title: "Alert", message: "Please enter the login credential", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                txtOldPassword.resignFirstResponder()
                txtNewPassword.resignFirstResponder()
                txtConfirmPassword.resignFirstResponder()
                return
        }
        
        //Check network Connection
        let reachability = Reachability()!
        if !reachability.isReachable {
            let alert = UIAlertController(title: NoInterNetAlertTitle, message: NoInterNetAlertMsg, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            DispatchQueue.main.async(execute: { [weak self] () -> Void  in
                guard let strongSelf = self else { return }
                //strongSelf.activityIndicator.stopAnimating()
            })
            return
        }
        
        if newPassword != confirmPassword {
            let alert = UIAlertController(title: "Alert", message: "New password and confirmed password not matched", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            DispatchQueue.main.async(execute: { [weak self] () -> Void  in
                guard let strongSelf = self else { return }
                //strongSelf.activityIndicator.stopAnimating()
            })
            return
        }
        
        if savePassword != oldPassword {
            let alert = UIAlertController(title: "Alert", message: "Enter old password and your password don't matched", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            DispatchQueue.main.async(execute: { [weak self] () -> Void  in
                guard let strongSelf = self else { return }
                //strongSelf.activityIndicator.stopAnimating()
            })
            return
        }
        
        
        
        
        
        //activityIndicator.startAnimating()
        txtOldPassword.resignFirstResponder()
        txtNewPassword.resignFirstResponder()
        txtConfirmPassword.resignFirstResponder()

        let urlString = BaseUrl + MNAUrl_ChangePassword
        let paramString = ["UserId":userId,"OldPassword":oldPassword,"NewPassword":newPassword] as [String : Any]
        MNAConnectionHelper.ChangePasswordCalled(url: urlString, paramString: paramString) { (Message, status) in
            DispatchQueue.main.async(execute: { () -> Void  in
                // self.activityIndicator.stopAnimating()
                
            })
            
            if !status {
                DispatchQueue.main.async(execute: { [weak self] () -> Void  in
                    
                    guard let strongSelf = self else { return }
                    var msg = "There is some problem Please try again later!."
                    if Message != "" {
                        msg = Message
                    }
                    let alert = UIAlertController(title: "Error", message:msg , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    strongSelf.present(alert, animated: true, completion: nil)
                    return;
                })
            }else{
                
                DispatchQueue.main.async(execute: { [weak self] () -> Void  in
                    guard let strongSelf = self else { return }
                    

                    DefaultDataManager.SaveUserName(userId)
                    DefaultDataManager.SavePassword(newPassword)
                    
                    let alert = UIAlertController(title: "Success", message: "Password changed successfully.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    strongSelf.present(alert, animated: true, completion: nil)
                })
                
               
            }
            
            
         
            
            
        }
        
    
    }
    
    
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnLogOut(_ sender: Any) {
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you wish to logout?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            if self.isLogout {
                
                self.isLogout = false
                
                /*if  CommonHelper.deleteUserCredential == true{
                    
                    self.navigationController?.popViewController(animated: true)
                }*/
                
                
            }
        }
        
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            
        }
        alertController.addAction(yesAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
}





extension SettingVC:UITextViewDelegate {
    
    
    
}




