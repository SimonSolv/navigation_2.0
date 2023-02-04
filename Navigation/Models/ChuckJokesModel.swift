import Foundation

struct Joke: Decodable {
    var text: String
    var id: String
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case text = "value"
        case id
        case url
    }
}
struct Answer: Decodable {
    var total: Int
    var result: [Joke]
}

protocol GetJokesProtocol {
    func getRandomJoke(completion: ((_ joke: Joke?) -> Void)?)
    func getJokeList(searchString string: String, completion: ((_ jokeArray: [Joke]? ) -> Void)?)
}

final class ChuckJokesGetter: GetJokesProtocol {
    func getRandomJoke(completion: ((_ joke: Joke?) -> Void)?) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: URL(string: "https://api.chucknorris.io/jokes/random")!, completionHandler: { data, responce, error in
            if let error = error {
                print(error.localizedDescription)
                completion?(nil)
                return
            }
            
            if (responce as! HTTPURLResponse).statusCode != 200 {
                print ("StstusCode = \((responce as! HTTPURLResponse).statusCode)")
                completion?(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion?(nil)
                return
            }
            
            do {
                let joke = try JSONDecoder().decode(Joke.self, from: data)
                completion?(joke)
                return
            } catch {
                print (error)
            }
            completion?(nil)
        })
        task.resume()
    }

    func getJokeList(searchString string: String, completion: ((_ jokeArray: [Joke]? ) -> Void)?) {
        let urlString = "https://api.chucknorris.io/jokes/search?query=\(string)"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: URL(string: urlString)!, completionHandler: { data, responce, error in
            if let error = error {
                print(error.localizedDescription)
                completion?(nil)
                return
            }
            
            if (responce as! HTTPURLResponse).statusCode != 200 {
                print ("StstusCode = \((responce as! HTTPURLResponse).statusCode)")
                completion?(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion?(nil)
                return
            }
            
            do {
                let answer = try JSONDecoder().decode(Answer.self, from: data)
                completion?(answer.result)
                return
            } catch {
                print(error)
            }
            
            completion?(nil)
        })
        task.resume()
    }
}


