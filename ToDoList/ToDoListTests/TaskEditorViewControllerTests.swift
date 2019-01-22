//
//  TaskEditorViewControllerTests.swift
//  ToDoListTests
//
//  Created by Andre Sanches Bocato on 18/01/19.
//  Copyright © 2019 Andre Sanches Bocato. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import ToDoList

class TaskEditorViewControllerTests: XCTestCase {

    // MARK: - Properties
    
    var sut: TaskEditorViewController!

    // MARK: - Life cycle
    
    override func setUp() {
        super.setUp()

        TaskManager.shared.deleteAllTasks()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "TaskEditorViewController") as? TaskEditorViewController

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
    
    func testsSetupLayoutData() {
        let task = Task(id: "id", name: "name", description: "description", date: Date(), isCompleted: false)
        sut.selectedTask = task
        
        sut.setUpLayoutData()
        
        XCTAssert(sut.deleteButton.isHidden == false)
    }
    
    func testCompleteEdition() {
        sut.completeEdition()       // Falls in first condition
        
        let text = "any text"
        sut.nameTextField.text = text
        
        sut.completeEdition()
        
        // @TODO: test second condition (when nameTextField.text != ""
        
    }
    
    func testSaveTaskAfterEditing() {
        sut.saveTaskAfterEditing()
    }
    
    func testNoNameAlertController() {
        // @TODO: mock alert controller
        // @TODO: simulate tap on "ok" action
    }
    
    func testDeletionAlertController() {
        // @TODO: mock alert controller
        // @TODO: simulate tap on "delete"
        // @TODO: simulate tap on "cancel"
    }
    
//    func testTextFieldShouldReturn() {
//        // @TODO: mock textfield?
//    }
    
//    func testFinishEditingButton() {
//        // @TODO: press button (uibarbuttonitem)
//    }
    
    func testDeleteButton() {
        sut.deleteButton.sendActions(for: .touchUpInside)
    }
    
}
