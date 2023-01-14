import Foundation
final class FeedModel {

    private let controlWord = "Password"
    var checkWord: String?

    func check(word: String) {
        if word == controlWord {
            NotificationCenter.default.post(name: Notification.Name("Correct"), object: nil)
        } else {NotificationCenter.default.post(name: Notification.Name("Incorrect"), object: nil)}
    }
}

/*
 {
     "name": "Tatooine",
     "rotation_period": "23",
     "orbital_period": "304",
     "diameter": "10465",
     "climate": "arid",
     "gravity": "1 standard",
     "terrain": "desert",
     "surface_water": "1",
     "population": "200000",
     "residents": [
         "https://swapi.dev/api/people/1/",
         "https://swapi.dev/api/people/2/",
         "https://swapi.dev/api/people/4/",
         "https://swapi.dev/api/people/6/",
         "https://swapi.dev/api/people/7/",
         "https://swapi.dev/api/people/8/",
         "https://swapi.dev/api/people/9/",
         "https://swapi.dev/api/people/11/",
         "https://swapi.dev/api/people/43/",
         "https://swapi.dev/api/people/62/"
     ],
     "films": [
         "https://swapi.dev/api/films/1/",
         "https://swapi.dev/api/films/3/",
         "https://swapi.dev/api/films/4/",
         "https://swapi.dev/api/films/5/",
         "https://swapi.dev/api/films/6/"
     ],
     "created": "2014-12-09T13:50:49.641000Z",
     "edited": "2014-12-20T20:58:18.411000Z",
     "url": "https://swapi.dev/api/planets/1/"
 }
 
 */

struct Citizen: Decodable {
    var name: String
}

struct Planet: Decodable {
    var name: String
    var rotation_period: String
    var orbital_period: String
    var diameter: String
    var climate: String
    var gravity: String
    var terrain: String
    var surface_water: String
    var population: String
    var residents: [String]
    var films: [String]
    var created: String
    var edited: String
    var url: String
}

struct MyUserData: Decodable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}

func getPlanet(completion: ((_ planet: Planet?) -> Void)?) {
    let urlString = "https://swapi.dev/api/planets/1"
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: URL(string: urlString)!) { data, responce, error in
        if let error {
            print(error.localizedDescription)
            completion?(nil)
            return
        }
        
        if (responce as! HTTPURLResponse).statusCode != 200 {
            print("Status code is \((responce as! HTTPURLResponse).statusCode)")
            completion?(nil)
            return
        }
        
        guard let data else {
            print("No data received")
            completion?(nil)
            return
        }
        do {
            let answer = try JSONDecoder().decode(Planet.self, from: data)
            completion?(answer)
            return
        } catch {
            print(error)
        }
        completion?(nil)
        
    }
    task.resume()
}

func getUsers(completion: ((_ dataText: String?) -> Void)?) {
    let urlString = "https://jsonplaceholder.typicode.com/todos/"
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: URL(string: urlString)!) { data, responce, error in
        if let error {
            print(error.localizedDescription)
            completion?(nil)
            return
        }
        
        if (responce as! HTTPURLResponse).statusCode != 200 {
            print("Status code is \((responce as! HTTPURLResponse).statusCode)")
            completion?(nil)
            return
        }
        
        guard let data else {
            print("No data received")
            completion?(nil)
            return
        }
        
        do {
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            let answer: String = (json![json?.randomElement()!["id"] as! Int]["title"] as? String)!
            //print(answer)
            completion?(answer)
            return
        } catch {
            print(error)
        }
        completion?(nil)
    }
    task.resume()
}

func getCitizen(address: String, completion:((_ name: String?) -> Void)?) {
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: URL(string: address)!) { data, responce, error in
        if let error {
            print(error.localizedDescription)
            completion?(nil)
            return
        }
        
        if (responce as! HTTPURLResponse).statusCode != 200 {
            print("Status code is \((responce as! HTTPURLResponse).statusCode)")
            completion?(nil)
            return
        }
        
        guard let data else {
            print("No data received")
            completion?(nil)
            return
        }
        
        do {
            let citizen = try? JSONDecoder().decode(Citizen.self, from: data)
            completion?(citizen?.name)
            return
        } catch {
            print(error)
        }
        completion?(nil)
    }
    task.resume()
    
}
