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
    @IBOutlet weak var locationLabel: UIButton!
    
    var locationString: String?
    
    var currentDate = Date()
    
    private var editingModeEnabled = false
    var index: Int?{
        didSet{
            if index != nil{
                editingModeEnabled = true
            }
        }
    }
    
    var previousView: JournalEntryTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSaveButton()
        updateDateLabel()
        
        if editingModeEnabled{
            updateForEditing()
        }
        
    }
    
    func updateForEditing(){
        
        self.title = "Edit Entry"
        
        if let index = index{
            let currentEntry = JournalEntryManager.getJournalEntries()[index]
            dateLabel.text = DateManager().formatDateIntoString(currentEntry.date)
            textField.text = currentEntry.text
            
            if let location = currentEntry.location{
                locationLabel.isEnabled = false
                locationLabel.setTitle(location, for: .disabled)
            }else{
                locationLabel.isHidden = true
            }
        }
    }

    func setupSaveButton(){
        saveButton.layer.cornerRadius = 22
    }
    
    func updateDateLabel(){
        let dateFormatter = DateManager()
        dateLabel.text = dateFormatter.formatDateIntoString(currentDate)
        
    }
    
    func presentNoTextModal(){
        let modalView = UIAlertController(title: "No Text", message: "Please insert some text into the journal entry", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        modalView.addAction(okButton)
        present(modalView, animated: true, completion: nil)
    }
    
    func updateLocationLabel(string: String){
        locationLabel.isEnabled = false
        locationLabel.setTitle(string, for: .disabled)
        self.locationString = string
    }
    
    func noLocation(){
        locationLabel.isEnabled = false
        locationLabel.setTitle("Location Services Disabled", for: .disabled)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        CLGeocoder().reverseGeocodeLocation(locations[0]){ placemark, error in
            // FIXME: Add error handling
            if error != nil{
                self.noLocation()
            }
            
            if let placemark = placemark, let city = placemark.first?.locality, let country = placemark.first?.country{
                let newString = "\(city), \(country)"
                self.updateLocationLabel(string: newString)
            }else{
                self.noLocation()
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if !textField.text.isEmpty{
            let newEntry = JournalEntry(date: currentDate, text: textField.text, location: locationString)
            if editingModeEnabled{
                JournalEntryManager.updateJournalEntry(at: index!, with: newEntry)
            }else{
                JournalEntryManager.addJournalEntry(newEntry)
            }
            LocationManager.shared.stopUpdatingLocation()
            previousView.tableView.reloadData()
            navigationController?.popViewController(animated: true)
        }else{
            presentNoTextModal()
        }
    }
    
    @IBAction func addLocationPressed(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled(){
            LocationManager.shared.requestWhenInUseAuthorization()
            LocationManager.shared.delegate = self
            LocationManager.shared.startUpdatingLocation()
        }else{
            noLocation()
        }
    }
    

    
    
    
}
