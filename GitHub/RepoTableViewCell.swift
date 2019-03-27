//
//  RepoTableViewCell.swift
//  GitHub
//
//  Created by Meow on 3/27/19.
//  Copyright © 2019 Meow. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet weak var repoNameLabel: UILabel!

    // MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
