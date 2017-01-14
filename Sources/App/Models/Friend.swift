//
//  Friend.swift
//  FriendService
//
//  Created by Jussi Suojanen on 20/11/16.
//
//

import Vapor
import Fluent
import Foundation
import HTTP

final class Friend: Model {
    var id: Node?
    var exists: Bool = false
    var firstname: String
    var lastname: String
    var phonenumber: String

    /// Convenience init
    init(firstname: String, lastname: String, phonenumber: String) {
        self.id = nil
        self.firstname = firstname
        self.lastname = lastname
        self.phonenumber = phonenumber
    }

    /// Fluent pulls our data as intermediate datamodel from the database
    /// and we need to convert it back to typesafe model
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        firstname = try node.extract("firstname")
        lastname = try node.extract("lastname")
        phonenumber = try node.extract("phonenumber")
    }

    /// makeNode - JSONRepresentable
    /// class can be converted to alternative representables
    /// such as JSON and values that can be stored to database
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "firstname": firstname,
            "lastname": lastname,
            "phonenumber": phonenumber
            ])
    }

    /// Prepare the database. Creates the database when used for the first time.
    static func prepare(_ database: Database) throws {
        try database.create("friends") { friends in
            friends.id()
            friends.string("firstname")
            friends.string("lastname")
            friends.string("phonenumber")
        }
    }

    /// Reverts the database (DROP TABLE)
    static func revert(_ database: Database) throws {
        try database.delete("friends")
    }

}

