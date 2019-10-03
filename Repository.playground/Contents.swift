import UIKit

class UserRepository {
    var path: String
    init(withPath path:String){
        self.path = path
    }
    
    // READ a single object
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
    
    //TODO: Build and test comparable methods for the other CRUD items
    func create(Withuser a:User , withCompletion completion: @escaping (User?) -> Void) {
        let URLstring = path
        var CreateRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        CreateRequest.httpMethod = "POST"
        CreateRequest.httpBody = try? JSONEncoder().encode(a)
        
        let task = URLSession.shared.dataTask(with: CreateRequest, completionHandler: { (info, response, error) in
            if let user = try? JSONDecoder().decode(User.self, from: info!){
                completion(user)
            }
            })
            task.resume()
        }



func update( withId id:Int, a:User) {
    
    let URLstring = path + "\(id)"
    var PutRequest = URLRequest.init(url: URL.init(string: URLstring)!)
    PutRequest.httpMethod = "PUT"
    PutRequest.httpBody = try? JSONEncoder().encode(a)
    
    let task = URLSession.shared.dataTask(with: PutRequest) { (info, response, error) in
        print(String.init(data: info!, encoding: .ascii) ?? "oops")
    }
     task.resume()
    }
   


    func delete( withId id:Int ) {
        let URLstring = path + "\(id)"
        
        var DeleteRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        DeleteRequest.httpMethod = "DELETE"
            let task = URLSession.shared.dataTask(with: DeleteRequest) { (info, response, error) in
                print(String.init(data: info!, encoding: .ascii) ?? "oops")
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


let myUser = User()
myUser.FirstName = "robert"
myUser.LastName = "ramirez"
myUser.PhoneNumber = "4257803217"
myUser.SID = "LONG NUMBER"


//Test POST method



userRepo.create(Withuser: myUser, withCompletion:  {(myUser) in
    print(myUser!.UserID ?? "no User")

})

//Fetch a single User
userRepo.fetch(withId: 72, withCompletion: {(user) in
        print(user!.FirstName ?? "no user")
})

myUser.FirstName = "pablo"

userRepo.update(withId: 72, a: myUser)

userRepo.delete(withId: 69)



/**
 * TODO: // Refactor the code using Generics and protocols so that you can re-use it as shown below
 *
 //Create a User Repository for the API at http://216.186.69.45/services/device/users/
 let userRepo = Repository<User>(withPath: "http://216.186.69.45/services/device/users/")
 
 //Fetch a single User
 userRepo.fetch(withId: 43, withCompletion: {(user) in
    print(user!.FirstName ?? "no user")
 })
 
 // Another type of object
 class Match: Codable {
 var name: String?
 var password: String?
 var countTIme: String?
 var seekTime: String?
 var status: String?
 }
 //Create a Match Repository for a different API at http://216.186.69.45/services/hidenseek/matches/
 let matchRepo = Repository<Match>(withPath: "http://216.186.69.45/services/hidenseek/matches/")
 
 //Fetch a single User
 matchRepo.fetch(withId: 1185, withCompletion: {(match) in
    print(match!.status ?? "no match")
 })
*/
