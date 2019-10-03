import UIKit

class UserRepository: Codable {
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
    
    
    func create( a:User , withCompletion completion: @escaping (User?) -> Void) {
               let URLstring = path
               var postRequest = URLRequest.init(url: URL.init(string: URLstring)!)
               postRequest.httpMethod = "POST"
               
               //TODO: Encode the user object itself as JSON and assign to the body
           postRequest.httpBody = try? JSONEncoder().encode(a)
               
               
               
               //TODO: Create the URLSession task to invoke the request
               let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
                //need to decode the information that we got back
                let decode = try? JSONDecoder().decode(User.self, from: data!)
                //call the completionHandler and pass in the newly decoded object
                completion(decode)
                
               }
               task.resume()
        
    }
    
    func update( withId id:Int, a:User) {
        let URLstring = path + "\(id)"
                     var postRequest = URLRequest.init(url: URL.init(string: URLstring)!)
                     postRequest.httpMethod = "PUT"
                     
                     //TODO: Encode the user object itself as JSON and assign to the body
                 postRequest.httpBody = try? JSONEncoder().encode(a)
                     
                     
                     //TODO: Create the URLSession task to invoke the request
                     let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
                         print(String.init(data: data!, encoding: .ascii) ?? "Error")

                      
                     }
                     task.resume()
    }
    
    func delete( withId id:Int ) {
        let URLstring = path + "\(id)"
                            var postRequest = URLRequest.init(url: URL.init(string: URLstring)!)
                            postRequest.httpMethod = "DELETE"
           
                            //TODO: Create the URLSession task to invoke the request
                            let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
                                print(String.init(data: data!, encoding: .ascii) ?? "Error")

                             
                            }
                            task.resume()
    }
}
//TODO: Build and test comparable methods for the other CRUD items
   //func create( a:User , withCompletion completion: @escaping (User?) -> Void) {}
   //func update( withId id:Int, a:User) {}
   //func delete( withId id:Int ) {}
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
userRepo.fetch(withId: 43, withCompletion: {(user) in
        print(user!.FirstName ?? "no user")
})


       let myUser = User()
       myUser.FirstName = "Juanita"
       myUser.LastName = "A"
       myUser.PhoneNumber = "99988989"
let newUser = User()
newUser.FirstName = "J"
newUser.LastName = "L"
newUser.PhoneNumber = "99988988"
       
userRepo.create(a: myUser, withCompletion: { (user) in
    print(user!.UserID ?? "no user" )
    
})

userRepo.update(withId: 43, a: myUser)
userRepo.delete(withId: 43)
userRepo.create(a: newUser, withCompletion: { (user) in
    print(user!.LastName ?? "no user" )
    
})
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


