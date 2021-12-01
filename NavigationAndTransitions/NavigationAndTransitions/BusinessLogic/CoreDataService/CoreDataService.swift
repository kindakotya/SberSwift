//
//  CoreDataService.swift
//  NavigationAndTransitions
//
//  Created by 19657264 on 23.11.2021.
//

import UIKit
import CoreData

class CoreDataService {
    static public let shared = CoreDataService()
    var currentUser: User?
    var editingNote: Note?
    var sortedNotes: [Note?] = [nil]

    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NavigationAndTransitions")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func setCurrentUser(withName name: String, withPassword password: String) -> Bool {
        do {
            let users: [User] = try persistentContainer.viewContext.fetch(User.fetchRequest())
            for element in users {
                if element.login == name && element.password == password {
                    currentUser = element
                    // swiftlint:disable force_cast
                    sortedNotes = currentUser!.notes?.allObjects
                        .sorted(by: {($0 as! Note).creationDate! > ($1 as! Note).creationDate!}) as! [Note?]
                    // swiftlint:enable force_cast
                    return true
                }
            }
        } catch {
        return false
        }
        return false
    }

    func addUser(withName name: String, withPassword password: String) -> Bool {
        do {
            let users: [User] = try persistentContainer.viewContext.fetch(User.fetchRequest())
            guard users.first(where: {$0.login == name}) == nil else { return false }
            let newUser = User(context: persistentContainer.viewContext)
            newUser.login = name
            newUser.password = password
            saveContext()
        } catch {
            return false
        }
        return true
    }

    func addNote(withText text: String) {
        let note = Note(context: persistentContainer.viewContext)
        note.text = text
        note.creationDate = Date.now
        currentUser?.addToNotes(note)
        saveContext()
        sortedNotes.insert(note, at: 0)
    }

    func editNote(newText text: String) {
        editingNote?.text = text
        saveContext()
        editingNote = nil
    }

    func deleteNote(withIndex index: Int) -> Int {
        let noteToDelete = sortedNotes[index]!
        sortedNotes.remove(at: index)
        persistentContainer.viewContext.delete(noteToDelete)
        saveContext()
        return sortedNotes.count
    }

    func getNote(withIndex index: Int) -> Note {
        return sortedNotes[index]!
    }

    func getLastNote() -> Note {
        return sortedNotes[0]!
    }

// If need to clean all entity Data
    private func deleteAllData(_ entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                self.persistentContainer.viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
}
