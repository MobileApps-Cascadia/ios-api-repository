import UIKit

class MusicRepository {
    var path: String
    init(withPath path:String){
        self.path = path
    }
    // READ a single object
    func fetch(withId id: Int, withCompletion completion: @escaping (Music?) -> Void) {
        let URLstring = path + "/id/\(id)"
        if let url = URL.init(string: URLstring){
            let task = URLSession.shared.dataTask(with: url, completionHandler:
            {(data, response, error) in
                if let music = try? JSONDecoder().decode(Music.self, from: data!){
                    completion (music)
                }
            })
            task.resume()
        }
    }
    
    //TODO: Build and test comparable methods for the other CRUD items
    func create( a:Music) {
        guard a.id != nil else {return};
        let urlString = path + "/id/\(a.id!)"
        var postRequest = URLRequest.init(url: URL.init(string: urlString)!)
        postRequest.httpMethod = "POST"
        postRequest.httpBody = try? JSONEncoder().encode(a.self)
        let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            print (String.init(data: data!, encoding: .ascii) ?? "no data")
        }
        task.resume()
    }
    func update( withId id:Int, a:Music) {
        guard a.id != nil else {return};
        let urlString = path + "/id/\(a.id!)"
        var updateRequest = URLRequest.init(url: URL.init(string: urlString)!)
        updateRequest.httpMethod = "PUT"
        updateRequest.httpBody = try? JSONEncoder().encode(a.self)
        let task = URLSession.shared.dataTask(with: updateRequest) { (data, response, error) in
            print (String.init(data: data!, encoding: .ascii) ?? "no data")

        }
        task.resume()

    }
    func delete( withId id:Int ) {
        let urlString = path + "/id/\(id)"
        var deleteRequest = URLRequest.init(url: URL.init(string: urlString)!)
        deleteRequest.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: deleteRequest) { (data, response, error) in
            print (String.init(data: data!, encoding: .ascii) ?? "no data")

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
//Create a User Repository for the API at https://www.orangevalleycaa.org/api/music
let musicRepo = MusicRepository(withPath: "https://www.orangevalleycaa.org/api/music")

//Fetch a single User
    musicRepo.fetch(withId: 1, withCompletion: {(music) in
        print(music!.name ?? "no music")
})

let newMusic = Music()
newMusic.id = "8"
newMusic.name = "Electro Swing"
newMusic.description = "Electro Swing music"
newMusic.music_url = musicRepo.path + "/id/\(newMusic.id!)"

musicRepo.create(a: newMusic)
musicRepo.update(withId: 3, a: newMusic)
musicRepo.delete(withId: 1)
