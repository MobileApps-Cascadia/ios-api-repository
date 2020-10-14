import UIKit

class MusicRepository {
    var path: String
    init(withPath path:String){
        self.path = path
    }
    
    // READ a single object------
    func fetch(withId id: Int, withCompletion completion: @escaping (Music?) -> Void) {
        let URLstring = path + "music/id/\(id)"
        if let url = URL.init(string: URLstring){
            let task = URLSession.shared.dataTask(with: url, completionHandler:
            {(data, response, error) in
                if let user = try? JSONDecoder().decode(Music.self, from: data!){
                    completion (user)
                }
            })
            task.resume()
        }
    }
    
    //TODO: Build and test comparable methods for the other CRUD items
    func create(a:Music) {
        guard a.id != nil else {return}
        let URLstring = path + "music/id/\(a.id!)"
        var postRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        
        postRequest.httpMethod = "POST"
        
        postRequest.httpBody = try? JSONEncoder().encode(a)
        
        let task = URLSession.shared.dataTask(with: postRequest) {(data, response, error) in
            print (String.init(data: data!, encoding: .ascii) ?? "no data added")
        }
        task.resume()
    }
    
    func update( withId id:Int, a:Music) {
        guard a.id != nil else {return}
        let URLstring = path + "music/id/\(a.id!)"
        var putRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        
        putRequest.httpMethod = "PUT"
        
        putRequest.httpBody = try? JSONEncoder().encode(a)
        
        let task = URLSession.shared.dataTask(with: putRequest) {(data, response, error) in
            print (String.init(data: data!, encoding: .ascii) ?? "no data updated")
        }
        task.resume()
    }
    
    func delete( withId id:Int ) {
         let URLstring = path + "music/id/\(id)"
         var deleteRequest = URLRequest.init(url: URL.init(string: URLstring)!)
         
         deleteRequest.httpMethod = "DELETE"
         
         let task = URLSession.shared.dataTask(with: deleteRequest) {(data, response, error) in
             print (String.init(data: data!, encoding: .ascii) ?? "no data to delete")
         }
         task.resume()
    }
    
}

class Music: Codable {
    var id: String?
    var music_url: String?
    var name: String?
    var description: String?
}

//Create a User Repository for the API at http://216.186.69.45/services/device/users/
let musicRepo = MusicRepository(withPath: "https://www.orangevalleycaa.org/api/")

//Fetch a single Music
musicRepo.fetch(withId: 10, withCompletion: {(music) in
   print(music!.name ?? "no music")
})

let addMusic = Music()
addMusic.id = "11"
addMusic.music_url = "www.google.com"
addMusic.name = "Test Title"
addMusic.description = "Test Description"

//Post a single Music
musicRepo.create(a: addMusic)


let updateMusic = Music()
updateMusic.id = "1"
updateMusic.music_url = "www.google.com"
updateMusic.name = "Test2 Title"
updateMusic.description = "Test2 Description"

//Updating a single Music
musicRepo.update(withId: 1, a: updateMusic)

//Delete a single Music
musicRepo.delete(withId: 1)

/**
// * TODO: // Refactor the code using Generics and protocols so that you can re-use it as shown below
// *
// //Create a User Repository for the API at http://216.186.69.45/services/device/users/
// let userRepo = Repository<User>(withPath: "http://216.186.69.45/services/device/users/")
//
// //Fetch a single User
// userRepo.fetch(withId: 43, withCompletion: {(user) in
//    print(user!.FirstName ?? "no user")
// })
//
// // Another type of object
// class Match: Codable {
// var name: String?
// var password: String?
// var countTIme: String?
// var seekTime: String?
// var status: String?
// }
// //Create a Match Repository for a different API at http://216.186.69.45/services/hidenseek/matches/
// let matchRepo = Repository<Match>(withPath: "http://216.186.69.45/services/hidenseek/matches/")
//
// //Fetch a single User
// matchRepo.fetch(withId: 1185, withCompletion: {(match) in
//    print(match!.status ?? "no match")
// })
//
 **/
