//
//  AppUtility.swift
//  Synergista
//
//  Created by Maxtra Technologies P LTD on 04/09/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit


//MARK: - global variables

let mainColor: UIColor = #colorLiteral(red: 0.03102169186, green: 0.08856060356, blue: 0.3840117753, alpha: 1)
let buttonBGColor: UIColor = #colorLiteral(red: 0.03102169186, green: 0.08856060356, blue: 0.3840117753, alpha: 0.5)
let menuBGColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
let mainNavBarColor:UIColor = #colorLiteral(red: 0.03102169186, green: 0.08856060356, blue: 0.3840117753, alpha: 1)
let stretchNavBarColor:UIColor = #colorLiteral(red: 0.03102169186, green: 0.08856060356, blue: 0.3840117753, alpha: 0.9017283818)
//78,113,33




//MARK: - global functions
//load mainview
/*func loadMainView()   {
    guard let mainView = UIStoryboard(name: Screens.SideMenu.rawValue, bundle: nil).instantiateInitialViewController() as? CustomSideMenuViewController
        else{
            return
    }
    UIApplication.shared.keyWindow?.rootViewController = mainView
}*/

//MARK: - OTP Generation
func generateOTP() -> String {
    var fourDigitNumber: String {
        var result = ""
        repeat {
            // Create a string with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
        } while Set<Character>(result).count < 4
        return result
    }
    return fourDigitNumber
}

//MARK: - Date formatter's metthod

func getStringFromDateString(dateString: String, dateFormat:String, desireDateFormat:String) -> String? {
    guard let date = getDateFromString(dateString: dateString, dateFormat: dateFormat) else { return nil }
    guard let desireDateString = getStringFromDate(date: date, dateFormat: desireDateFormat) else { return nil }
    return desireDateString
}

func getDateFromString(dateString: String, dateFormat:String) -> Date? {
    let formater = DateFormatter()
    formater.dateFormat = dateFormat//"yyyy-mm-dd HH:mm:ss"
    guard let date = formater.date(from: dateString) else{
        return nil
    }
    return date
}

func getStringFromDate(date: Date, dateFormat:String) -> String? {
    let formater = DateFormatter()
    formater.dateFormat = dateFormat//"yyyy-mm-dd HH:mm:ss"
    let date = formater.string(from: date)
    return date
}

func getDateFromTimeStamp(unixTimeStamp: Double, dateFormat:String) ->String?{
    let date = Date(timeIntervalSince1970: unixTimeStamp/1000)
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    //dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = dateFormat //Specify your format that you want
    let strdate = dateFormatter.string(from: date)
    return strdate
}

func getTimestampFromString(dateString: String, dateFormat:String)-> Double?{
    guard let date = getDateFromString(dateString: dateString, dateFormat: dateFormat)
        else{
            return nil
    }
    let dateStamp:TimeInterval = date.timeIntervalSince1970 * 1000
    return dateStamp
}

func getFraction() -> String{
    let formater = DateFormatter()
    formater.dateFormat = "yyyyMddHHmmss"
    let date = formater.string(from: Date())
    let randomDigit = generateOTP()
    return date + randomDigit
}



//MARK : - Compostion
extension String{
    func isValidEmail(_ testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //validation
    func isValidEmail() -> Bool {
        print("validate emilId: \(self)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
    
    
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return NSAttributedString()
        }
    }
}

////////// 971564804596

//json response keys
/////////////
//MARK: - API Methods
public enum APIMethods: String{
    case Login = "Login"
    case Logout = "Logout"
    case securityquestions = "securityquestions"
    case userInfo = "userInfo"
    case initiateRegistration = "initiateRegistration"
    case submitactivationcode = "submitactivationcode"
    case registerCustomer = "registerCustomer"
    case submitPassword = "submitPassword"
    case passwordChange = "passwordChange"
    case submitSecurityQuestion = "submitSecurityQuestion"
    case forgottenpassword = "forgottenpassword"
    case checksession = "checksession"
    case notifyDevice = "notifyDevice"
}


//MARK: - Side Menu Options
enum SideMenuOptions: String {
    case showHome = "showHome"
    case containSideMenu = "containSideMenu"
    case showMyWallet = "showMyWallet"
    case showCard = "showCard"
    case showRestaurant = "showRestaurant"
    case showEducation = "showEducation"
    case showMoneyTransfer = "showMoneyTransfer"
    
    
}

//MARK: - Storyboards
enum Screens: String {
    case LaunchScreen = "LaunchScreen"
    case Welcome = "Welcome"
    case Login = "Login"
    case Dashboard = "Dashboard"
    case SideMenu = "SideMenu"
}


//set navigation bar color and text color
func setAppTheme(){
    //To change Navigation Bar Background Color
    UINavigationBar.appearance().barTintColor = mainNavBarColor
    //To change Back button title & icon color
    UINavigationBar.appearance().tintColor = .white
    //To change Navigation Bar Title Color
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
}

func setStatusBar() {
    UIApplication.shared.statusBarStyle = .lightContent
    
    let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
    if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
        statusBar.backgroundColor = mainColor
    }
    
}

///show alert message
//MARK: - For Alert Message
func showAlertMessage(vc: UIViewController, title:String, message:String) -> Void {
    let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    
    alertCtrl.addAction(alertAction)
    vc.present(alertCtrl, animated: true, completion: nil)
}

func showAlertMessage(vc: UIViewController, title:String, message:String,actionTitle: String?, handler:((UIAlertAction)->Void)?) -> Void {
    let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let alertAction = UIAlertAction(title: actionTitle, style: .cancel, handler: handler)
    
    alertCtrl.addAction(alertAction)
    vc.present(alertCtrl, animated: true, completion: nil)
}



/*func getLoggedUser() -> User? {
 guard let data = UserDefaults.standard.data(forKey: "userObject")
 else{
 return nil
 }
 let user = try? JSONDecoder().decode(User.self, from: data)
 return user
 }
 */


extension UIButton{
    func setButtonTheme(){
        setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        backgroundColor = buttonBGColor
        layer.cornerRadius = 4.0
    }
}

protocol HideableHairlineViewController {
    func hideHairline()
    func showHairline()
}

extension HideableHairlineViewController where Self: UIViewController {
    
    func hideHairline() {
        findHairline()?.isHidden = true
    }
    
    func showHairline() {
        findHairline()?.isHidden = false
    }
    
    private func findHairline() -> UIImageView? {
        return navigationController?.navigationBar.subviews
            .flatMap { $0.subviews }
            .flatMap { $0 as? UIImageView }
            .filter { $0.bounds.size.width == self.navigationController?.navigationBar.bounds.size.width }
            .filter { $0.bounds.size.height <= 2 }
            .first
    }
    
}

extension UIView {
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: -5, height: 5)
        self.layer.shadowRadius = 5
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UITableView{
    func setTableViewViewBackground() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Bg"))
        // center and scale background image
        imageView.contentMode = .scaleAspectFill
        self.backgroundView = imageView
    }
}

