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
    
    func create(a:User, withCompletion completion: @escaping (User?) -> Void){
        let URLstring = path
        var postRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        postRequest.httpMethod = "POST"
        let data = try? JSONEncoder().encode(a)
        postRequest.httpBody = data
        
        if let url = URL.init(string: URLstring){
            let task = URLSession.shared.dataTask(with: url, completionHandler: {
                (data, response, error) in
                if let user = try? JSONDecoder().decode(User.self, from: data!) {
                    completion(user)
                }
            })
            task.resume()
        }
    }
    
    func update(withId id: Int, a: User){
        let URLstring = path + "\(id)"
        var putRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        putRequest.httpMethod = "PUT"
        
        if let url = URL.init(string: URLstring){
            let task = URLSession.shared.dataTask(with: url, completionHandler: {
                (data, response, error) in
                let data = try? JSONEncoder().encode(a)
                putRequest.httpBody = data
                
                if let error = error {
                    print("oh no :(\(error)")
                }
                else {
                    if let data = data, let dataString = String(data: data, encoding: .utf8){
                        print("data:\(dataString)")
                    }
                }
            })
            task.resume()
        }
    }
    
    func delete(withId id: Int){
        let URLstring = path + "\(id)"
        var deleteRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        deleteRequest.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: deleteRequest, completionHandler:{
            (data, response, error) in
            if let error = error {
                print("oh no :(\(error)")
            }
            else {
                if let data = data, let dataString = String(data: data, encoding: .utf8){
                    print("data:\(dataString)")
                }
            }
        })
        
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
userRepo.fetch(withId: 43, withCompletion: {(user) in
        print(user!.FirstName ?? "no user")
})
let testUser = User()
testUser.FirstName = "Bounce"
testUser.LastName = "McDougin"
testUser.PhoneNumber = "6666666669"
testUser.SID = "420696669"


userRepo.create(a: testUser, withCompletion: {(user) in
    print(user!.UserID ?? "no user")
})

//userRepo.update(withId: 43, a: testUser)
//userRepo.delete(withId: 43)
