//
//  NewEntryViewController.swift
//  JournalApp
//
//  Created by Akshay Verma on 2019-03-04.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit
import CoreLocation


class NewEntryViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    var locationString: String?
    var currentDate = Date()
    
    // If an index is passed in, the class assumes it is in editing mode
    private var editingModeEnabled = false
    var index: Int?{
        didSet{
            if index != nil{
                editingModeEnabled = true
            }
        }
    }
    
    // Used to update the table view when a new entry is saved
    var previousView: JournalEntryTableViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Updates information and sets up ui
        setupSaveButton()
        updateDateLabel()
        
        // If in editing mode, updates the labels
        if editingModeEnabled{
            updateForEditing()
        }
        
    }

    /// Fills in all the labels for the entry that is being edited
    func updateForEditing(){
        
        self.title = "Edit Entry"
        
        if let index = index{
            let currentEntry = JournalEntryManager.getJournalEntries()[index]
            dateLabel.text = DateManager().formatDateIntoString(currentEntry.date)
            textField.text = currentEntry.text
            
            if let location = currentEntry.location{
                locationButton.isEnabled = false
                locationButton.setTitle(location, for: .disabled)
            }else{
                locationButton.isHidden = true
            }
        }
    }

    /// Rounds out the save button
    func setupSaveButton(){
        saveButton.layer.cornerRadius = 20
    }
    
    /// Takes the date and updates it to format (Month dd, Year)
    func updateDateLabel(){
        let dateFormatter = DateManager()
        dateLabel.text = dateFormatter.formatDateIntoString(currentDate)
    }
    
    /// Presents a modal alerting the user that they have not entered any text
    func presentNoTextModal(){
        let modalView = UIAlertController(title: "No Text", message: "Please insert some text into the journal entry", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        modalView.addAction(okButton)
        present(modalView, animated: true, completion: nil)
    }
    
    /// Presents a modal alerting the user that their location cannot be located
    func presentLocationModal(){
        let modalView = UIAlertController(title: "Location Unavailable", message: "Unable to locate your city", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        modalView.addAction(okButton)
        present(modalView, animated: true, completion: nil)
    }
    
    /// Presents a modal alerting the user that their entry was not saved
    func presentRetry(){
        let modalView = UIAlertController(title: "Save Failed", message: "Unable to save your entry, please retry", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        modalView.addAction(okButton)
        present(modalView, animated: true, completion: nil)
    }
    
    /// Updates the location button with a string and also disables it
    func updateLocationLabel(string: String){
        locationButton.isEnabled = false
        locationButton.setTitle(string, for: .disabled)
        self.locationString = string
    }
    
    /// Disables the location button and displays a message letting the user know
    func disableLocation(){
        locationButton.isEnabled = false
        locationButton.setTitle("Location Services Disabled", for: .disabled)
    }
    
    // Called when the location is recieved/updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(locations[0]){ placemark, error in
            if error != nil{
                self.presentLocationModal()
                self.disableLocation()
            }
            if let placemark = placemark, let city = placemark.first?.locality, let country = placemark.first?.country{
                let newString = "\(city), \(country)"
                self.updateLocationLabel(string: newString)
            }else{
                self.disableLocation()
            }
        }
    }
    
    // If the application fails to get a location, the location button is disabled and the user is notified
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        disableLocation()
        presentLocationModal()
    }
    
    /// Saves the users inputted information, if the save fails, the user is notified
    /// also notifies the user if they try to save without any text input
    @IBAction func saveButtonPressed(_ sender: Any) {
        if !textField.text.isEmpty{
            let newEntry = JournalEntry(date: currentDate, text: textField.text, location: locationString)
            if editingModeEnabled{
                do{
                    try JournalEntryManager.updateJournalEntry(at: index!, with: newEntry)
                    LocationManager.shared.stopUpdatingLocation()
                    previousView.tableView.reloadData()
                    navigationController?.popViewController(animated: true)
                }catch{
                    presentRetry()
                }
            }else{
                do{
                    try JournalEntryManager.addJournalEntry(newEntry)
                    LocationManager.shared.stopUpdatingLocation()
                    previousView.tableView.reloadData()
                    navigationController?.popViewController(animated: true)
                }catch{
                    presentRetry()
                }
            }
        }else{
            presentNoTextModal()
        }
    }
    
    /// Prompts the user to allow location services
    /// and begins the location process
    /// also handles the user declining location services
    @IBAction func addLocationPressed(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled(){
            LocationManager.shared.requestWhenInUseAuthorization()
            LocationManager.shared.delegate = self
            LocationManager.shared.startUpdatingLocation()
        }else{
            disableLocation()
        }
    }
  
}
