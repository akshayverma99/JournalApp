//
//  JournalEntryTableViewController.swift
//  JournalApp
//
//  Created by Akshay Verma on 2019-03-04.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit

class JournalEntryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JournalEntryManager.getJournalEntries().count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entry", for: indexPath) as! JournalEntryTableViewCell

        // Configure the cell...
        
        cell.dateLabel.text = DateManager().formatDateIntoString(JournalEntryManager.getJournalEntries()[indexPath.row].date)
        cell.journalEntryText?.text = JournalEntryManager.getJournalEntries()[indexPath.row].text
        if let location = JournalEntryManager.getJournalEntries()[indexPath.row].location{
            cell.LocationLabel.isHidden = false
            cell.LocationLabel.text = location
        }else{
            cell.LocationLabel.isHidden = true
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newEntry"{
            if let newVC = segue.destination as? NewEntryViewController{
                newVC.previousView = self
            }
        }
    }
 


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            JournalEntryManager.removeJournalEntry(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } 
    }


}
