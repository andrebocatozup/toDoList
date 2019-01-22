//
//  TaskEditorViewController.swift
//  ToDoList
//
//  Created by Andre Sanches Bocato on 08/01/19.
//  Copyright © 2019 Andre Sanches Bocato. All rights reserved.
//

import Foundation
import UIKit

class TaskEditorViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var finishEditingTaskButton: UIBarButtonItem!

    // MARK: - IBActions
    
    @IBAction func finishEditingTask(_ sender: Any) {
        completeEdition()
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        showDeletionConfirmationAlert()
    }

    // MARK: - Properties
    
    var selectedTask: Task?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldsDelegate(textField: nameTextField)
        setTextFieldsDelegate(textField: descriptionTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpLayoutData()
    }
    
    // MARK: - Helper Functions
    
    func setTextFieldsDelegate(textField: UITextField) {
        textField.delegate = self
    }
    
    func setUpLayoutData() {
        deleteButton.isHidden = true
        
        if let selectedTask = selectedTask {
            nameTextField?.text = selectedTask.name
            descriptionTextField?.text = selectedTask.description
            datePicker?.date = selectedTask.date
            
            deleteButton.isHidden = false
        } else {
            nameTextField.becomeFirstResponder()
        }
    }
    
    func completeEdition() {
        if nameTextField.text == "" {
            showNoTaskNameAlert()
        } else {
            saveTaskAfterEditing()
        }
    }
    
    func saveTaskAfterEditing() {
        let id = selectedTask?.id ?? UUID().uuidString      // Overwrites existing task data (selectedTask) or generates ID for a new task
        let newTask = Task(id: id, name: nameTextField.text!, description: descriptionTextField.text!, date: datePicker.date, isCompleted: false)
        TaskManager.shared.saveTask(task: newTask)
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Show alert controller functions
    
    func showNoTaskNameAlert() {
        let noTaskNameAlertController = UIAlertController(title: "Your task needs a name.", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        
        noTaskNameAlertController.addAction(okAction)
        present(noTaskNameAlertController, animated: true, completion: nil)
  }
    
    func showDeletionConfirmationAlert() {
        let deletionConfirmationAlertController = UIAlertController(title: "Delete task", message: "Are you sure you want to delete this task? This action cannot be undone.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action -> Void in
            if let id = self.selectedTask?.id {
                TaskManager.shared.deleteTask(id: id)
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        deletionConfirmationAlertController.addAction(cancelAction)
        deletionConfirmationAlertController.addAction(deleteAction)
        present(deletionConfirmationAlertController, animated: true, completion: nil)
    }
    
}

// MARK: - Extensions

extension TaskEditorViewController: UITextFieldDelegate {

    // MARK: - Textfield Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            descriptionTextField.becomeFirstResponder()
        }
    }
    
}
