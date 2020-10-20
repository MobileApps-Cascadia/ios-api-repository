import UIKit

protocol hasID {
    var id: Int?{get set}
}

class MusicRepository <genericObject> where genericObject : Codable, genericObject: hasID {
    var path: String
    init(withPath path:String){
        self.path = path
    }
    
    
    // READ a single object------
    func fetch(withId id: Int, withCompletion completion: @escaping (genericObject?) -> Void) {
        let URLstring = path + "id/\(id)"
        if let url = URL.init(string: URLstring){
            let task = URLSession.shared.dataTask(with: url, completionHandler:
            {(data, response, error) in
                if let music = try? JSONDecoder().decode(genericObject.self, from: data!){
                    completion (music)
                }
            })
            task.resume()
            
        }
    }
    
    //TODO: Build and test comparable methods for the other CRUD items
    func create(a:genericObject) {
        guard a.id != nil else {return}
        let URLstring = path + "id/\(a.id!)"
        var postRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        
        postRequest.httpMethod = "POST"
        
        postRequest.httpBody = try? JSONEncoder().encode(a)
        
        let task = URLSession.shared.dataTask(with: postRequest) {(data, response, error) in
            print (String.init(data: data!, encoding: .ascii) ?? "no data added")
        }
        task.resume()
    }
    
    func update( withId id:Int, a:genericObject) {
        guard a.id != nil else {return}
        let URLstring = path + "id/\(a.id!)"
        var putRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        
        putRequest.httpMethod = "PUT"
        
        putRequest.httpBody = try? JSONEncoder().encode(a)
        
        let task = URLSession.shared.dataTask(with: putRequest) {(data, response, error) in
            print (String.init(data: data!, encoding: .ascii) ?? "no data updated")
        }
        task.resume()
    }
    
    func delete( withId id:Int ) {
         let URLstring = path + "id/\(id)"
         var deleteRequest = URLRequest.init(url: URL.init(string: URLstring)!)
         
         deleteRequest.httpMethod = "DELETE"
         
         let task = URLSession.shared.dataTask(with: deleteRequest) {(data, response, error) in
             print (String.init(data: data!, encoding: .ascii) ?? "no data to delete")
         }
         task.resume()
    }
    
}

class Music: Codable, hasID{
    var id: Int?
    var music_url: String?
    var name: String?
    var description: String?
}

//Create a User Repository for the API at http://216.186.69.45/services/device/users/
let musicRepo = MusicRepository<Music>(withPath: "https://www.orangevalleycaa.org/api/music/")

//Fetch a single Music
musicRepo.fetch(withId: 10, withCompletion: {(music)
    in print(music!.name ?? "no music")
})

let addMusic = Music()
addMusic.id = 11
addMusic.music_url = "www.google.com"
addMusic.name = "Test Title"
addMusic.description = "Test Description"

//Post a single Music
musicRepo.create(a: addMusic)


let updateMusic = Music()
updateMusic.id = 1
updateMusic.music_url = "www.google.com"
updateMusic.name = "Test2 Title"
updateMusic.description = "Test2 Description"

//Updating a single Music
musicRepo.update(withId: 1, a: updateMusic)

//Delete a single Music
musicRepo.delete(withId: 1)
