//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Andre Sanches Bocato on 08/01/19.
//  Copyright © 2019 Andre Sanches Bocato. All rights reserved.
//

import XCTest
@testable import ToDoList

class ToDoListTests: XCTestCase {
    
    override func setUp() {
        TaskManager.shared.deleteAllTasks()
    }
    
    override func tearDown() {
        TaskManager.shared.deleteAllTasks()
    }

    func testSaveNew() {
        let task = Task(id: UUID().uuidString, name: "teste", description: "teste", date: Date(), isCompleted: false)
        
        TaskManager.shared.saveTask(task: task)
        XCTAssert(TaskManager.shared.tasks.count == 1)
        
        TaskManager.shared.deleteTask(id: task.id)
        XCTAssert(TaskManager.shared.tasks.count == 0)
    }
    
    func testUpdate() {
        var task = Task(id: UUID().uuidString, name: "teste", description: "teste", date: Date(), isCompleted: false)
        TaskManager.shared.saveTask(task: task)
        
        task.name = "teste update"
        TaskManager.shared.saveTask(task: task)
        let foundTask = TaskManager.shared.tasks.filter { $0.id == task.id }.first
        
        XCTAssert(foundTask != nil)
        XCTAssert(foundTask!.name == "teste update")
    }
    
    func testDateToString() {
        // @TODO: Test task.convertDateToString method
        var dateComponents = DateComponents()
        dateComponents.year = 2019
        dateComponents.month = 1
        dateComponents.day = 18
        dateComponents.hour = 10
        dateComponents.minute = 30
        
        let date = Calendar.current.date(from: dateComponents)!
        let task = Task(id: UUID().uuidString, name: "teste", description: "", date: date, isCompleted: false)
        let dateString = task.convertDateToString()
        
        XCTAssert(dateString == "18/Jan, 10:30")
    }
    
    func testSetDescription() {
        var task = Task(id: UUID().uuidString, name: "teste", description: "", date: Date(), isCompleted: false)
        let description = task.setTaskDescription()
        
        XCTAssert(description == "(No description)")
        
        task.description = "teste"
        TaskManager.shared.saveTask(task: task)
        let description2 = task.setTaskDescription()
        
        XCTAssert(description2 == "teste")
    }
    
    func testTaskColor() {
        let task = Task(id: UUID().uuidString, name: "teste", description: "teste", date: Date(), isCompleted: true)
        let color = task.setTaskColor()
        
        XCTAssert(color == .gray)
        
        let task2 = Task(id: UUID().uuidString, name: "teste2", description: "teste2", date: Date(), isCompleted: false)
        let color2 = task2.setTaskColor()
        
        XCTAssert(color2 == .black)
    }
    
    func testCompletingTask() {
        let task = Task(id: UUID().uuidString, name: "teste", description: "teste", date: Date(), isCompleted: false)
        TaskManager.shared.saveTask(task: task)
        
        TaskManager.shared.setTaskAsCompleted(task.id)
        let foundTask = TaskManager.shared.tasks.filter { $0.id == task.id }.first
        
        XCTAssert(foundTask!.isCompleted == true)
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
