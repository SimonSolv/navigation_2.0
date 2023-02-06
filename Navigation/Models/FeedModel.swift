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
