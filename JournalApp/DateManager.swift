//
//  DateManager.swift
//  JournalApp
//
//  Created by Akshay Verma on 2019-03-04.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation

class DateManager{
    
    /// Returns a date to string format "Month DD, year" example "October 31, 2019"
    func formatDateIntoString(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM dd, yyyy")
        return dateFormatter.string(from: date)
    }
    
}
