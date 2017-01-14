//
//  FriendController.swift
//  FriendService
//
//  Created by Jussi Suojanen on 20/11/16.
//
//

import Vapor
import HTTP
import VaporMySQL

class FriendController: ResourceRepresentable {

    func index(request: Request) throws -> ResponseRepresentable {
        return try Friend.all().makeNode().converted(to: JSON.self)
    }

    func create(request: Request) throws -> ResponseRepresentable {
        var friend = try request.friend()
        try friend.save()
        return friend
    }

    func delete(request: Request, friend: Friend) throws -> ResponseRepresentable {
        try friend.delete()
        return JSON([:])
    }

    func update(request: Request, friend: Friend) throws -> ResponseRepresentable {
        let newInfo = try request.friend()
        var friend = friend
        friend.firstname = newInfo.firstname
        friend.lastname = newInfo.lastname
        friend.phonenumber = newInfo.phonenumber
        try friend.save()
        return friend
    }

    func makeResource() -> Resource<Friend> {
        return Resource(index: index,
                        store: create,
                        modify: update,
                        destroy: delete)
    }

}

// Request extension so Friend can be created from JSON
extension Request {
    func friend() throws -> Friend {
        guard let json = json else {
            throw Abort.badRequest
        }
        return try Friend(node: json)
    }
}
