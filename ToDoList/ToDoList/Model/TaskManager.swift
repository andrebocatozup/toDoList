//
//  TaskManager.swift
//  ToDoList
//
//  Created by Andre Sanches Bocato on 09/01/19.
//  Copyright © 2019 Andre Sanches Bocato. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

protocol  UserDefaultsProtocol {
    func setValue(_ value: Any?, forKey key: String)
    func value(forKey key: String) -> Any?
}

class UserDefaultsImpl: UserDefaultsProtocol {
    func setValue(_ value: Any?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    func value(forKey key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
}

protocol TaskManagerDelegate: class {
    func didUpdateTasks()
}

class TaskManager: NSObject {
    
    // MARK: - Properties
    
    private let tasksKey = "TasksKey"
    static let shared = TaskManager()
    private(set) var tasks = [Task]()
    weak var delegate: TaskManagerDelegate?
    
    private var userDefaults: UserDefaultsProtocol = UserDefaultsImpl()
    
    private override init() {
        super.init()
        restoreData()
    }

    // MARK: - Functions
    
    func deleteAllTasks() {
        let notCompletedTasks = tasks.filter { !$0.isCompleted }
        for task in notCompletedTasks {
             NotificationManager.shared.removePushNotification(notificationId: task.id)
        }
        tasks = []
        persistData()
    }
    
    func saveTask(task: Task, schedule: Bool = true) {
        let index = tasks.firstIndex { $0.id == task.id }
        if let foundIndex = index {
            tasks.remove(at: foundIndex)
        }
        tasks.append(task)
        persistData()
        if schedule {
            NotificationManager.shared.sendPushNotification(task: task)
        }
        delegate?.didUpdateTasks()
    }
    
    func deleteTask(id: String) {
        let index = tasks.firstIndex {
            $0.id == id
        }
        guard let foundIndex = index else { return }
        tasks.remove(at: foundIndex)
        persistData()
        NotificationManager.shared.removePushNotification(notificationId: id)
        delegate?.didUpdateTasks()
    }
    
    fileprivate func restoreData() {
        guard let data = userDefaults.value(forKey: tasksKey) as? Data else { return }
        let decodedTasks = try? JSONDecoder().decode([Task].self, from: data)
        tasks = decodedTasks ?? []
    }
    
    fileprivate func persistData() {
        guard let encodedTasks = try? JSONEncoder().encode(tasks) else { return }
        userDefaults.setValue(encodedTasks, forKey: tasksKey)
    }
    
    func setTaskAsCompleted(_ taskId: String, isCompleted: Bool = true) {       // isCompleted is set to true in the function declaration
        let foundTask = tasks.filter {
            $0.id == taskId
        }.first
        
        guard var task = foundTask else { return }
        
        task.isCompleted = isCompleted
        saveTask(task: task, schedule: false)
        NotificationManager.shared.removePushNotification(notificationId: taskId)
    }
    
}
