//
//  SMSCodeChallengeHandler.swift
//  SMSOTP
//
//  Created by Martin More on 12/8/18.
//  Copyright © 2018 Martin More. All rights reserved.
//

import Foundation
import IBMMobileFirstPlatformFoundation

public class SMSCodeChallengeHandler: SecurityCheckChallengeHandler {
    
    public static let securityCheck = "smsOTP"
    
    /// handleChallenge implementation
    ///
    /// - Parameter challenge: challenge description
    override public func handleChallenge(_ challenge: [AnyHashable : Any]!) {
        MainViewController.codeDialog(
            title: "SMS code",
            message: "Please provide your sms code",
            isCode: true,
            completion: {(code, ok) -> Void in
                if ok {
                    self.submitChallengeAnswer(["code": code])
                } else {
                    self.cancel()
                }}
        )
    }
}
