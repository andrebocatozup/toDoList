//
//  Task.swift
//  ToDoList
//
//  Created by Andre Sanches Bocato on 08/01/19.
//  Copyright © 2019 Andre Sanches Bocato. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Properties

struct Task: Codable {
    var id: String = UUID().uuidString
    var name: String
    var description: String
    var date: Date
    var isCompleted = false

// MARK: - Initialization

    init(id: String, name: String, description: String, date: Date, isCompleted: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.date = date
        self.isCompleted = isCompleted
    }
}
