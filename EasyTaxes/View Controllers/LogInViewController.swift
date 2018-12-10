//
//  LogInViewController.swift
//  EasyTaxes
//
//  Created by Joel Gutierrez on 11/16/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

import UIKit
import GoogleSignIn

class LogInViewController: UIViewController, GIDSignInUIDelegate {
    //MARK: - vc variables
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signInGoogleSetUp()
        self.buttonGoogleSetUp()
    }
    
    func signInGoogleSetUp() {
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
    }
    
    // choose theme for google button
    func buttonGoogleSetUp() {
        self.signInButton.style = .wide
        self.signInButton.colorScheme = .dark
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
