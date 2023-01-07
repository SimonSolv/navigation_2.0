//
//  MapModel.swift
//  Navigation
//
//  Created by Simon Pegg on 06.01.2023.
//

import Foundation
import MapKit

struct Address: Codable {
    let data: [DataItem]
}

struct DataItem: Codable {
    let latitude, longitude : Double
    let name: String?
}

struct LocationPin: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

class MapApi: ObservableObject {
    private let basicURLString = "http://api.positionstack.com/v1/forward"
    private let api1 = "1664b98cc47557453d679"
    private let api2 = "c72df429d27"
    
    @Published var region: MKCoordinateRegion
    @Published var coordinates = []
    @Published var locationPins: [LocationPin] = []
    
    init (region: MKCoordinateRegion) {
        self.region = region
        self.locationPins.insert(LocationPin(name: "Pin", coordinate: region.center), at: 0)
    }
    
    func getLocation(address: String, delta: Double, completion: (_ coordinate: MKCoordinateRegion?) -> (Void)?) {
        let pAaddress = address.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(basicURLString)?access_key=\(api1)\(api2)&query=\(pAaddress)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print(error?.localizedDescription)
                return
            }
            
            guard let newCoordinates = try? JSONDecoder().decode(Address.self, from: data) else { return }
            
            if newCoordinates.data.isEmpty {
                print("Counldn't find address")
                return
            }
            
            DispatchQueue.main.async {
                let details = newCoordinates.data[0]
                let lat = details.latitude
                let lon = details.longitude
                let name = details.name
                
                self.coordinates = [lat, lon]
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
                let new_locationPin = LocationPin(name: name ?? "Pin", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                
                self.locationPins.removeAll()
                self.locationPins.insert(new_locationPin, at: 0)
            }
            
        }
        .resume()
        completion(self.region)
    }
}

func getLocationCoordinates(_ address: String, completion: ((_ region: MKCoordinateRegion? ) -> Void)?) {
    let basicURLString = "http://api.positionstack.com/v1/forward"
    let api1 = "1664b98cc47557453d679"
    let api2 = "c72df429d27"
    let pAaddress = address.replacingOccurrences(of: " ", with: "%20")
    let urlString = "\(basicURLString)?access_key=\(api1)\(api2)&query=\(pAaddress)"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion?(nil)
        return
    }
    
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url, completionHandler: { data, responce, error in
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
            let answer = try JSONDecoder().decode(Address.self, from: data)
            let details = answer.data[0]
            let lat = details.latitude
            let lon = details.longitude
            
            let result = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), latitudinalMeters: 1000, longitudinalMeters: 1000)
            completion?(result)
            return
        } catch {
            print(error)
        }
        
        completion?(nil)
    })
    task.resume()
}
