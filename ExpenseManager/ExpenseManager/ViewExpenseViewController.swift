//
//  ViewExpenseViewController.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 18/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//

import UIKit
import CoreData

class ViewExpenseViewController: UIViewController {
    
    var label = ""
    
    @IBOutlet weak var expenseLabel: UILabel!
    
    @IBOutlet weak var amoutLabel: UILabel!
    @IBOutlet weak var memberLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "View Expense"
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddExpense")
        fetchRequest.predicate = NSPredicate(format: "label = %@", label)
        
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            
            let user = try managedContext.fetch(fetchRequest)
            
            for data in user as! [NSManagedObject] {
                
                expenseLabel.text = data.value(forKey: "label") as? String
                amoutLabel.text = data.value(forKey: "amount") as? String
                memberLabel.text = data.value(forKey: "membername") as? String
                categoryLabel.text = data.value(forKey: "category") as? String
                dateLabel.text = dateFormatter.string(from: ((data.value(forKey: "date") as? Date)!))
            }
        } catch {}
    }
    
    @IBAction func deleteExpense(_ sender: Any) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddExpense")
        fetchRequest.predicate = NSPredicate(format: "label = %@", label)
        
        do
        {
            let member = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = member[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            try managedContext.save()
            _ = navigationController?.popViewController(animated: true)
        }
        catch
        {
            print(error)
        }
    }
    @IBAction func editExpense(_ sender: Any) {
        performSegue(withIdentifier: "updateExpense", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateExpense" {
            if let vc = segue.destination as? UpdateExpenseViewController {
                vc.label = label
            }
        }
    }
}
