//
//  NewEntryViewController.swift
//  JournalApp
//
//  Created by Akshay Verma on 2019-03-04.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit

class NewEntryViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSaveButton()
        updateDateLabel()
        
    }

    func setupSaveButton(){
        saveButton.layer.cornerRadius = 20
    }
    
    func updateDateLabel(){
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM dd, yyyy")
        dateLabel.text = dateFormatter.string(from: currentDate)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if !textField.text.isEmpty{
            let newEntry = JournalEntry(date: Date(timeIntervalSinceNow: 0), text: textField.text)
            JournalEntryManager.addJournalEntry(newEntry)
        }
    }
    

}
