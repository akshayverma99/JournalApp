//
//  JournalAppTests.swift
//  JournalAppTests
//
//  Created by Akshay Verma on 2019-03-06.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import XCTest
import CoreData
@testable import JournalApp

class JournalAppTests: XCTestCase {
    
    func clearAllJournalEntries(){
        if JournalManagerTester.getJournalEntries().count == 0{
            return
        }
        for _ in 0...JournalManagerTester.getJournalEntries().count-1{
            try! JournalManagerTester.removeJournalEntry(at: 0)
        }
    }
    
    class JournalManagerTester: JournalEntryManager{}
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        clearAllJournalEntries()
    }
    
    // Adds a new journal entry and then checks to see if the array only has 1 entry and checks to
    // ensure the values of that entry are correct
    func testAddJournalEntry(){
        let newEntry = JournalEntry(date: Date(), text: "Testing some stuff", location: "Toronto, Canada")
        try! JournalManagerTester.addJournalEntry(newEntry)
        XCTAssert(JournalManagerTester.getJournalEntries().count == 1, "More or less than 1 entry")
        XCTAssert(JournalManagerTester.getJournalEntries()[0].text == newEntry.text &&
            JournalManagerTester.getJournalEntries()[0].location == newEntry.location &&
            JournalManagerTester.getJournalEntries()[0].date == newEntry.date, "properties of entry are different")
    }
    
    // Adds a journal entry and confirms that it has been added, then that journal entry is removed,
    // and the array length reflects that it has been deleted
    func testDeleteEntry(){
        let newEntry = JournalEntry(date: Date(), text: "Testing some stuff", location: "Toronto, Canada")
        try! JournalManagerTester.addJournalEntry(newEntry)
        XCTAssert(JournalManagerTester.getJournalEntries().count == 1, "More or less than 1 entry")
        try! JournalManagerTester.removeJournalEntry(at: 0)
        XCTAssert(JournalManagerTester.getJournalEntries().count == 0, "Contains entries")
    }
    
    // Creates a new journal entry, verifies it, then edits it and verifies that the entry values have changed
    func testEntryEditing(){
        let newEntry = JournalEntry(date: Date(), text: "Testing some stuff", location: "Toronto, Canada")
        let updatedEntry = JournalEntry(date: Date(), text: "Doing some more testing", location: nil)
        try! JournalManagerTester.addJournalEntry(newEntry)
        
        XCTAssert(JournalManagerTester.getJournalEntries()[0].text == newEntry.text &&
            JournalManagerTester.getJournalEntries()[0].location == newEntry.location &&
            JournalManagerTester.getJournalEntries()[0].date == newEntry.date, "properties of entry are different")
        
        try! JournalManagerTester.updateJournalEntry(at: 0, with: updatedEntry)
        
        XCTAssert(JournalManagerTester.getJournalEntries()[0].text == updatedEntry.text &&
            JournalManagerTester.getJournalEntries()[0].location == updatedEntry.location &&
            JournalManagerTester.getJournalEntries()[0].date == updatedEntry.date, "properties of updated entry are different")
    }
    
    // Creates a journal entry and checks its time stamp, then updates it with a new time stamp and confirms that the time
    // stamp has changed to the new one
    func testDataStampCheck(){
        
        let oldDate = Date(timeIntervalSince1970: 0)
        let newDate = Date()
        
        var newEntry = JournalEntry(date: oldDate, text: "Testing some stuff", location: "Toronto, Canada")
        try! JournalManagerTester.addJournalEntry(newEntry)
        
        XCTAssert(JournalManagerTester.getJournalEntries()[0].date == oldDate, "Date is incorrect")
        
        newEntry = JournalEntry(date: newDate, text: "Testing some stuff", location: "Toronto, Canada")
        try! JournalManagerTester.updateJournalEntry(at: 0, with: newEntry)
        
        XCTAssert(JournalManagerTester.getJournalEntries()[0].date == newDate, "Date has not been updates")
        
    }
    
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        clearAllJournalEntries()
    }
    
    
    
}
