//
//  AddFamilyViewController.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 17/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//

import UIKit
import CoreData

class AddFamilyViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var relationField: UITextField!
    
    var data = ["Father", "Mother", "Self", "Wife", "Brother", "Sister", "Husband"]
    
    var picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenTouch: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.stopEditing))
        view.addGestureRecognizer(screenTouch)
        
        nameField.frame.size.height = 40
        relationField.frame.size.height = 40
        
        let cornerRadius : CGFloat = 5
        
        let myColor = UIColor.black
        nameField.layer.borderColor = myColor.cgColor
        nameField.layer.cornerRadius = cornerRadius
        nameField.layer.borderWidth = 1.0
        relationField.layer.borderColor = myColor.cgColor
        relationField.layer.cornerRadius = cornerRadius
        relationField.layer.borderWidth = 1.0
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Add Family"
        picker.delegate = self as? UIPickerViewDelegate
        picker.dataSource = self as? UIPickerViewDataSource
        relationField.inputView = picker
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, did component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        relationField.text = data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    @IBAction func addMember(_ sender: Any) {
        
        do {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FamilyMember")
            fetchRequest.predicate = NSPredicate(format: "membername = %@", nameField.text!)
            
            if(nameField.text == "" && relationField.text == ""){
                alertError(msg: "Please enter all fields.")
            }
            else if(nameField.text == ""){
                alertError(msg: "Please enter name.")
            }
            else if(relationField.text == ""){
                alertError(msg: "Please select relation.")
            }
            else if(try managedContext.fetch(fetchRequest).count > 0){
                
                alertError(msg: "This name is already used by admin. enter another name")
            }
            else{
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                
                let managedContext = appDelegate.persistentContainer.viewContext
                let familyMember = NSEntityDescription.entity(forEntityName: "FamilyMember", in: managedContext)!
                let name = UserDefaults.standard.string(forKey: "username")
                let family = NSManagedObject(entity: familyMember, insertInto: managedContext)
                family.setValue(name, forKey: "userrname")
                family.setValue(nameField.text, forKey: "membername")
                family.setValue(relationField.text, forKey: "relation")
                
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
    
    @objc func stopEditing() {
        view.endEditing(true)
    }
}
