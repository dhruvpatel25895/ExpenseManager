//
//  ExpenseTransactionViewController.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 18/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//

import UIKit
import CoreData

class ExpenseTransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerCategory = UIPickerView()
    var pickerMember = UIPickerView()
    var selection = 1
    var label = ""
    
    var category = ["Travelling", "Bills", "Entertainment", "Food", "General", "Gift", "Health", "Shopping", "Sport"]
    
    var member = [NSManagedObject]()
    
    @IBOutlet weak var tableview: UITableView!
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        label = (updatedUsers[indexPath.row].value(forKey: "label") as? String)!
        
        performSegue(withIdentifier: "viewExpense", sender: self)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerCategory{
            return category.count
        }
        else{
            return member.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, did component: Int) -> Int {
        if pickerView == pickerCategory{
            return category.count
        }
        else{
            return member.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView == pickerCategory{
            searchField.text = category[row]
        }
        else{
            searchField.text = member[row].value(forKey: "membername") as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerCategory{
            return category[row]
        }
        else{
            return member[row].value(forKey: "membername") as? String
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updatedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "expenseviewcell") as? ExpenseTableViewCell else {
            
            return UITableViewCell()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        cell.nameLabel.text = updatedUsers[indexPath.row].value(forKey: "membername") as? String
        cell.dateLabel.text = dateFormatter.string(from: (updatedUsers[indexPath.row].value(forKey: "date") as? Date)!)
        cell.amountLabel.text = "$ " + String((updatedUsers[indexPath.row].value(forKey: "amount") as? String)!)
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewExpense" {
            if let vc = segue.destination as? ViewExpenseViewController {
                vc.label = label
            }
        }
    }
    
    @IBAction func selectionAction(_ sender: UISegmentedControl) {
        
        if(sender.selectedSegmentIndex == 0){
            searchField.text = ""
            updatedUsers = users
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
            searchField.text = ""
            searchField.placeholder = "select date to filter transaction"
            view.endEditing(true)
            selection = 1
            searchField.inputView = datePickerView
            
        }
        else if(sender.selectedSegmentIndex == 1){
            searchField.text = ""
            updatedUsers = users
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
            view.endEditing(true)
            searchField.placeholder = "select category to filter transaction"
            searchField.text = ""
            selection = 2
            searchField.inputView = pickerCategory
        }
        else{
            
            searchField.text = ""
            updatedUsers = users
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
            
            view.endEditing(true)
            searchField.placeholder = "select member to filter transaction"
            searchField.text = ""
            selection = 3
            searchField.inputView = pickerMember
            
        }
    }
    
    @IBAction func findExpense(_ sender: Any) {
        
        view.endEditing(true)
        
        if(selection == 1){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            
            if(searchField.text == ""){
                updatedUsers = users
            }
            else{
                updatedUsers = users.filter({conc -> Bool in
                    dateFormatter.string(from: (conc.value(forKey: "date") as? Date)!) == searchField.text
                })
            }
            
        }else if(selection == 2){
            if(searchField.text == ""){
                updatedUsers = users
            }
            else{
                updatedUsers = users.filter({conc -> Bool in
                    conc.value(forKey: "category") as? String == searchField.text
                })
            }
        }else{
            
            if(searchField.text == ""){
                updatedUsers = users
            }
            else{
                updatedUsers = users.filter({conc -> Bool in
                    conc.value(forKey: "membername") as? String == searchField.text
                })
            }
        }
        
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
    
    @IBAction func clearButton(_ sender: Any) {
        searchField.text = ""
        updatedUsers = users
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
    
    @IBOutlet weak var searchField: UITextField!
    
    let datePickerView = UIDatePicker()
    
    var users = [NSManagedObject]()
    var updatedUsers = [NSManagedObject]()
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        searchField.text = dateFormatter.string(from: sender.date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        member.removeAll()
        
        let name = UserDefaults.standard.string(forKey: "username")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: "FamilyMember")
        fetchRequest1.predicate = NSPredicate(format: "userrname = %@", name!)
        
        do {
            let user = try managedContext.fetch(fetchRequest1)
            
            for data in user as! [NSManagedObject] {
                member.append(data)
            }
            
        } catch {}
        viewDidLoad()
    }
    @objc func stopEditing() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        let cornerRadius : CGFloat = 5
        
        let myColor = UIColor.black
        searchField.layer.borderColor = myColor.cgColor
        searchField.layer.cornerRadius = cornerRadius
        searchField.layer.borderWidth = 1.0
        tableview.separatorColor = UIColor.black
        
        if(selection == 1){
            searchField.inputView = datePickerView
            searchField.placeholder = "select date to filter transaction"
        }
        else if(selection == 2){
            searchField.inputView = pickerCategory
            searchField.placeholder = "select category to filter transaction"
        }
        else{
            searchField.inputView = pickerMember
            searchField.placeholder = "select member to filter transaction"
        }
        
        
        self.tableview.tableFooterView = UIView(frame: .zero)
        
        self.tabBarController?.navigationController?.navigationBar.isHidden = false
        
        self.tabBarController?.navigationItem.hidesBackButton = true
        
        self.tabBarController?.navigationItem.title = "Expense Transaction"
        users.removeAll()
        
        pickerCategory.delegate = self as? UIPickerViewDelegate
        pickerCategory.dataSource = self as? UIPickerViewDataSource
        
        
        pickerMember.delegate = self as? UIPickerViewDelegate
        pickerMember.dataSource = self as? UIPickerViewDataSource
        
        datePickerView.datePickerMode = .date
        
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        let name = UserDefaults.standard.string(forKey: "username")
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddExpense")
        fetchRequest.predicate = NSPredicate(format: "username = %@", name!)
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: false)]
        
        
        do {
            let user = try managedContext.fetch(fetchRequest)
            
            for data in user as! [NSManagedObject] {
                users.append(data)
            }
            updatedUsers = users
            
        } catch {}
        
        self.tableview.reloadData()
    }
}
