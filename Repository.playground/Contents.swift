import UIKit

class MusicRepository {
    var path: String
    init(withPath path:String){
        self.path = path
    }
    // READ a single object
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
            print(String.init(data: data!, encoding: .ascii) ?? "no data to add")
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
            print(String.init(data: data!, encoding: .ascii) ?? "no data to update")
        }
        task.resume()
        }
        
    func delete( withId id:Int ) {
        let URLstring = path + "music/id/\(id)"
        var deleteRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        
        deleteRequest.httpMethod = "DELETE"
                        
        let task = URLSession.shared.dataTask(with: deleteRequest) {(data, response, error) in
            print(String.init(data: data!, encoding: .ascii) ?? "no data to delete")
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

//Create a Music Repository for the API at https://www.orangevalleycaa.org/api/
let musicRepo = MusicRepository(withPath: "https://www.orangevalleycaa.org/api/")

//Fetch a single User
musicRepo.fetch(withId: 2, withCompletion: {(music) in
        print(music!.name ?? "no music")
})


//TODO: // Refactor the code using Generics and protocols so that you can re-use it as shown below

//Create a User Repository for the API at https://www.orangevalleycaa.org/api/
 let newMusic = Music()
newMusic.id = "43"
newMusic.name = "The Meaning Of Life"
newMusic.description = "Hitchhikers Guide To The Galaxy vol. 1"
newMusic.music_url = musicRepo.path + "/id/\(newMusic.id!)"

musicRepo.create(a: newMusic)
musicRepo.update(withId: 4, a: newMusic)
musicRepo.delete(withId: 2)
