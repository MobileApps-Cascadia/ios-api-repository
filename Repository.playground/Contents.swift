import UIKit

protocol APIRepository {
    associatedtype Element
    func fetch(withId id: Int, withCompletion completion: @escaping (Element?) -> Void)
    func create( a:User , withCompletion completion: @escaping (String) -> Void)
    func update( withId id:Int, a:User)
    func delete( withId id:Int )
}

class UserRepository<Element: Codable>: APIRepository {
    var path: String
    init(withPath path:String){
        self.path = path
    }
    // READ a single object
    func fetch(withId id: Int, withCompletion completion: @escaping (Element?) -> Void) {
        let URLstring = path + "/\(id)"
        if let url = URL.init(string: URLstring){
            let task = URLSession.shared.dataTask(with: url, completionHandler:
            {(data, response, error) in
                
                let str = String(decoding: data!, as: UTF8.self)
                print("Responding to request data: " + str)
                
                if let user = try? JSONDecoder().decode(Element.self, from: data!){
                    print("Running completion closure")
                    completion (user)
                }
            })
            task.resume()
        }
    }
    
    //TODO: Build and test comparable methods for the other CRUD items
    func create( a:User , withCompletion completion: @escaping (String) -> Void) {
        let URLstring = path
        var postRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        postRequest.httpMethod = "POST"
        
        //TODO: Encode the user object itself as JSON and assign to the body
        postRequest.httpBody = try? JSONEncoder().encode(a)
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //TODO: Create the URLSession task to invoke the request
        let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            if error == nil, let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 204:
                        let result = String.init(data:data!, encoding: .utf8) ?? "no data"
                        completion (result)
                        break
                    //...
                    default:
                        break
                    }
                } else {
                    //error case here...
                }
        }
        task.resume()
    }
    
    func update( withId id:Int, a:User) {
        let URLstring = path + "/\(String(id))"
        var updateRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        updateRequest.httpMethod = "PUT"
        updateRequest.httpBody = try? JSONEncoder().encode(a)
        updateRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: updateRequest) { (data, response, error) in
            print(String.init(data: data!, encoding: .ascii) ?? "no data")
        }
        task.resume()
    }
    
    func delete( withId id:Int ) {
        let URLstring = path + "?id\(String(id))"
        var deleteRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        deleteRequest.httpMethod = "DELETE"
        deleteRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: deleteRequest) { (data, response, error) in
            print(String.init(data: data!, encoding: .ascii) ?? "no data")
        }
        task.resume()
    }
    
}

class User: Codable {
    var UserID: Int?
    var FirstName: String?
    var LastName: String?
    var PhoneNumber: String?
    var SID: String?
}

let newUser = User()
newUser.FirstName = "Indianachanged"
newUser.LastName = "Joneschanged"
newUser.PhoneNumber = "000-0000-4500"
newUser.SID = "23622"

//Create a User Repository for the API at https://mikethetall.pythonanywhere.com/users
let userRepo = UserRepository<User>(withPath: "https://mikethetall.pythonanywhere.com/users")

print("About start fetch")

//Fetch a single User
userRepo.fetch(withId: 1, withCompletion: {(user) in
    print(user!.FirstName ?? "no user") })

//userRepo.create(a: newUser) { (msg) in
//    print("added user \(msg)")
//}

//userRepo.update(withId: 4, a: newUser)

//userRepo.delete(withId: 6)

print("Done initiating fetch")

/*
 * TODO: // Refactor the code using Generics and protocols so that you can re-use it as shown below
 *
 //Create a User Repository for the API at https://mikethetall.pythonanywhere.com/users/users
 let userRepo = Repository<User>(withPath: "https://mikethetall.pythonanywhere.com/users/users")
 
 //Fetch a single User
 userRepo.fetch(withId: 2, withCompletion: {(user) in
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
