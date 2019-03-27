//
//  RepoCreateViewController.swift
//  GitHub
//
//  Created by Meow on 3/27/19.
//  Copyright © 2019 Meow. All rights reserved.
//

import UIKit

class NewRepoViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var visibilitySegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        descriptionTextField.delegate = self

        updateSaveButtonState()
    }

    // MARK: - Actions
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func save(_ sender: Any) {
        dismiss(animated: true)
    }

    // MARK: - Private methods

    private func updateSaveButtonState() {
        let repoNameText = nameTextField.text ?? ""
        saveButton.isEnabled = !repoNameText.isEmpty
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

// MARK: - UITextFieldDelegate

extension NewRepoViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            descriptionTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }

        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }

}
