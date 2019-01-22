//
//  TaskListTableViewController.swift
//  ToDoList
//
//  Created by Andre Sanches Bocato on 08/01/19.
//  Copyright © 2019 Andre Sanches Bocato. All rights reserved.
//

import Foundation
import UIKit

class TaskListTableViewController: UITableViewController {
    
    // MARK: - Properties

//    var tasks: [Task] {
//        return TaskManager.shared.tasks
//    }
    var upcomingTasks: [Task] {
        return TaskManager.shared.tasks.filter({ !$0.isCompleted })
    }
    var completedTasks: [Task] {
        return TaskManager.shared.tasks.filter({ $0.isCompleted })
    }
    var selectedTask: Task?
    var dateString = ""
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TaskManager.shared.delegate = self
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateButtonLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueEditTask", let vc = segue.destination as? TaskEditorViewController  {
            vc.selectedTask = selectedTask
            
        } else if segue.identifier == "SegueNewTask", let vc = segue.destination as? TaskEditorViewController {
            selectedTask = nil
            vc.selectedTask = nil
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return setUpTitleForSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setUpNumberOfRowsInSection(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        return configureCell(cell: cell, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tasks = setUpTasksArray(indexPath: indexPath, section: indexPath.section)
        selectedTask = tasks[indexPath.row]
        performSegue(withIdentifier: "SegueEditTask", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteRowAction = setUpDeleteAction()
        let editRowAction = setUpEditAction()
        let markCompletionRowAction = markAsUpcomingOrComplete(indexPath: indexPath)
        
        return [markCompletionRowAction, editRowAction, deleteRowAction]
    }
    
    // MARK: - Helper Functions
    
    func updateButtonLayout() {
        editButtonItem.isEnabled = true
        if TaskManager.shared.tasks.count == 0 {
            editButtonItem.isEnabled = false
        }
        
        tableView.setEditing(false, animated: true)
        setEditing(false, animated: true)
    }
    
    func setUpTasksArray(indexPath: IndexPath, section: Int) -> [Task] {
        var tasks = upcomingTasks
        if indexPath.section == 1 {
            tasks = completedTasks
        }
        return tasks
    }

    func makeTextBold(string: String) -> NSMutableAttributedString {
        let boldAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.boldSystemFont(ofSize: 20)]
        let boldString = NSMutableAttributedString(string: string, attributes: boldAttributes)
        return boldString
    }
    
    func setUpAttributedText(task: Task) -> NSMutableAttributedString {
        let attributedString = makeTextBold(string: "\(task.name)")
        let line2AttributedString = NSAttributedString(string: "\n\(task.convertDateToString())", attributes: nil)
        attributedString.append(line2AttributedString)
        let line3AttributedString = NSAttributedString(string: "\n\(task.setTaskDescription())", attributes: nil)
        attributedString.append(line3AttributedString)
        return attributedString
    }
    
   func markCompletionStateAndSaveTask(indexPath: IndexPath) {
        let tasks = setUpTasksArray(indexPath: indexPath, section: indexPath.section)
        var task = tasks[indexPath.row]
        task.isCompleted = !task.isCompleted
        TaskManager.shared.saveTask(task: task)
    }
    
    func markAsUpcomingOrComplete(indexPath: IndexPath) -> UITableViewRowAction {
        let tasks = setUpTasksArray(indexPath: indexPath, section: indexPath.section)
        let task = tasks[indexPath.row]
        if task.isCompleted {
            return setUpMarkCompletionStateAction(completionTitle: "Mark as upcoming")
        } else {
            return setUpMarkCompletionStateAction(completionTitle: "Mark as completed")
        }
    }
    
    // MARK: - Tableview helper functions
  
    func setUpTitleForSection(section: Int) -> String {
        switch section {
        case 0:
            return "Upcoming"
        case 1:
            return "Completed"
        default:
            return "Error fetching title for section"
        }
    }
    
    func setUpNumberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return upcomingTasks.count
        case 1:
            return completedTasks.count
        default:
            return 0
        }
    }
    
    func configureCell(cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCell {
        let tasks = setUpTasksArray(indexPath: indexPath, section: indexPath.section)
        let task = tasks[indexPath.row]
        
        cell.textLabel?.numberOfLines = 5
        cell.textLabel?.attributedText = setUpAttributedText(task: task)
        cell.textLabel?.textColor = task.setTaskColor()
        
        return cell
    }
    
    func setUpDeleteAction() -> UITableViewRowAction {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            let tasks = self.setUpTasksArray(indexPath: indexPath, section: indexPath.section)
            self.showDeleteTaskAlert(tasks: tasks, indexPath: indexPath)
        }
        deleteAction.backgroundColor = .red
        return deleteAction
    }
    
    func setUpEditAction() -> UITableViewRowAction {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { [weak self] (rowAction, indexPath) in
            let tasks = self?.setUpTasksArray(indexPath: indexPath, section: indexPath.section)
            self?.selectedTask = tasks?[indexPath.row]
            self?.performSegue(withIdentifier: "SegueEditTask", sender: self)
        }
        return editAction
    }
    
    func setUpMarkCompletionStateAction(completionTitle: String) -> UITableViewRowAction {
        let markCompletionStateAction = UITableViewRowAction(style: .normal, title: completionTitle) { (rowAction, indexPath) in
            self.markCompletionStateAndSaveTask(indexPath: indexPath)
        }
        markCompletionStateAction.backgroundColor = .blue
        return markCompletionStateAction
    }
    
    // MARK: - Show alert controller functions
    
    func showDeleteTaskAlert(tasks: [Task], indexPath: IndexPath) {
        let deleteTasklertController = UIAlertController(title: "Delete task", message: "Are you sure you want to delete this task? This action cannot be undone.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
            let task = tasks[indexPath.row]
            TaskManager.shared.deleteTask(id: task.id)
            self.updateButtonLayout()
        }
        
        deleteTasklertController.addAction(cancelAction)
        deleteTasklertController.addAction(okAction)
        self.present(deleteTasklertController, animated: true, completion: nil)
    }
    
}

// MARK: - Extensions

extension TaskListTableViewController: TaskManagerDelegate {
    func didUpdateTasks() {
        tableView.reloadData()
    }
}


