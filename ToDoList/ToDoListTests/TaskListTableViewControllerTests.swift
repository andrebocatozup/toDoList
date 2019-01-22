//
//  TaskListTableViewControllerTests.swift
//  ToDoListTests
//
//  Created by Andre Sanches Bocato on 18/01/19.
//  Copyright © 2019 Andre Sanches Bocato. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import ToDoList

class TaskListTableViewControllerTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: TaskListTableViewController!
    
    // MARK: - Life Cycle
    
    override func setUp() {
        super.setUp()
        
        TaskManager.shared.deleteAllTasks()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "TaskListTableViewController") as? TaskListTableViewController
        
        UIApplication.shared.keyWindow!.rootViewController = sut
        
        // Test and Load the View at the Same Time!
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sut.view)
    }

    override func tearDown() {
        super.tearDown()
        
        TaskManager.shared.deleteAllTasks()
    }
    
    // MARK: - Tests
    
    func testLoadingTableViewDataWithCompletedTask() {
        TaskManager.shared.deleteAllTasks()
        
        let completedTask = Task(id: UUID().uuidString, name: "completedTask", description: "teste", date: Date(), isCompleted: true)
        TaskManager.shared.saveTask(task: completedTask)
        
        let upcomingTask = Task(id: UUID().uuidString, name: "completedTask", description: "teste", date: Date(), isCompleted: false)
        TaskManager.shared.saveTask(task: upcomingTask)

        XCTAssert(TaskManager.shared.tasks.count == 2)
    }
    
    func testPerformSegues() {
        let taskEditor = TaskEditorViewController()
        
        let segueEditTask = UIStoryboardSegue(identifier: "SegueEditTask", source: sut, destination: taskEditor)
        sut.prepare(for: segueEditTask, sender: (Any).self)
        
        let segueNewTask = UIStoryboardSegue(identifier: "SegueNewTask", source: sut, destination: taskEditor)
        sut.prepare(for: segueNewTask, sender: (Any).self)
    }
    
    func testCellForRowAt() {
        // @TODO:
    }
    
    func testDidSelectRowAt() {
        // @TODO:
    }
    
    func testEditActionsForRowAt() {
        // @TODO:
    }
    
}
