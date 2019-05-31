//
//  AddIncome+CoreDataProperties.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 18/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//
//

import Foundation
import CoreData


extension AddIncome {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddIncome> {
        return NSFetchRequest<AddIncome>(entityName: "AddIncome")
    }

    @NSManaged public var username: String?
    @NSManaged public var category: String?
    @NSManaged public var amount: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var membername: String?
    @NSManaged public var label: String?

}
