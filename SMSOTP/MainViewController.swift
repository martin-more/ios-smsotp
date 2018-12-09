//
//  ViewController.swift
//  SMSOTP
//
//  Created by Martin More on 12/8/18.
//  Copyright © 2018 Martin More. All rights reserved.
//

import UIKit
import IBMMobileFirstPlatformFoundation

class MainViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    
    /// viewDidLoad
    override func viewDidLoad() {
        // super.viewDidLoad()
        let url = URL(string: "/adapters/JavaAdapter/users/")
        let resourceRequest = WLResourceRequest(url: url, method: WLHttpMethodGet)
        
        resourceRequest?.send(completionHandler: {(response, error) -> Void in
            if error == nil {
                self.enableButtons (isRegistered: response?.responseText == "true")
            } else {
                self.alert (msg: "Oops, something wrong happen!")
            }
        })
    }
    
    
    /// smsOTPLogin
    ///
    /// - Parameter sender: sender description
    @IBAction func smsOTPLogin(sender: AnyObject) {
        WLAuthorizationManager.sharedInstance()?.obtainAccessToken(forScope: "smsOTP", withCompletionHandler: {(accessToken, error) in
            if (error == nil) {
                self.alert(msg: "Success :-)")
            } else {
                self.alert(msg: "Failed :-(")
            }
        })
    }
    
    
    /// registerNumber
    ///
    /// - Parameter sender: sender description
    @IBAction func registerNumber(sender: AnyObject) {
        MainViewController.codeDialog(title: "Phone Number", message: "Please provide your phone number", isCode: true, completion: {(phone, ok) -> Void in
            if ok {
                let url = URL(string: "/adapters/smsOtp/phone/register/\(phone)")
                let resourceRequest = WLResourceRequest(url: url, method: WLHttpMethodPost)
                resourceRequest?.send(completionHandler: {(response, error) -> Void in
                    if error == nil {
                        self.enableButtons(isRegistered: response?.responseText == "true")
                    } else {
                        self.alert(msg: "Oops, failed to register.")
                    }
                })
            }
        })
    }
    
    /**
     *  enableButtons
    */
    private func enableButtons (isRegistered : Bool) {
        self.registerButton.isEnabled = !isRegistered;
        self.loginButton.isEnabled = isRegistered;
    }
    
    /**
     *  alert
    */
    private func alert (msg : String) {
        let alert = UIAlertController(title: "SMS OTP Login", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     *  codeDialog
     */
    internal static func codeDialog (
        title: String,
        message: String,
        isCode : Bool,
        completion: @escaping (_ code: String, _ ok: Bool) -> Void) {
        let codeDialog = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        var codeTxtField :UITextField?
        
        codeDialog.addTextField { (txtCode) -> Void in
            codeTxtField = txtCode
            if (isCode) {
                codeTxtField?.isSecureTextEntry = true
            }
            txtCode.placeholder = title
        }
        
        codeDialog.addAction(UIAlertAction(title: "Ok", style:.default, handler: { (action: UIAlertAction!) in
            completion (codeTxtField!.text!, true)
        }))
        
        codeDialog.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            completion ("", false)
        }))
        
        UIApplication.shared.delegate?.window!!.rootViewController!.present(codeDialog, animated: true, completion: nil)
    }
}
