//
//  AddRemoveExpenseViewController.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 18/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//

import UIKit
import CoreData

class AddRemoveExpenseViewController: UIViewController {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    var flag = 0;
    
    override func viewDidAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.title = "Expense Manager"
        
        let now = Date()
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter3.string(from: now)
        
        let name = UserDefaults.standard.string(forKey: "username")
        
        var amount = Int()
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        monthLabel.text = nameOfMonth + ", " + String(year)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy"
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddIncome")
        fetchRequest.predicate = NSPredicate(format: "username = %@", name!)
        
        do {
            let user = try managedContext.fetch(fetchRequest)
            
            for data in user as! [NSManagedObject] {
                
                let m = dateFormatter.string(from: data.value(forKey: "date") as! Date)
                let y = dateFormatter2.string(from: data.value(forKey: "date") as! Date)
                let m1 = String(month)
                let y1 = String(year)
                
                if(m == m1 && y == y1){
                    amount = amount + Int((data.value(forKey: "amount") as? String)!)!
                }
            }
        } catch {}
        
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: "AddExpense")
        fetchRequest1.predicate = NSPredicate(format: "username = %@", name!)
        
        do {
            
            let user1 = try managedContext.fetch(fetchRequest1)
            for data1 in user1 as! [NSManagedObject] {
                
                let m11 = dateFormatter.string(from: data1.value(forKey: "date") as! Date)
                let y11 = dateFormatter2.string(from: data1.value(forKey: "date") as! Date)
                let m111 = String(month)
                let y111 = String(year)
                
                if(m11 == m111 && y11 == y111){
                    amount = amount - Int((data1.value(forKey: "amount") as? String)!)!
                }
            }
            
        } catch {}
        
        amountLabel.text = "$ " + String(amount)
        
        if(amount < 0 && flag == 0){
            flag = 1
            
            let alert = UIAlertController(title: "ALERT", message:"Your monthly expenxe exceeds the income. Please do needful", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
            alert.view.backgroundColor = UIColor.red
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func addIncome(_ sender: Any) {
        
        performSegue(withIdentifier: "addIncome", sender: self)
    }
    
    @IBAction func addExpense(_ sender: Any) {
        
        performSegue(withIdentifier: "addExpense", sender: self)
    }
    
    func alertError(msg: String){
        let alert = UIAlertController(title: "ERROR", message:msg, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
}
