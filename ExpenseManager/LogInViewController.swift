//
//  LogInViewController.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 15/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//

import UIKit
import CoreData

class LogInViewController: UIViewController {
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let status = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if(status){
            performSegue(withIdentifier: "logInSuccess", sender: self)
        }
        else{
            
            
            self.navigationController?.navigationBar.isHidden = false
            passwordText.frame.size.height = 40
            usernameText.frame.size.height = 40
            
            let cornerRadius : CGFloat = 5
            
            let myColor = UIColor.black
            passwordText.layer.borderColor = myColor.cgColor
            passwordText.layer.cornerRadius = cornerRadius
            passwordText.layer.borderWidth = 1.0
            
            usernameText.layer.borderColor = myColor.cgColor
            usernameText.layer.cornerRadius = cornerRadius
            usernameText.layer.borderWidth = 1.0
            
            self.navigationController?.navigationBar.isHidden = false
            self.navigationItem.hidesBackButton = true
            self.navigationItem.title = "Login"
        }
    }
    
    @IBAction func loginEvent(_ sender: Any) {
        
        
        if(usernameText.text == "" && passwordText.text == ""){
            alertError(msg: "Please enter all fields.")
        }
        else if(usernameText.text == ""){
            alertError(msg: "Please enter username.")
        }
        else if(passwordText.text == ""){
            alertError(msg: "Please enter password.")
        }
        else{
            
            guard let appDelegate1 = UIApplication.shared.delegate as? AppDelegate else { return }
            
            let managedContext1 = appDelegate1.persistentContainer.viewContext
            let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            fetchRequest1.predicate = NSPredicate(format: "username = %@", usernameText.text!)
            
            
            do {
                let result = try managedContext1.fetch(fetchRequest1)
                
                if(result.count > 0){
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
                    fetchRequest.predicate = NSPredicate(format: "username = %@", usernameText.text!)
                    
                    do {
                        let user = try managedContext.fetch(fetchRequest)
                        
                        for data in user as! [NSManagedObject] {
                            if(data.value(forKey: "password") as? String == passwordText.text){
                                data.setValue(true, forKey: "isAuthenticated")
                            }
                            else{
                                alertError(msg: "Wrong Password.")
                            }
                        }
                        
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        UserDefaults.standard.set(usernameText.text!, forKey: "username")
                        UserDefaults.standard.synchronize()
                        let library_path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
                        
                        print("library path is \(library_path)")
                        
                        try managedContext.save()
                        performSegue(withIdentifier: "logInSuccess", sender: self)
                        
                    } catch {}
                }
                    
                else{
                    alertError(msg: "Wrong Username.")
                }
            } catch {
                print("Failed")
            }
        }
    }
    
    
    @IBAction func signup(_ sender: Any) {
        performSegue(withIdentifier: "registration", sender: self)
        
    }
    
    func alertError(msg: String){
        let alert = UIAlertController(title: "ERROR", message:msg, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
}
