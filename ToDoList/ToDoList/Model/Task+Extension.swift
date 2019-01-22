//
//  Task+Extension.swift
//  ToDoList
//
//  Created by Andre Sanches Bocato on 10/01/19.
//  Copyright © 2019 Andre Sanches Bocato. All rights reserved.
//

import Foundation
import UIKit

extension Task {
    
    func convertDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM, HH:mm"
        return dateFormatter.string(from: (date))
    }
    
    func setTaskDescription() -> String {
        var descriptionString = String()
        if description != "" {
            descriptionString = description
        } else {
            descriptionString = "(No description)"
        }
        return descriptionString
    }
    
    func setTaskColor() -> UIColor {
        var taskColor: UIColor = .black
        if isCompleted {
            taskColor = .gray
        }
        return taskColor
    }
    
}
