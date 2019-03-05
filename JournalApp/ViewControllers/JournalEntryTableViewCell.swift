//
//  JournalEntryTableViewCell.swift
//  JournalApp
//
//  Created by Akshay Verma on 2019-03-04.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit

class JournalEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var journalEntryText: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
