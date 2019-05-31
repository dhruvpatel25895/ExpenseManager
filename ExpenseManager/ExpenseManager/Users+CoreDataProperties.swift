//
//  Users+CoreDataProperties.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 15/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var username: String?
    @NSManaged public var isAuthenticated: Bool

}
