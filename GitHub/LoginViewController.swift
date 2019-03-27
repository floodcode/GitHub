//
//  ViewController.swift
//  GitHub
//
//  Created by Meow on 3/27/19.
//  Copyright © 2019 Meow. All rights reserved.
//

import UIKit
import os.log

class LoginViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self

        updateLoginButtonState()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        emailTextField.text = ""
        passwordTextField.text = ""
        updateLoginButtonState()
    }

    // MARK: - Private methods

    private func updateLoginButtonState() {
        let emailText = emailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""

        loginButton.isEnabled = !emailText.isEmpty && !passwordText.isEmpty
    }

    private func performLogin() {
        // Login routine
    }

}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            performLogin()
        default:
            os_log("Unexpected text field in LoginViewController", log: .default, type: .error)
        }

        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateLoginButtonState()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateLoginButtonState()
    }

}
