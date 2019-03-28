//
//  Commit.swift
//  GitHub
//
//  Created by Meow on 3/28/19.
//  Copyright © 2019 Meow. All rights reserved.
//

import Foundation

struct Commit {

    var message: String
    var hash: String
    var author: String
    var date: String

    init(_ dictionary: NSDictionary) {
        let commit = dictionary["commit"] as! NSDictionary
        let commitAuthor = commit["author"] as! NSDictionary

        message = commit["message"] as! String
        hash = dictionary["sha"] as! String
        author = commitAuthor["name"] as? String ?? ""
        date = commitAuthor["date"] as? String ?? ""
    }

    static func collection(_ collection: NSArray) -> [Commit] {
        return collection.map {
            Commit($0 as! NSDictionary)
        }
    }

}
