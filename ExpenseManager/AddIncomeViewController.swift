//
//  AddIncomeViewController.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 18/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//
import CoreData
import UIKit

class AddIncomeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    var pickerCategory = UIPickerView()
    var pickerMember = UIPickerView()
    let datePickerView = UIDatePicker()
    var category = ["Salary", "Gift", "Extra"]
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
            categoryField.text = category[row]
        }
        else{
            familyField.text = users[row].value(forKey: "membername") as? String
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
    
    @objc func stopEditing() {
        
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenTouch: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.stopEditing))
        
        view.addGestureRecognizer(screenTouch)
        
        incomeLabel.frame.size.height = 40
        familyField.frame.size.height = 40
        amountField.frame.size.height = 40
        categoryField.frame.size.height = 40
        dateField.frame.size.height = 40
        let cornerRadius : CGFloat = 5
        
        let myColor = UIColor.black
        incomeLabel.layer.borderColor = myColor.cgColor
        incomeLabel.layer.cornerRadius = cornerRadius
        incomeLabel.layer.borderWidth = 1.0
        
        familyField.layer.borderColor = myColor.cgColor
        familyField.layer.cornerRadius = cornerRadius
        familyField.layer.borderWidth = 1.0
        amountField.layer.borderColor = myColor.cgColor
        amountField.layer.cornerRadius = cornerRadius
        amountField.layer.borderWidth = 1.0
        categoryField.layer.borderColor = myColor.cgColor
        categoryField.layer.cornerRadius = cornerRadius
        categoryField.layer.borderWidth = 1.0
        dateField.layer.borderColor = myColor.cgColor
        dateField.layer.cornerRadius = cornerRadius
        dateField.layer.borderWidth = 1.0
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Add Income"
        
        pickerCategory.delegate = self as? UIPickerViewDelegate
        pickerCategory.dataSource = self as? UIPickerViewDataSource
        categoryField.inputView = pickerCategory
        
        pickerMember.delegate = self as? UIPickerViewDelegate
        pickerMember.dataSource = self as? UIPickerViewDataSource
        familyField.inputView = pickerMember
        
        datePickerView.datePickerMode = .date
        dateField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        amountField.keyboardType = UIKeyboardType.numberPad
        
        
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
        dateField.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func addIncomeButton(_ sender: Any) {
        do {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddIncome")
            fetchRequest.predicate = NSPredicate(format: "label = %@", incomeLabel.text!)
            
            if(categoryField.text == "" && amountField.text == "" && dateField.text == "" && familyField.text == "" && incomeLabel.text == ""){
                alertError(msg: "Please enter all fields.")
            }
            else if(incomeLabel.text == ""){
                alertError(msg: "Please enter unique income label.")
            }
            else if(categoryField.text == ""){
                alertError(msg: "Please select category.")
            }
            else if(amountField.text == ""){
                alertError(msg: "Please enter amount.")
            }
            else if(dateField.text == ""){
                alertError(msg: "Please enter proper date.")
            }
            else if(familyField.text == ""){
                alertError(msg: "Please select member.")
            }
            else if(try managedContext.fetch(fetchRequest).count > 0){
                
                alertError(msg: "This income label is already used by admin. enter another label")
            }
            else{
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                
                let managedContext = appDelegate.persistentContainer.viewContext
                let users = NSEntityDescription.entity(forEntityName: "AddIncome", in: managedContext)!
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let date = dateFormatter.date(from: dateField.text!)
                
                let name = UserDefaults.standard.string(forKey: "username")
                
                
                let user = NSManagedObject(entity: users, insertInto: managedContext)
                user.setValue(name, forKey: "username")
                user.setValue(categoryField.text, forKey: "category")
                user.setValue(amountField.text, forKey: "amount")
                user.setValue(date, forKey: "date")
                user.setValue(familyField.text, forKey: "membername")
                user.setValue(incomeLabel.text, forKey: "label")
                
                try managedContext.save()
                
                _ = navigationController?.popViewController(animated: true)
                
            }
        } catch {
            
            print("Failed")
        }
        
    }
    
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var familyField: UITextField!
    @IBOutlet weak var incomeLabel: UITextField!
    
    func alertError(msg: String){
        let alert = UIAlertController(title: "ERROR", message:msg, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
