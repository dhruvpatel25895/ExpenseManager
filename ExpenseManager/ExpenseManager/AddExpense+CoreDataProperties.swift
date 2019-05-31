//
//  AddExpense+CoreDataProperties.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 18/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//
//

import Foundation
import CoreData


extension AddExpense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddExpense> {
        return NSFetchRequest<AddExpense>(entityName: "AddExpense")
    }

    @NSManaged public var username: String?
    @NSManaged public var membername: String?
    @NSManaged public var label: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var category: String?
    @NSManaged public var amount: String?

}
