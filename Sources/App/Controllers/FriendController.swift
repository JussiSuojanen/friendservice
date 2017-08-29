//
//  FriendController.swift
//  FriendService
//
//  Created by Jussi Suojanen on 20/11/16.
//
//

import Vapor
import HTTP
import MySQLProvider

class FriendController: ResourceRepresentable {

    func index(request: Request) throws -> ResponseRepresentable {
        return try Friend.all().makeJSON()
    }

    func create(request: Request) throws -> ResponseRepresentable {
        let friend = try request.friend()
        try friend.save()
        return friend
    }

    func delete(request: Request, friend: Friend) throws -> ResponseRepresentable {
        try friend.delete()
        return Response(status: .ok)
    }

    func update(request: Request, friend: Friend) throws -> ResponseRepresentable {
        let friend = friend
        try friend.update(for: request)

        try friend.save()
        return friend
    }

    func makeResource() -> Resource<Friend> {
        return Resource(index: index,
                        store: create,
                        update: update,
                        destroy: delete)
    }

}

// Request extension so Friend can be created from JSON
extension Request {
    func friend() throws -> Friend {
        guard let json = json else {
            throw Abort.badRequest
        }

        return try Friend(json: json)
    }
}
