//
//  UpdateIncomeViewController.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 18/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//

import UIKit
import CoreData

class UpdateIncomeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var label = ""
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
            categoryText.text = category[row]
        }
        else{
            memberText.text = users[row].value(forKey: "membername") as? String
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
        
        labelText.frame.size.height = 40
        memberText.frame.size.height = 40
        amountText.frame.size.height = 40
        categoryText.frame.size.height = 40
        dateText.frame.size.height = 40
        let cornerRadius : CGFloat = 5
        
        let myColor = UIColor.black
        labelText.layer.borderColor = myColor.cgColor
        labelText.layer.cornerRadius = cornerRadius
        labelText.layer.borderWidth = 1.0
        
        memberText.layer.borderColor = myColor.cgColor
        memberText.layer.cornerRadius = cornerRadius
        memberText.layer.borderWidth = 1.0
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
        self.navigationItem.title = "Update Expense"
        
        labelText.isUserInteractionEnabled = false
        pickerCategory.delegate = self as? UIPickerViewDelegate
        pickerCategory.dataSource = self as? UIPickerViewDataSource
        categoryText.inputView = pickerCategory
        
        pickerMember.delegate = self as? UIPickerViewDelegate
        pickerMember.dataSource = self as? UIPickerViewDataSource
        memberText.inputView = pickerMember
        
        datePickerView.datePickerMode = .date
        dateText.inputView = datePickerView
        
        
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        amountText.keyboardType = UIKeyboardType.numberPad
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let name = UserDefaults.standard.string(forKey: "username")
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddIncome")
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: "FamilyMember")
        fetchRequest1.predicate = NSPredicate(format: "userrname = %@", name!)
        do {
            let user = try managedContext.fetch(fetchRequest1)
            for data in user as! [NSManagedObject] {
                users.append(data)
            }
        } catch {}
        
        fetchRequest.predicate = NSPredicate(format: "label = %@", label)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        do
        {
            let member = try managedContext.fetch(fetchRequest)
            
            for data in member as! [NSManagedObject] {
                
                memberText.text = (data.value(forKey: "membername") as? String)!
                dateText.text = dateFormatter.string(from: ((data.value(forKey: "date") as? Date)!))
                amountText.text = (data.value(forKey: "amount") as? String)!
                categoryText.text = (data.value(forKey: "category") as? String)!
                labelText.text = (data.value(forKey: "label") as? String)!
            }
        }
        catch
        {
            print(error)
        }
    }
    
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateText.text = dateFormatter.string(from: sender.date)
    }
    
    @IBOutlet weak var labelText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var memberText: UITextField!
    
    @IBAction func updateIncome(_ sender: Any) {
        
        do {
            if(categoryText.text == "" && amountText.text == "" && dateText.text == "" && memberText.text == "" && amountText.text == ""){
                alertError(msg: "Please enter all fields.")
            }
            else if(amountText.text == ""){
                alertError(msg: "Please enter unique income label.")
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
            else if(memberText.text == ""){
                alertError(msg: "Please select member.")
            }
            else{
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                
                let managedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddIncome")
                fetchRequest.predicate = NSPredicate(format: "label = %@", label)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let date = dateFormatter.date(from: dateText.text!)
                let user = try managedContext.fetch(fetchRequest)
                
                for data in user as! [NSManagedObject] {
                    
                    data.setValue(categoryText.text, forKey: "category")
                    data.setValue(amountText.text, forKey: "amount")
                    data.setValue(date, forKey: "date")
                    data.setValue(memberText.text, forKey: "membername")
                    try managedContext.save()
                    
                    
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                    
                }
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
