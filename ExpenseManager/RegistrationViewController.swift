//
//  RegistrationViewController.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 15/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//

import UIKit
import CoreData

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var confirmPasswordText: UITextField!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       
        
        
        nameText.frame.size.height = 40
        passwordText.frame.size.height = 40
        usernameText.frame.size.height = 40
        confirmPasswordText.frame.size.height = 40
        
        let cornerRadius : CGFloat = 5
        
        let myColor = UIColor.black
        nameText.layer.borderColor = myColor.cgColor
        nameText.layer.cornerRadius = cornerRadius
        nameText.layer.borderWidth = 1.0
        
        confirmPasswordText.layer.borderColor = myColor.cgColor
        confirmPasswordText.layer.cornerRadius = cornerRadius
        confirmPasswordText.layer.borderWidth = 1.0
        usernameText.layer.borderColor = myColor.cgColor
        usernameText.layer.cornerRadius = cornerRadius
        usernameText.layer.borderWidth = 1.0
        passwordText.layer.borderColor = myColor.cgColor
        passwordText.layer.cornerRadius = cornerRadius
        passwordText.layer.borderWidth = 1.0
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = false
        self.navigationItem.title = "Registration"
    }
    
    @IBAction func registerEvent(_ sender: Any) {
        view.endEditing(true)
        
        if(nameText.text == "" && usernameText.text == "" && passwordText.text == ""){
            alertError(msg: "Please enter all fields.")
        }
        else if(nameText.text == ""){
            alertError(msg: "Please enter name.")
        }
        else if(usernameText.text == ""){
            alertError(msg: "Please enter username.")
        }
        else if(passwordText.text == ""){
            alertError(msg: "Please enter password.")
        }
        else if(passwordText.text != confirmPasswordText.text){
            alertError(msg: "Password and Confirm Password must be same.")
        }
            
        else{
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let users = NSEntityDescription.entity(forEntityName: "Users", in: managedContext)!
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            fetchRequest.predicate = NSPredicate(format: "username = %@", usernameText.text!)
            let familyMember = NSEntityDescription.entity(forEntityName: "FamilyMember", in: managedContext)!
            
            do {
                let result = try managedContext.fetch(fetchRequest)
                
                if(result.count > 0){
                    alertError(msg: "This username is already used.")
                }
                    
                else{
                    
                    let user = NSManagedObject(entity: users, insertInto: managedContext)
                    user.setValue(nameText.text, forKey: "name")
                    user.setValue(usernameText.text, forKey: "username")
                    user.setValue(passwordText.text, forKey: "password")
                    user.setValue(false, forKey: "isAuthenticated")
                    
                    let family = NSManagedObject(entity: familyMember, insertInto: managedContext)
                    family.setValue(usernameText.text, forKey: "userrname")
                    family.setValue(usernameText.text, forKey: "membername")
                    family.setValue("self", forKey: "relation")
                    
                    try managedContext.save()
                    
                    _ = navigationController?.popViewController(animated: true)
                }
            } catch {
                print("Failed")
            }
        }
    }
    
    func alertError(msg: String){
        let alert = UIAlertController(title: "ERROR", message:msg, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
}
