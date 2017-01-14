import Vapor
import VaporMySQL
import HTTP

let droplet = Droplet(preparations: [Friend.self], providers: [VaporMySQL.Provider.self])

let friendsController = FriendController()

droplet.resource("listFriends", friendsController)
droplet.resource("addFriend", friendsController)
droplet.resource("editFriend", friendsController)
droplet.run()
