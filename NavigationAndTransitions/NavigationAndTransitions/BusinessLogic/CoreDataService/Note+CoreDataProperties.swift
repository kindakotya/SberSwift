//
//  Note+CoreDataProperties.swift
//  NavigationAndTransitions
//
//  Created by 19657264 on 11.11.2021.
//
//

import Foundation
import CoreData

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var text: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var user: User?

}

extension Note: Identifiable {

}
