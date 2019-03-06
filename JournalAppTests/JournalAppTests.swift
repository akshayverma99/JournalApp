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
            JournalManagerTester.removeJournalEntry(at: 0)
        }
    }
    
    class JournalManagerTester: JournalEntryManager{}
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        clearAllJournalEntries()
    }
    
    func testAddJournalEntry(){
        let newEntry = JournalEntry(date: Date(), text: "Testing some stuff", location: "Toronto, Canada")
        JournalManagerTester.addJournalEntry(newEntry)
        XCTAssert(JournalManagerTester.getJournalEntries().count == 1, "More or less than 1 entry")
        XCTAssert(JournalManagerTester.getJournalEntries()[0].text == newEntry.text &&
            JournalManagerTester.getJournalEntries()[0].location == newEntry.location &&
            JournalManagerTester.getJournalEntries()[0].date == newEntry.date, "properties of entry are different")
    }
    
    func testDeleteEntry(){
        let newEntry = JournalEntry(date: Date(), text: "Testing some stuff", location: "Toronto, Canada")
        JournalManagerTester.addJournalEntry(newEntry)
        XCTAssert(JournalManagerTester.getJournalEntries().count == 1, "More or less than 1 entry")
        JournalManagerTester.removeJournalEntry(at: 0)
        XCTAssert(JournalManagerTester.getJournalEntries().count == 0, "Contains entries")
    }
    
    func testEntryEditing(){
        let newEntry = JournalEntry(date: Date(), text: "Testing some stuff", location: "Toronto, Canada")
        let updatedEntry = JournalEntry(date: Date(), text: "Doing some more testing", location: nil)
        JournalManagerTester.addJournalEntry(newEntry)
        
        XCTAssert(JournalManagerTester.getJournalEntries()[0].text == newEntry.text &&
            JournalManagerTester.getJournalEntries()[0].location == newEntry.location &&
            JournalManagerTester.getJournalEntries()[0].date == newEntry.date, "properties of entry are different")
        
        JournalManagerTester.updateJournalEntry(at: 0, with: updatedEntry)
        
        XCTAssert(JournalManagerTester.getJournalEntries()[0].text == updatedEntry.text &&
            JournalManagerTester.getJournalEntries()[0].location == updatedEntry.location &&
            JournalManagerTester.getJournalEntries()[0].date == updatedEntry.date, "properties of updated entry are different")
    }
    
    func testDataStampCheck(){
        
        let oldDate = Date(timeIntervalSince1970: 0)
        let newDate = Date()
        
        var newEntry = JournalEntry(date: oldDate, text: "Testing some stuff", location: "Toronto, Canada")
        JournalManagerTester.addJournalEntry(newEntry)
        
        XCTAssert(JournalManagerTester.getJournalEntries()[0].date == oldDate, "Date is incorrect")
        
        newEntry = JournalEntry(date: newDate, text: "Testing some stuff", location: "Toronto, Canada")
        JournalManagerTester.updateJournalEntry(at: 0, with: newEntry)
        
        XCTAssert(JournalManagerTester.getJournalEntries()[0].date == newDate, "Date has not been updates")
        
    }
    
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        clearAllJournalEntries()
    }
    
    
    
}
