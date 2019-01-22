//
//  TaskListTableViewControllerTests.swift
//  ToDoListTests
//
//  Created by Andre Sanches Bocato on 17/01/19.
//  Copyright © 2019 Andre Sanches Bocato. All rights reserved.
//

import XCTest
import UIKit
import Foundation

class TaskListTableViewControllerTests: XCTestCase {
    
    // MARK: - Subject under test
        
    var sut: TaskListTableViewController!
    var window: UIWindow!
    
    // MARK: Test Lifecycle
        
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setUpTaskListTableViewController()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setUpTaskListTableViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "TaskListTableViewController") as! TaskListTableViewController
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: - Test doubles
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
