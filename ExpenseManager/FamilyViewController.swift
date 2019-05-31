//
//  FamilyViewController.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 17/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//

import UIKit
import CoreData

class FamilyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    var users = [NSManagedObject]()
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        users.removeAll()
        tableview.separatorColor = UIColor.black
        self.tableview.tableFooterView = UIView(frame: .zero)
        
        self.tabBarController?.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.title = "View Family"
        
        let name = UserDefaults.standard.string(forKey: "username")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FamilyMember")
        fetchRequest.predicate = NSPredicate(format: "userrname = %@", name!)
        
        do {
            let user = try managedContext.fetch(fetchRequest)
            for data in user as! [NSManagedObject] {
                users.append(data)
            }
        } catch {}
        self.tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ViewFamilyTableViewCell else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = String(users[indexPath.row].value(forKey: "membername") as! String) + " (" + String(users[indexPath.row].value(forKey: "relation") as! String) + ")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FamilyMember")
            fetchRequest.predicate = NSPredicate(format: "membername = %@", (self.users[indexPath.row].value(forKey: "membername") as? String)!)
            do
            {
                let member = try managedContext.fetch(fetchRequest)
                let objectToDelete = member[0] as! NSManagedObject
                
                if(objectToDelete.value(forKey: "membername") as? String == UserDefaults.standard.string(forKey: "username")){
                    self.alertError(msg: "You cant delete yourself from family")
                }
                else{
                    managedContext.delete(objectToDelete)
                    
                    do{
                        try managedContext.save()
                        self.viewDidLoad()
                    }
                    catch
                    {
                        print(error)
                    }}
            }
            catch
            {
                print(error)
            }
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @IBAction func addMember(_ sender: Any) {
        performSegue(withIdentifier: "addMember", sender: self)
    }
    
    func alertError(msg: String){
        let alert = UIAlertController(title: "ERROR", message:msg, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
}
