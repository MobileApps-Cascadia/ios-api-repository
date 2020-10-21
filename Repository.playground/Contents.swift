import UIKit

protocol hasID {
    var id: String? { get set }
}

class Repository<Type> where Type: Codable, Type: hasID {
    var path: String
    init(withPath path:String){
        self.path = path
    }
    // READ a single object
    func fetch(withId id: Int, withCompletion completion: @escaping (Type?) -> Void) {
        let URLstring = path + "/id/\(id)"
        if let url = URL.init(string: URLstring){
            let task = URLSession.shared.dataTask(with: url, completionHandler:
            {(data, response, error) in
                if let music = try? JSONDecoder().decode(Type.self, from: data!){
                    completion (music)
                }
            })
            task.resume()
        }
    }
    
    //TODO: Build and test comparable methods for the other CRUD items
    func create(a: Type) {
        guard a.id != nil else { return }
        let URLstring = path + "/id/\(a.id!)"
        
        var reqest = URLRequest.init(url: URL.init(string: URLstring)!)
        
        reqest.httpMethod = "POST"
        reqest.httpBody = try? JSONEncoder().encode(a)
        
        let task = URLSession.shared.dataTask(with: reqest) { data, response, _ in
            if let httpResponse = response as? HTTPURLResponse {
                print("status code: " + String(httpResponse.statusCode))
                print(String.init(data: data!, encoding: .ascii) ?? "no data added")
            } else {
                print("http response error")
            }
        }
        
        task.resume()
    }

    func update(withId: Int, a: Type) {
        guard a.id != nil else { return }
        let URLString = path + "/id/\(a.id!)"
        
        var request = URLRequest.init(url: URL.init(string: URLString)!)
        
        request.httpMethod = "PUT"
        request.httpBody = try? JSONEncoder().encode(a)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("status code: " + String(httpResponse.statusCode))
                print(String.init(data: data!, encoding: .ascii) ?? "no data added")
            } else {
                print("http response error")
            }
        }
        
        task.resume()
    }
    
    func delete(withId id: Int) {
        let urlString = path + "id/\(id)"
        var request = URLRequest.init(url: URL.init(string: urlString)!)
        
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("status code: " + String(httpResponse.statusCode))
                print(String.init(data: data!, encoding: .ascii) ?? "no data added")
            } else {
                print("http response error")
            }
        }
        
        task.resume()
    }
    
}

class Music: Codable, hasID {
    var id: String?
    var name: String?
    var music_url: String?
    var description: String?
}

//Create a User Repository for the API at https://www.orangevalleycaa.org/api/music
let userRepo = Repository<Music>(withPath: "https://www.orangevalleycaa.org/api/music")

//Fetch a single User
userRepo.fetch(withId: 1, withCompletion: {(music) in
    print(music!.name ?? "no user")
})

let m = Music()
m.id = "11"
m.name = "electronic"
m.description = "electronic music"
m.music_url = userRepo.path + "/id/\(m.id!)"

userRepo.create(a: m)

let newMusic = Music()
newMusic.id = "11"
newMusic.name = "Lo-Fi"
newMusic.description = "relaxing background music"
m.music_url = userRepo.path + "/id/\(newMusic.id!)"

userRepo.update(withId: 11, a: newMusic)

userRepo.delete(withId: 11)


// TODO:  Refactor the code using Generics and protocols so that you can re-use it as shown below
// Create a User Repository for the API at http:216.186.69.45/services/device/users/
// let userRepo = Repository<Music>(withPath: "http:216.186.69.45/services/device/users/")
//
// Fetch a single User
// userRepo.fetch(withId: 43, withCompletion: {(user) in
//    print(user!.FirstName ?? "no user")
// })
//
//  Another type of object
// class Match: Codable {
// var name: String?
// var password: String?
// var countTIme: String?
// var seekTime: String?
// var status: String?
// }
// Create a Match Repository for a different API at http:216.186.69.45/services/hidenseek/matches/
// let matchRepo = Repository<Match>(withPath: "http:216.186.69.45/services/hidenseek/matches/")
//
// Fetch a single User
// matchRepo.fetch(withId: 1185, withCompletion: {(match) in
//    print(match!.status ?? "no match")
// })

