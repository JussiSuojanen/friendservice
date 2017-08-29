import Vapor
import MySQLProvider
import HTTP

let config = try Config()
try config.addProvider(MySQLProvider.Provider.self)
config.preparations.append(Friend.self)
let droplet = try Droplet(config)

let friendsController = FriendController()

droplet.resource("listFriends", friendsController)
droplet.resource("addFriend", friendsController)
droplet.resource("editFriend", friendsController)
try droplet.run()
