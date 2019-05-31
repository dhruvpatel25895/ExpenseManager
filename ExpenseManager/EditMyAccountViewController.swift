//
//  EditMyAccountViewController.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 16/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//

import UIKit
import CoreData

class EditMyAccountViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.title = "My Account"
    }
    
    @objc func stopEditing() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenTouch: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.stopEditing))
        
        view.addGestureRecognizer(screenTouch)
        
        nameText.frame.size.height = 40
        passwordText.frame.size.height = 40
        usernameText.frame.size.height = 40
        
        let cornerRadius : CGFloat = 5
        
        let myColor = UIColor.black
        usernameText.layer.borderColor = myColor.cgColor
        usernameText.layer.cornerRadius = cornerRadius
        usernameText.layer.borderWidth = 1.0
        passwordText.layer.borderColor = myColor.cgColor
        passwordText.layer.cornerRadius = cornerRadius
        passwordText.layer.borderWidth = 1.0
        nameText.layer.borderColor = myColor.cgColor
        nameText.layer.cornerRadius = cornerRadius
        nameText.layer.borderWidth = 1.0
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Edit Account"
        
        usernameText.isUserInteractionEnabled = false
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "isAuthenticated = %@", NSNumber(value: true))
        
        do {
            let user = try managedContext.fetch(fetchRequest)
            
            for data in user as! [NSManagedObject] {
                
                nameText.text = (data.value(forKey: "name") as? String)!
                usernameText.text = (data.value(forKey: "username") as? String)!
                passwordText.text = (data.value(forKey: "password") as? String)!
            }
        } catch {}
    }
    @IBAction func UpdateButton(_ sender: Any) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "isAuthenticated = %@", NSNumber(value: true))
        
        do {
            
            let user = try managedContext.fetch(fetchRequest)
            
            for data in user as! [NSManagedObject] {
                
                data.setValue(nameText.text, forKey: "name")
                data.setValue(passwordText.text, forKey: "password")
                try managedContext.save()
                
                _ = navigationController?.popViewController(animated: true)
                
            }
        } catch {}
    }
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var nameText: UITextField!
}
