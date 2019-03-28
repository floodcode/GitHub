//
//  RepoViewController.swift
//  GitHub
//
//  Created by Meow on 3/27/19.
//  Copyright © 2019 Meow. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {

    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var commitsButton: UIBarButtonItem!
    @IBOutlet weak var authorImageView: UIImageView!

    var repo: Repo! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Private methods

    private func updateData() {
        if repo.size == 0 {
            commitsButton.isEnabled = false
        }

        navigationItem.title = repo.name
        descriptionLabel.text = repo.desc ?? "No description"
        authorLabel.text = "@" + repo.author
        watchersLabel.text = "Watchers: \(repo.watchers)"
        starsLabel.text = "Stars: \(repo.stars)"
        forksLabel.text = "Forks: \(repo.forks)"
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let commitViewController = segue.destination as? CommitTableViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }

        commitViewController.user = repo.author
        commitViewController.repo = repo.name
    }

}
