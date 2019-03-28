//
//  RepoTableViewController.swift
//  GitHub
//
//  Created by Meow on 3/27/19.
//  Copyright © 2019 Meow. All rights reserved.
//

import UIKit
import os.log

class RepoTableViewController: UITableViewController {

    // MARK: - Properties

    let rowHeight: CGFloat = 38

    var indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = .gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)

        let userDefaults = UserDefaults.standard
        if let decoded = userDefaults.data(forKey: "repos") {
            Global.shared.repos = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Repo]
            tableView.reloadData()
        }

        updateData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch segue.identifier ?? "" {
        case "ShowRepository":
            guard let repoViewController = segue.destination as? RepoViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }

            guard let selectedRepoCell = sender as? RepoTableViewCell else {
                fatalError("Unexpected sender")
            }

            guard let indexPath = tableView.indexPath(for: selectedRepoCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            repoViewController.repo = Global.shared.repos[indexPath.row]
        default:
            break
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.shared.repos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoTableViewCell", for: indexPath) as! RepoTableViewCell
        let repo = Global.shared.repos[indexPath.row]
        cell.repoNameLabel.text = repo.name

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    // MARK: - Actions

    @IBAction func logOut(_ sender: Any) {
        Global.shared.github.deauth()
        dismiss(animated: true)
    }

    // MARK: - Methods

    func updateData() {
        if Global.shared.repos.isEmpty {
            indicator.startAnimating()
            indicator.backgroundColor = UIColor.white
        }

        Global.shared.github.listRepos { response in
            Global.shared.repos = Repo.collection(response.result.value as! NSArray)
            let encodedData = try! NSKeyedArchiver.archivedData(withRootObject: Global.shared.repos, requiringSecureCoding: false)
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedData, forKey: "repos")
            userDefaults.synchronize()

            self.tableView.reloadData()

            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
        }
    }

}
