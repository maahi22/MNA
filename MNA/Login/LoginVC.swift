//
//  LoginVC.swift
//  MNA
//
//  Created by Apple on 29/12/17.
//  Copyright © 2017 KTeck. All rights reserved.
//

import UIKit
import Reachability


class LoginVC: UIViewController {

   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var currentUrl:String = ""
    var strLoginUrl:String = ""
    var strPageData:String = ""
    var showPasswordStatus:Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        
        //if let userName  = DefaultDataManager.getUserName(){
           txtUsername.text = DefaultDataManager.getUserName()
        //}
        
       // if let password  = DefaultDataManager.getPassword(){
            txtPassword.text = DefaultDataManager.getPassword()
      //  }
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        
        
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
    
    
    
    @objc func tap(gesture: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
    
    
    
    @IBAction func btnLibraryClicked(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Library", bundle: nil)
        let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LibraryVC") as! LibraryVC
        navigationController?.pushViewController(ViewController,  animated: false)
    }
    
    @IBAction func showPassword(_ sender: Any) {
        
        if showPasswordStatus {
            txtPassword.isSecureTextEntry = false
            showPasswordStatus = false
        }else{
             txtPassword.isSecureTextEntry = true
            showPasswordStatus = true
        }
        
    }
    
    
    
    
    
    @IBAction func userLogin(_ sender: Any) {
        
        guard
            let userName = txtUsername.text, !userName.isEmpty,
            let password = txtPassword.text, !password.isEmpty
            else {
                
                let alert = UIAlertController(title: "Alert", message: "Please enter the login credential", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                txtUsername.resignFirstResponder()
                txtPassword.resignFirstResponder()
                return
        }
        
        let reachability = Reachability()!
        if !reachability.isReachable {
            let alert = UIAlertController(title: "Alert", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //Save inside
        
        activityIndicator.startAnimating()
        let urlString = BaseUrl + MNA_SignIn
        let paramString = ["UserId":userName,"Password":password] as [String : Any]
    
        MNAConnectionHelper.LoginCalled(url: urlString, paramString: paramString) { (status) in
            
            if status {
                    
                    DispatchQueue.main.async(execute: { [weak self]() -> Void in
                        guard let strongSelf = self else { return }
                        
                        strongSelf.activityIndicator.stopAnimating()
                        
                        DefaultDataManager.SaveUserName(userName)
                        DefaultDataManager.SavePassword(password)
                        
                        let mainStoryBoard = UIStoryboard(name: "Agenda", bundle: nil)
                        let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "AgendaVC") as! AgendaVC
                        strongSelf.navigationController?.pushViewController(ViewController,  animated: true)
                    })
                }else{
                    DispatchQueue.main.async(execute: { [weak self]() -> Void in
                        guard let strongSelf = self else { return }
                        strongSelf.activityIndicator.stopAnimating()
                        
                        let alert = UIAlertController(title: "Error!", message: "Wrong login credential, Please try again", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        strongSelf.present(alert, animated: true, completion: nil)
                    })
            }
        }
   
    
    
    }
    
    
    
    
    

}


extension  LoginVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == .next {
            txtPassword.becomeFirstResponder()
        }else  if textField.returnKeyType == .go {
            self.userLogin(self)
            
        }
        textField.resignFirstResponder()
        //self.view.endEditing(true)
        return false
    }
    
}
