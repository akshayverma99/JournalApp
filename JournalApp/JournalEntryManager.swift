//
//  JournalEntryManager.swift
//  JournalApp
//
//  Created by Akshay Verma on 2019-03-04.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit
import CoreData

struct JournalEntry {
    let date: Date
    var text: String
    var location: String?
}

enum coreDataError: Error{
    case retrievalError
}

public class JournalEntryManager{
    
    private enum entryAttributeKey: String{
        case dateCreated
        case location
        case text
    }
    
    // Both hold the same information, the above is used to interface, the bottom is used for modification
    private static var journalEntries: [JournalEntry] = []
    private static var journalEntryObjects: [NSManagedObject] = []
    
    static func addJournalEntry(_ entry: JournalEntry)throws{
        try saveJournalEntry(for: entry)
    }
    
    static func updateJournalEntry(at index: Int, with entry: JournalEntry)throws{
        journalEntries[index] = entry
        removeJournalEntry(at: index)
        try addJournalEntry(entry)
    }
    
    static func removeJournalEntry(at index: Int){
        journalEntries.remove(at: index)
        let entry = journalEntryObjects[index]
        journalEntryObjects.remove(at: index)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(entry)
        do{
            try managedContext.save()
        }catch{}
    }
    
    static func updateJournalEntries(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entry")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: entryAttributeKey.dateCreated.rawValue, ascending: false)]
        
        journalEntries = []
        
        do{
            let arrayOfObjects = try managedContext.fetch(fetchRequest)
            journalEntryObjects = arrayOfObjects
            for managedObject in arrayOfObjects{
                let newEntry = try createJournalEntry(from: managedObject)
                journalEntries.append(newEntry)
            }
        }catch{
            journalEntries = []
            journalEntryObjects = []
        }
        
    }
    
    static func getJournalEntries() -> [JournalEntry]{
        return JournalEntryManager.journalEntries
    }
    
    private static func createJournalEntry(from object: NSManagedObject) throws -> JournalEntry{
        if let date = object.value(forKey: entryAttributeKey.dateCreated.rawValue) as? Date,
            let text = object.value(forKey: entryAttributeKey.text.rawValue) as? String{
            let location: String? = object.value(forKey: entryAttributeKey.location.rawValue) as? String
            
            return JournalEntry(date: date, text: text, location: location)
        }else{
            throw coreDataError.retrievalError
        }
        
        
    }
    
    private static func saveJournalEntry(for journalEntry: JournalEntry) throws {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appdelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Entry", in: managedContext)!
        let entry = NSManagedObject(entity: entity, insertInto: managedContext)
        
        setEntryAttributes(for: entry, date: journalEntry.date, text: journalEntry.text, location: journalEntry.location)
        
        
        try managedContext.save()
        JournalEntryManager.journalEntries.append(journalEntry)
        JournalEntryManager.journalEntryObjects.append(entry)
        
        
    }
    
    private static func setEntryAttributes(for entry: NSManagedObject, date: Date, text: String, location: String?){
        entry.setValue(date, forKey: entryAttributeKey.dateCreated.rawValue)
        entry.setValue(text, forKey: entryAttributeKey.text.rawValue)
        guard let location = location else {return}
        entry .setValue(location, forKey: entryAttributeKey.location.rawValue)
    }
    
    
}




