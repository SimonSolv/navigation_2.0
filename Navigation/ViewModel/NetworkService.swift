import Foundation

struct NetworkService {
    static func request(for address: String) {
        requestSession(address: address)
    }
}



enum AppConfiguration: String, CaseIterable {
    case first = "https://swapi.dev/api/people/8"
    case second = "https://swapi.dev/api/starships/3"
    case third = "https://swapi.dev/api/planets/5"
}

func requestSession(address: String) {
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: URL(string: address)!, completionHandler: { data, responce, error in
        if let error = error {
            print("Connection error:\n")
            print(error.localizedDescription)
            return
        }

        if (responce as! HTTPURLResponse).statusCode != 200 {
            print ("StstusCode = \((responce as! HTTPURLResponse).statusCode)")
            return
        }
        
        guard let data = data else {
            print("No data received")
            return
        }
        
        do {
            let answer = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            guard let myanswer = answer else { print("No Values in dict")
                return
            }
            let printAnswer = myanswer.reversed()
            printAnswer.forEach { print("\($0): \($1)") }
        } catch {
            print (error)
        }
        print ("StstusCode = \((responce as! HTTPURLResponse).statusCode)")
        print ("AllHeaderFields = \((responce as! HTTPURLResponse).allHeaderFields)")
        
    })
    task.resume()
}
