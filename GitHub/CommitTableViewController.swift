//
//  CommitTableViewController.swift
//  GitHub
//
//  Created by Meow on 3/27/19.
//  Copyright © 2019 Meow. All rights reserved.
//

import UIKit

class CommitTableViewController: UITableViewController {

    // MARK: - Properties

    let rowHeight: CGFloat = 64

    var user: String!
    var repo: String!

    var indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = .gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)

        updateData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.shared.commits[commitKey()]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommitTableViewCell", for: indexPath) as! CommitTableViewCell

        let commits = Global.shared.commits[commitKey()]
        let commit = commits![indexPath.row]
        let hashIndex = commit.hash.index(commit.hash.startIndex, offsetBy: 7)

        cell.messageLabel.text = commit.message
        cell.hashLabel.text = String(commit.hash[..<hashIndex])
        cell.authorLabel.text = commit.author
        cell.dateLabel.text = commit.date

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    // MARK: - Private methods

    private func commitKey() -> String {
        return user + ":" + repo
    }

    private func updateData() {
        if Global.shared.commits[commitKey()] == nil {
            Global.shared.commits[commitKey()] = [Commit]()
        }

        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white

        Global.shared.github.listCommits(user: user, repo: repo) { response in

            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }

            Global.shared.commits[self.commitKey()] = Commit.collection(response.result.value as! NSArray)
            self.tableView.reloadData()

            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
        }
    }

}
