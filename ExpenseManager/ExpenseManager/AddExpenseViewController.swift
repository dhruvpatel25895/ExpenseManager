//
//  AddExpenseViewController.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 18/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//

import UIKit
import CoreData

class AddExpenseViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerCategory = UIPickerView()
    var pickerMember = UIPickerView()
    
    let datePickerView = UIDatePicker()
    var category = ["Travelling", "Bills", "Entertainment", "Food", "General", "Gift", "Health", "Shopping", "Sport"]
    
    var users = [NSManagedObject]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerCategory{
            return category.count
        }
        else{
            return users.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, did component: Int) -> Int {
        if pickerView == pickerCategory{
            return category.count
        }
        else{
            return users.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView == pickerCategory{
            categoryText.text = category[row]
        }
        else{
            familyText.text = users[row].value(forKey: "membername") as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickerCategory{
            return category[row]
        }
        else{
            return users[row].value(forKey: "membername") as? String
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.navigationItem.title = "Add Expense"
    }
    
    @objc func stopEditing() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenTouch: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.stopEditing))
        view.addGestureRecognizer(screenTouch)
        
        expenseLabel.frame.size.height = 40
        familyText.frame.size.height = 40
        amountText.frame.size.height = 40
        categoryText.frame.size.height = 40
        dateText.frame.size.height = 40
        let cornerRadius : CGFloat = 5
        
        let myColor = UIColor.black
        expenseLabel.layer.borderColor = myColor.cgColor
        expenseLabel.layer.cornerRadius = cornerRadius
        expenseLabel.layer.borderWidth = 1.0
        
        familyText.layer.borderColor = myColor.cgColor
        familyText.layer.cornerRadius = cornerRadius
        familyText.layer.borderWidth = 1.0
        amountText.layer.borderColor = myColor.cgColor
        amountText.layer.cornerRadius = cornerRadius
        amountText.layer.borderWidth = 1.0
        categoryText.layer.borderColor = myColor.cgColor
        categoryText.layer.cornerRadius = cornerRadius
        categoryText.layer.borderWidth = 1.0
        dateText.layer.borderColor = myColor.cgColor
        dateText.layer.cornerRadius = cornerRadius
        dateText.layer.borderWidth = 1.0
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Add Expense"
        
        pickerCategory.delegate = self as? UIPickerViewDelegate
        pickerCategory.dataSource = self as? UIPickerViewDataSource
        categoryText.inputView = pickerCategory
        
        pickerMember.delegate = self as? UIPickerViewDelegate
        pickerMember.dataSource = self as? UIPickerViewDataSource
        familyText.inputView = pickerMember
        
        datePickerView.datePickerMode = .date
        dateText.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        amountText.keyboardType = UIKeyboardType.numberPad
        
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
        
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateText.text = dateFormatter.string(from: sender.date)
    }
    
    @IBOutlet weak var expenseLabel: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var familyText: UITextField!
    
    @IBAction func addExpense(_ sender: Any) {
        
        do {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddExpense")
            fetchRequest.predicate = NSPredicate(format: "label = %@", expenseLabel.text!)
            if(categoryText.text == "" && amountText.text == "" && dateText.text == "" && familyText.text == "" && expenseLabel.text == ""){
                alertError(msg: "Please enter all fields.")
            }
            else if(expenseLabel.text == ""){
                alertError(msg: "Please enter unique expense label.")
            }
            else if(categoryText.text == ""){
                alertError(msg: "Please select category.")
            }
            else if(amountText.text == ""){
                alertError(msg: "Please enter amount.")
            }
            else if(dateText.text == ""){
                alertError(msg: "Please enter proper date.")
            }
            else if(familyText.text == ""){
                alertError(msg: "Please select member.")
            }
            else if(try managedContext.fetch(fetchRequest).count > 0){
                
                alertError(msg: "This expense label is already used by admin. enter another label")
            }
            else{
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                
                let managedContext = appDelegate.persistentContainer.viewContext
                let users = NSEntityDescription.entity(forEntityName: "AddExpense", in: managedContext)!
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let date = dateFormatter.date(from: dateText.text!)
                
                let name = UserDefaults.standard.string(forKey: "username")
                
                
                let user = NSManagedObject(entity: users, insertInto: managedContext)
                user.setValue(name, forKey: "username")
                user.setValue(categoryText.text, forKey: "category")
                user.setValue(amountText.text, forKey: "amount")
                user.setValue(date, forKey: "date")
                user.setValue(familyText.text, forKey: "membername")
                user.setValue(expenseLabel.text, forKey: "label")
                
                try managedContext.save()
                _ = navigationController?.popViewController(animated: true)
                
            }
        } catch {
            print("Failed")
        }
    }
    
    func alertError(msg: String){
        let alert = UIAlertController(title: "ERROR", message:msg, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
}
