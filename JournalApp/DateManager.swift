//
//  DateManager.swift
//  JournalApp
//
//  Created by Akshay Verma on 2019-03-04.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation

class DateManager{
    
    func formatDateIntoString(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM dd, yyyy")
        return dateFormatter.string(from: date)
    }
    
}
