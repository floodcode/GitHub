//
//  GitHubService.swift
//  GitHub
//
//  Created by Meow on 3/27/19.
//  Copyright © 2019 Meow. All rights reserved.
//

import Alamofire

class GitHubService {

    static let BaseURL = "https://api.github.com"
    static let CredentialsKey = "credentials"

    var headers = [String: String]()

    func auth(user: String, password: String, handler: @escaping (_: Bool) -> Void) {
        let credentialData = "\(user):\(password)".data(using: .utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        let headers = ["Authorization": "Basic \(base64Credentials)"]

        Alamofire.request(GitHubService.BaseURL + "/user", method: .get, parameters: nil, headers: headers)
            .responseJSON { (response) in
                if let code = response.response?.statusCode, code == 200 {
                    UserDefaults.standard.set(base64Credentials, forKey: GitHubService.CredentialsKey)
                    self.headers = headers
                    handler(true)
                } else {
                    self.deauth()
                    handler(false)
                }
        }
    }

    func reauth() -> Bool {
        if let credentials = UserDefaults.standard.string(forKey: GitHubService.CredentialsKey) {
            headers = ["Authorization": "Basic \(credentials)"]
            return true
        }

        return false
    }

    func deauth() {
        UserDefaults.standard.removeObject(forKey: GitHubService.CredentialsKey)
        UserDefaults.standard.removeObject(forKey: "repos")
        UserDefaults.standard.synchronize()
    }

    func getUser(_ handler: @escaping (DataResponse<Any>) -> Void) {
        get("/user", nil, handler)
    }

    func createRepo(name: String, description: String, priv: Bool, _ handler: @escaping (DataResponse<Any>) -> Void) {
        let parameters: [String: Any] = [
            "name": name,
            "description": description,
            "private": priv,
        ]

        post("/user/repos", parameters, handler)
    }

    func listRepos(_ handler: @escaping (DataResponse<Any>) -> Void) {
        get("/user/repos", nil, handler)
    }

    func listCommits(user: String, repo: String, _ handler: @escaping (DataResponse<Any>) -> Void) {
        get("/repos/\(user)/\(repo)/commits", nil, handler)
    }

    // MARK: - Private methods

    private func makeRequest(method: HTTPMethod, path: String, parameters: Parameters?) -> DataRequest {
        return Alamofire.request(GitHubService.BaseURL + path, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
    }

    private func get(_ path: String, _ parameters: Parameters?, _ handler: @escaping (DataResponse<Any>) -> Void) {
        makeRequest(method: .get, path: path, parameters: parameters)
            .responseJSON(completionHandler: { data in self.handleErrors(data); handler(data) })
    }

    private func post(_ path: String, _ parameters: Parameters?, _ handler: @escaping (DataResponse<Any>) -> Void) {
        makeRequest(method: .post, path: path, parameters: parameters)
            .responseJSON(completionHandler: { data in self.handleErrors(data); handler(data) })
    }

    private func handleErrors(_ response: DataResponse<Any>) {
        let code = response.response?.statusCode
        if let code = code {
            if code == 401 {
                deauth()
            } else if code >= 400 && code <= 499 {
                if let body = response.result.value as? NSDictionary {
                    if let message = body["message"] as? String {
                        let alert = UIAlertController(title: "GitHub", message: message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        alert.show(UIViewController(), sender: nil)

                        print("GutHub service error: \(message)")
                    }
                }
            }
        }
    }

}
