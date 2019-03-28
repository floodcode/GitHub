//
//  Globals.swift
//  GitHub
//
//  Created by Meow on 3/28/19.
//  Copyright © 2019 Meow. All rights reserved.
//

import Foundation

class Global {

    public var github: GitHubService!
    public var repos = [Repo]()
    public var commits = [String: [Commit]]()

    class var shared: Global {
        struct Static {
            static let instance = Global()
        }
        return Static.instance
    }
}
