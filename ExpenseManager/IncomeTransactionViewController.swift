//
//  IncomeTransactionViewController.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 18/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//

import UIKit
import CoreData

class IncomeTransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerCategory = UIPickerView()
    var pickerMember = UIPickerView()
    var selection = 1
    
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
            searchText.text = category[row]
            
        }
        else{
            searchText.text = member[row].value(forKey: "membername") as? String
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
    
    var category = ["Salary", "Gift", "Extra"]
    var member = [NSManagedObject]()
    
    @IBAction func selectionAction(_ sender: UISegmentedControl) {
        
        if(sender.selectedSegmentIndex == 0){
            
            searchText.text = ""
            updatedUsers = users
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
            searchText.text = ""
            searchText.placeholder = "select date to filter transaction"
            view.endEditing(true)
            selection = 1
            searchText.inputView = datePickerView
            
        }
        else if(sender.selectedSegmentIndex == 1){
            searchText.text = ""
            updatedUsers = users
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
            view.endEditing(true)
            searchText.placeholder = "select category to filter transaction"
            searchText.text = ""
            selection = 2
            searchText.inputView = pickerCategory
        }
        else{
            
            searchText.text = ""
            updatedUsers = users
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
            view.endEditing(true)
            searchText.placeholder = "select member to filter transaction"
            searchText.text = ""
            selection = 3
            searchText.inputView = pickerMember
            
        }
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
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.separatorColor = UIColor.black
        
        let cornerRadius : CGFloat = 5
        let myColor = UIColor.black
        searchText.layer.borderColor = myColor.cgColor
        searchText.layer.cornerRadius = cornerRadius
        searchText.layer.borderWidth = 1.0
        
        if(selection == 1){
            searchText.inputView = datePickerView
            searchText.placeholder = "select date to filter transaction"
        }
        else if(selection == 2){
            searchText.inputView = pickerCategory
            searchText.placeholder = "select category to filter transaction"
        }
        else{
            searchText.inputView = pickerMember
            searchText.placeholder = "select member to filter transaction"
        }
        self.tableview.tableFooterView = UIView(frame: .zero)
        
        self.tabBarController?.navigationController?.navigationBar.isHidden = false
        
        self.tabBarController?.navigationItem.hidesBackButton = true
        
        self.tabBarController?.navigationItem.title = "Income Transaction"
        
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
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddIncome")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updatedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "viewcell") as? IncomeTableViewCell else {
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
    
    var label = ""
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        label = (updatedUsers[indexPath.row].value(forKey: "label") as? String)!
        
        performSegue(withIdentifier: "viewIncome", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewIncome" {
            if let vc = segue.destination as? ViewIncomeViewController {
                vc.label = label
            }
        }
    }
    
    @IBOutlet weak var tableview: UITableView!
    var users = [NSManagedObject]()
    var updatedUsers = [NSManagedObject]()
    let datePickerView = UIDatePicker()
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        searchText.text = dateFormatter.string(from: sender.date)
    }
    
    @IBOutlet weak var searchText: UITextField!
    
    @IBAction func findButton(_ sender: Any) {
        
        view.endEditing(true)
        if(selection == 1){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            
            if(searchText.text == ""){
                updatedUsers = users
            }
            else{
                updatedUsers = users.filter({conc -> Bool in
                    dateFormatter.string(from: (conc.value(forKey: "date") as? Date)!) == searchText.text
                })
            }
            
        }else if(selection == 2){
            if(searchText.text == ""){
                updatedUsers = users
            }
            else{
                updatedUsers = users.filter({conc -> Bool in
                    conc.value(forKey: "category") as? String == searchText.text
                })
            }
        }else{
            if(searchText.text == ""){
                updatedUsers = users
            }
            else{
                updatedUsers = users.filter({conc -> Bool in
                    conc.value(forKey: "membername") as? String == searchText.text
                })
            }
        }
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
    
    @IBAction func clearButton(_ sender: Any) {
        searchText.text = ""
        updatedUsers = users
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
}
