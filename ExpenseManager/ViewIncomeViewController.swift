//
//  ViewIncomeViewController.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 18/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//

import UIKit
import CoreData

class ViewIncomeViewController: UIViewController {
    var label = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "View Income"
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddIncome")
        fetchRequest.predicate = NSPredicate(format: "label = %@", label)
        
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            
            let user = try managedContext.fetch(fetchRequest)
            
            for data in user as! [NSManagedObject] {
                
                incomeLabel.text = data.value(forKey: "label") as? String
                amountLabel.text = data.value(forKey: "amount") as? String
                memberLabel.text = data.value(forKey: "membername") as? String
                categoryLabel.text = data.value(forKey: "category") as? String
                dateLabel.text = dateFormatter.string(from: ((data.value(forKey: "date") as? Date)!))
            }
        } catch {}
    }
    
    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateIncome" {
            if let vc = segue.destination as? UpdateIncomeViewController {
                vc.label = label
            }
        }
    }
    
    @IBAction func editIncome(_ sender: Any) {
        performSegue(withIdentifier: "updateIncome", sender: self)
    }
    
    @IBAction func deleteIncome(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddIncome")
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
}
