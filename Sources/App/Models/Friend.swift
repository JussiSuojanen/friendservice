//
//  Friend.swift
//  FriendService
//
//  Created by Jussi Suojanen on 20/11/16.
//
//

import Vapor
import FluentProvider
import Foundation
import HTTP
import Validation

final class Friend: Model {
    let storage = Storage()

    /// The column names in the database
    static let firstnameKey = "firstname"
    static let lastnameKey = "lastname"
    static let phonenumberKey = "phonenumber"

    var firstname: String
    var lastname: String
    var phonenumber: String

    /// Convenience init
    init(firstname: String, lastname: String, phonenumber: String) throws {
        // validate
        try OnlyScandicAlpha().validate(firstname)
        try OnlyScandicAlpha().validate(lastname)
        try PhonenumberValidator().validate(phonenumber)

        let nameLengthValidator = Count<String>.containedIn(low: 2, high: 40)
        try nameLengthValidator.validate(firstname)
        try nameLengthValidator.validate(lastname)

        self.firstname = firstname
        self.lastname = lastname
        self.phonenumber = phonenumber
    }

    /// Initializes the Friend from the
    /// database row
    init(row: Row) throws {
        firstname = try row.get(Friend.firstnameKey)
        lastname = try row.get(Friend.lastnameKey)
        phonenumber = try row.get(Friend.phonenumberKey)
    }

    // Serializes the Friend to the databasel
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Friend.firstnameKey, firstname)
        try row.set(Friend.lastnameKey, lastname)
        try row.set(Friend.phonenumberKey, phonenumber)
        return row
    }

}

// MARK: Fluent Preparation

extension Friend: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Friends
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Friend.firstnameKey)
            builder.string(Friend.lastnameKey)
            builder.string(Friend.phonenumberKey)
        }
    }

    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON

// How the model converts from / to JSON.
// For example when:
//     - Creating a new Friend (POST /addFriend)
//     - Fetching a friend (GET /listFriends, GET /friends/:id)
//
extension Friend: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            firstname: json.get(Friend.firstnameKey),
            lastname: json.get(Friend.lastnameKey),
            phonenumber: json.get(Friend.phonenumberKey)
        )
    }

    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Friend.idKey, id)
        try json.set(Friend.firstnameKey, firstname)
        try json.set(Friend.lastnameKey, lastname)
        try json.set(Friend.phonenumberKey, phonenumber)
        return json
    }
}

// MARK: HTTP

// This allows Friend models to be returned
// directly in route closures
extension Friend: ResponseRepresentable { }

// MARK: Update

// This allows the Friend model to be updated
// dynamically by the request.
extension Friend: Updateable {
    // Updateable keys are called when `friend.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<Friend>] {
        return [
            // If the request contains a String at key "firstname", "lastname" and "phonenumber"
            // the setter callback will be called.
            UpdateableKey(Friend.firstnameKey, String.self) { friend, firstname in
                friend.firstname = firstname
            },
            UpdateableKey(Friend.lastnameKey, String.self) { friend, lastname in
                friend.lastname = lastname
            },
            UpdateableKey(Friend.phonenumberKey, String.self) { friend, phonenumber in
                friend.phonenumber = phonenumber
            }
        ]
    }
}
