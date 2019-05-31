//
//  MyAccountViewController.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 16/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//

import UIKit
import CoreData

class MyAccountViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBAction func editButton(_ sender: Any) {
        performSegue(withIdentifier: "updateAccount", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "isAuthenticated = %@", NSNumber(value: true))
        
        do {
            let user = try managedContext.fetch(fetchRequest)
            
            for data in user as! [NSManagedObject] {
                
                data.setValue(false, forKey: "isAuthenticated")
                try managedContext.save()
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.synchronize()
                performSegue(withIdentifier: "signOut", sender: self)
                
            }
        } catch {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.title = "My Account"
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "isAuthenticated = %@", NSNumber(value: true))
        
        do {
            
            let user = try managedContext.fetch(fetchRequest)
            
            for data in user as! [NSManagedObject] {
                nameLabel.text = "Hi " + String((data.value(forKey: "name") as? String)!).uppercased() + ","
                usernameLabel.text = (data.value(forKey: "username") as? String)!
                passwordLabel.text = (data.value(forKey: "password") as? String)!
            }
        } catch {}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logout"{
            self.hidesBottomBarWhenPushed = true}
    }
}
