//
//  LoggedUser+CoreDataProperties.swift
//  
//
//  Created by Vladimir Banushkin on 26.09.2021.
//
//

import Foundation
import CoreData


extension LoggedUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoggedUser> {
        return NSFetchRequest<LoggedUser>(entityName: "LoggedUser")
    }

    @NSManaged public var id: String?

}
