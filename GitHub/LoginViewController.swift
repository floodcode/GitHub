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

        if Global.shared.github.reauth() {
            self.performSegue(withIdentifier: "login", sender: self)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
        emailTextField.becomeFirstResponder()

        updateLoginButtonState()
    }

    // MARK: - Actions

    @IBAction func login(_ sender: Any) {
        performLogin()
    }

    // MARK: - Private methods

    private func updateLoginButtonState() {
        let emailText = emailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""

        loginButton.isEnabled = !emailText.isEmpty && !passwordText.isEmpty
    }

    private func performLogin() {
        // Login routine
        let emailText = emailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""

        Global.shared.github.auth(user: emailText, password: passwordText, handler: { [unowned self] ok in
            if ok {
                self.performSegue(withIdentifier: "login", sender: self)
            } else {
                let alert = UIAlertController(title: "GitHub", message: "Login or password is incorrect", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        })
    }

}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()

        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
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
