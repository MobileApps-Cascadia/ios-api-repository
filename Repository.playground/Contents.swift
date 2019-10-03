import UIKit

class UserRepository {
    var path: String
    init(withPath path:String){
        self.path = path
    }
    
    func fetch(withId id: Int, withCompletion completion: @escaping (User?) -> Void) {
        let URLstring = path + "\(id)"
        if let url = URL.init(string: URLstring){
            let task = URLSession.shared.dataTask(with: url, completionHandler:
            {(data, response, error) in
                if let user = try? JSONDecoder().decode(User.self, from: data!){
                    completion (user)
                }
            })
            task.resume()
        }
    }
    
    func create(withUser user: User, withCompletion completion: @escaping (User?) -> Void) {
        let URLString = path
        var postRequest = URLRequest.init(url: URL.init(string: URLString)!)
        postRequest.httpMethod = "POST"
        postRequest.httpBody = try? JSONEncoder().encode(user)
        
        let task = URLSession.shared.dataTask(with: postRequest, completionHandler: {
            (data, response, error) in
            if let user = try? JSONDecoder().decode(User.self, from: data!) {
                completion (user)
            }
        })
        task.resume()
    }
    
    func update(withId id:Int, withUser user:User) {
        let URLString = path + "\(id)"
        var updateRequest = URLRequest.init(url: URL.init(string: URLString)!)
        updateRequest.httpMethod = "PUT"
        updateRequest.httpBody = try? JSONEncoder().encode(user)
        
        let task = URLSession.shared.dataTask(with: updateRequest) {
            (data, response, error) in
            print(String.init(data: data!, encoding: .ascii) ?? "Error: \(error!)")
        }
        task.resume()
    }
    
    func delete(withId id:Int) {
        let URLString = path + "\(id)"
        var deleteRequest = URLRequest.init(url: URL.init(string: URLString)!)
        deleteRequest.httpMethod = "DELETE"

        let task = URLSession.shared.dataTask(with: deleteRequest){
            (data, response, error) in
            print("Delete Successful")
        }
        task.resume()
    }
}

class User: Codable {
    var UserID: String?
    var FirstName: String?
    var LastName: String?
    var PhoneNumber: String?
    var SID: String?
}

//Create a User Repository for the API at http://216.186.69.45/services/device/users/
let userRepo = UserRepository(withPath: "http://216.186.69.45/services/device/users/")

//Fetch a single User
userRepo.fetch(withId: 58, withCompletion: {(user) in
        print(user!.FirstName ?? "no user")
})

// Create (post) new user
var mUser = User()
mUser.FirstName = "jim"
mUser.LastName = "beam"
userRepo.create(withUser: mUser, withCompletion: {(user) in
    print("new user: \(user!.FirstName ?? "no user") \(user!.LastName ?? "no user")")
})

// Update (put) user
var nUser = User()
nUser.FirstName = "the"
nUser.LastName = "glenlivet"
userRepo.update(withId: 58, withUser: nUser)

// Delete user
userRepo.delete(withId: 11)
