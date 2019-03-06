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

class JournalEntryManager{
    
    private enum entryAttributeKey: String{
        case dateCreated
        case location
        case text
    }
    
    private static var journalEntries: [JournalEntry] = []
    
   
    static func addJournalEntry(_ entry: JournalEntry){
        saveJournalEntry(for: entry)
    }
    
    static func updateJournalEntries(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entry")
        fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: entryAttributeKey.dateCreated.rawValue, ascending: true))
        
        do{
            let arrayOfObjects = try managedContext.fetch(fetchRequest)
            for managedObject in arrayOfObjects{
                let newEntry = try createJournalEntry(from: managedObject)
                journalEntries.append(newEntry)
            }
        }catch let error{
            print(error)
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
    
    private static func saveJournalEntry(for journalEntry: JournalEntry){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appdelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Entry", in: managedContext)!
        let entry = NSManagedObject(entity: entity, insertInto: managedContext)
        
        setEntryAttributes(for: entry, date: journalEntry.date, text: journalEntry.text, location: journalEntry.location)
        
        do{
            try managedContext.save()
            JournalEntryManager.journalEntries.append(journalEntry)
        }catch let error{
            print(error.localizedDescription)
        }
 
    }
    
    private static func setEntryAttributes(for entry: NSManagedObject, date: Date, text: String, location: String?){
        entry.setValue(date, forKey: entryAttributeKey.dateCreated.rawValue)
        entry.setValue(text, forKey: entryAttributeKey.text.rawValue)
        guard let location = location else {return}
        entry .setValue(location, forKey: entryAttributeKey.location.rawValue)
    }

    
}




