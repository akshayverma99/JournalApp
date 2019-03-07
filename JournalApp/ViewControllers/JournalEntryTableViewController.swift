//
//  JournalEntryTableViewController.swift
//  JournalApp
//
//  Created by Akshay Verma on 2019-03-04.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit

class JournalEntryTableViewController: UITableViewController {

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        JournalEntryManager.updateJournalEntries()
        return JournalEntryManager.getJournalEntries().count
    }

    // Creates the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entry", for: indexPath) as! JournalEntryTableViewCell
        
        // Populating Cell info
        cell.dateLabel.text = DateManager().formatDateIntoString(JournalEntryManager.getJournalEntries()[indexPath.row].date)
        cell.journalEntryText?.text = JournalEntryManager.getJournalEntries()[indexPath.row].text
        
        // If there is a location, it is displayed, otherwise it is hidden
        if let location = JournalEntryManager.getJournalEntries()[indexPath.row].location{
            cell.LocationLabel.isHidden = false
            cell.LocationLabel.text = location
        }else{
            cell.LocationLabel.isHidden = true
        }
        
        return cell
    }
    
    
    // Lets the editing view controller (NewEntryViewController) know if
    // it is editing an entry or creating a new one
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newEntry"{
            if let newVC = segue.destination as? NewEntryViewController{
                newVC.previousView = self
            }
        }else if segue.identifier == "edit"{
            if let newVC = segue.destination as? NewEntryViewController, let cell = sender as? JournalEntryTableViewCell,
                let index = tableView.indexPath(for: cell){
                newVC.index = index.row
                newVC.previousView = self
            }
        }
    }
 
    // MARK: TableView Editing
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do{
                try JournalEntryManager.removeJournalEntry(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }catch{
                presentUnableToDeleteModal()
            }

        } 
    }
    
    /// Lets the user know that his entry was not deleted
    func presentUnableToDeleteModal(){
        let modalView = UIAlertController(title: "Delete Failed", message: "Unable to delete your entry, please retry", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        modalView.addAction(okButton)
        present(modalView, animated: true, completion: nil)
    }
    
    


}
