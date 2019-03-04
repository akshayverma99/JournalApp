//
//  JournalEntryManager.swift
//  JournalApp
//
//  Created by Akshay Verma on 2019-03-04.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation

struct JournalEntry {
    let date: Date
    var text: String
}

class JournalEntryManager{
    
    private static var journalEntries: [JournalEntry] = []
    
   
    static func addJournalEntry(_ entry: JournalEntry){
        JournalEntryManager.journalEntries.append(entry)
    }
    
    static func getJournalEntries() -> [JournalEntry]{
        return JournalEntryManager.journalEntries
    }
    
}




