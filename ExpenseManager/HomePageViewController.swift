//
//  HomePageViewController.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 15/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//

import UIKit
import CoreData

class HomePageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool){
        let status = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if(status){
            performSegue(withIdentifier: "logInAlready", sender: self)
        }
        else{
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func logIn(_ sender: Any) {
        
        performSegue(withIdentifier: "logInPage", sender: self)
    }
    @IBAction func signUp(_ sender: Any) {
        
        performSegue(withIdentifier: "signUpPage", sender: self)
    }
}
