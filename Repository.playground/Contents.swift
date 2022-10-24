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
                
                let str = String(decoding: data!, as: UTF8.self)
                print("Responding to request data: " + str)
                
                if let user = try? JSONDecoder().decode(User.self, from: data!){
                    print("Running completion closure")
                    completion (user)
                }
            })
            task.resume()
        }
    }
    
    //TODO: Build and test comparable methods for the other CRUD items
    func create( a:User , withCompletion completion: @escaping (User?) -> Void) {
        guard a.UserID != nil else {return}
        let URLstring = path + "id/\(a.UserID!)"
        var post = URLRequest.init(url: URL.init(string: URLstring)!)
        
        post.httpMethod = "POST"
        post.httpBody = try? JSONEncoder().encode(a)
        let task = URLSession.shared.dataTask(with: post) {(data, response, error) in
                    print (String.init(data: data!, encoding: .ascii) ?? "no data added")
    }
        task.resume()
    }
    func update( withId id:Int, a:User) {
        guard a.UserID != nil else {return}
        let URLstring = path + "id/\(a.UserID!)"
        var put = URLRequest.init(url: URL.init(string: URLstring)!)
        
        put.httpMethod = "PUT"
        put.httpBody = try? JSONEncoder().encode(a)
        let task = URLSession.shared.dataTask(with: put) {(data, response, error) in
                    print (String.init(data: data!, encoding: .ascii) ?? "no data updated")
    }
        task.resume()
    }
    func delete( withId id:Int ) {
        let URLstring = path + "id/\(id)"
        var delete = URLRequest.init(url:URL.init(string: URLstring)!)
        delete.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: delete) {(data,response,error) in
            print (String.init(data: data!, encoding: .ascii) ?? "no data deleted")
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

//Create a User Repository for the API at https://mikethetall.pythonanywhere.com/users
let userRepo = UserRepository(withPath: "https://mikethetall.pythonanywhere.com/users/")

print("About start fetch")
//Fetch a single User
userRepo.fetch(withId: 1, withCompletion: {(user) in
        print(user!.FirstName ?? "no user")
})

print("Done initiating fetch")

/*
 * TODO: // Refactor the code using Generics and protocols so that you can re-use it as shown below
 *
 //Create a User Repository for the API at https://mikethetall.pythonanywhere.com/users/users/
 let userRepo = Repository<User>(withPath: "https://mikethetall.pythonanywhere.com/users/users/")
 
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
