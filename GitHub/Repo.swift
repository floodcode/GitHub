//
//  Repo.swift
//  GitHub
//
//  Created by Meow on 3/28/19.
//  Copyright © 2019 Meow. All rights reserved.
//

import Foundation

class Repo: NSObject, NSCoding {

    var name: String
    var desc: String?
    var author: String
    var size: Int
    var forks: Int
    var stars: Int
    var watchers: Int

    init(_ dictionary: NSDictionary) {
        let owner = dictionary["owner"] as! NSDictionary

        name = dictionary["name"] as! String
        desc = dictionary["description"] as? String
        author = owner["login"] as! String
        size = dictionary["size"] as! Int
        forks = dictionary["forks_count"] as! Int
        stars = dictionary["stargazers_count"] as! Int
        watchers = dictionary["watchers_count"] as! Int
    }

    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        desc = aDecoder.decodeObject(forKey: "desc") as? String
        author = aDecoder.decodeObject(forKey: "author") as! String
        size = aDecoder.decodeInteger(forKey: "size")
        forks = aDecoder.decodeInteger(forKey: "forks")
        stars = aDecoder.decodeInteger(forKey: "stars")
        watchers = aDecoder.decodeInteger(forKey: "watchers")
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(author, forKey: "author")
        aCoder.encode(forks, forKey: "forks")
        aCoder.encode(stars, forKey: "stars")
        aCoder.encode(watchers, forKey: "watchers")
    }

    class func collection(_ collection: NSArray) -> [Repo] {
        return collection.map {
            Repo($0 as! NSDictionary)
        }
    }

}
