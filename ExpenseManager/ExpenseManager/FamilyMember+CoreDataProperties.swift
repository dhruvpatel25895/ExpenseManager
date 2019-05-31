//
//  FamilyMember+CoreDataProperties.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 17/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//
//

import Foundation
import CoreData


extension FamilyMember {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FamilyMember> {
        return NSFetchRequest<FamilyMember>(entityName: "FamilyMember")
    }

    @NSManaged public var userrname: String?
    @NSManaged public var membername: String?
    @NSManaged public var relation: String?

}
