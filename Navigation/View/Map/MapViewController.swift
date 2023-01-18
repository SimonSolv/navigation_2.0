//
//  MapViewController.swift
//  Navigation
//
//  Created by Simon Pegg on 05.01.2023.
//

import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController, Coordinated {
    
    //MARK: Properties
    var line: MKPolyline?
    
    var lineView: MKPolylineRenderer?
    
    var coordinator: CoordinatorProtocol?
    
    var currentRegion: MKCoordinateRegion? = nil
    
    var currentLocation: CLLocation? = nil
    
    var pointFrom: CLLocationCoordinate2D?
    
    var pointTo: CLLocationCoordinate2D?
    
    var searchFieldFrom: String?
    
    var searchFieldTo: String?
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    
    // MARK: - Views
    
    private lazy var fromSearchField: UITextField = {
        let view = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.placeholder = "Current location"
        view.backgroundColor = .systemGray6
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.font = .systemFont(ofSize: 18)
        view.textColor = .black
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 65, height: view.frame.height))
        let leftLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: view.frame.height))
        leftLabel.text = "  From:"
        leftLabel.font = .boldSystemFont(ofSize: 18)
        leftLabel.textColor = .black
        leftView.addSubview(leftLabel)
        view.leftView = leftView
        view.leftViewMode = .always
        view.keyboardType = .webSearch
        view.addTarget(self, action: #selector(fromTextChanged), for: .editingChanged)
        return view
    }()
    
    private lazy var toSearchField: UITextField = {
        let view = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.placeholder = "Enter location"
        view.backgroundColor = .systemGray6
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.font = .systemFont(ofSize: 18)
        view.textColor = .black
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: view.frame.height))
        let leftLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 35, height: view.frame.height))
        leftLabel.text = "  To:"
        leftLabel.font = .boldSystemFont(ofSize: 18)
        leftLabel.textColor = .black
        leftView.addSubview(leftLabel)
        view.leftView = leftView
        view.leftViewMode = .always
        view.keyboardType = .webSearch
        view.addTarget(self, action: #selector(toTextChanged), for: .editingChanged)
        return view
    }()
    
    private lazy var searchFieldView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [fromSearchField, toSearchField])
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.axis = .vertical
        return view
    }()

    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.mapType = .hybrid
        view.isRotateEnabled = false
        return view
    }()
    
    private lazy var searchRouteButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Search route", for: .normal)
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
        btn.layer.backgroundColor = UIColor.systemBlue.cgColor
        btn.addTarget(self, action: #selector(getRouteMap), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.showRoadNotifivation(notification:)),
                                               name: Notification.Name("showRoad"),
                                               object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupPositionButton()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }
    
    // MARK: - Setup

    private func setupViews() {
        
        self.title = "Map"
        self.view.backgroundColor = .systemBackground
        view.addSubview(searchRouteButton)
        view.addSubview(mapView)
        view.addSubview(searchFieldView)
        
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        searchFieldView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.height.equalTo(80)
            make.leading.equalTo(view.snp.leading).offset(10)
            make.trailing.equalTo(view.snp.trailing).offset(-10)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        fromSearchField.snp.makeConstraints { (make) in
            make.top.equalTo(searchFieldView.snp.top)
            make.leading.equalTo(searchFieldView.snp.leading)
            make.trailing.equalTo(searchFieldView.snp.trailing)
            make.height.equalTo(40)
        }
        
        toSearchField.snp.makeConstraints { (make) in
            make.top.equalTo(searchFieldView.snp.top).offset(40)
            make.leading.equalTo(searchFieldView.snp.leading)
            make.trailing.equalTo(searchFieldView.snp.trailing)
            make.height.equalTo(40)
        }
        
        searchRouteButton.snp.makeConstraints { (make) in
            make.top.equalTo(toSearchField.snp.bottom).offset(10)
            make.width.equalTo(150)
            make.trailing.equalTo(view.snp.trailing).offset(-10)
            make.height.equalTo(50)
        }
        
    }
    
    private func setupPositionButton() {
        let infoButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(findUserLocation))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    //MARK: - Functions
    
    @objc func showRoadNotifivation(notification: NSNotification) {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        createPath(pickupCoordinate: pointFrom!, destinationCoordinate: pointTo!)
    }
    
    @objc private func findUserLocation() {

        guard self.currentLocation != nil else {
            print("Location not found or error")
            return
        }
        mapView.setCenter(
            self.currentLocation!.coordinate,
            animated: true
        )

        let currentAnnotation = AnnotationForMap(title: "You are here", coordinate: self.currentLocation!.coordinate , info: "This is your current location")
        mapView.addAnnotation(currentAnnotation)
    }
}

//MARK: - LocationManager

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            print("Определение локации невозможно")
        case .notDetermined:
            print("Определение локации не запрошено")
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {

            self.currentRegion = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 10_000,
                longitudinalMeters: 10_000
            )
            self.currentLocation = location
            
            guard self.currentRegion != nil else {
                print("Location not found or error")
                return
            }
     
            mapView.setRegion(
                self.currentRegion!,
                animated: true
            )
            let currentAnnotation = AnnotationForMap(title: "You are here", coordinate: self.currentLocation!.coordinate , info: "This is your current location")
            mapView.addAnnotation(currentAnnotation)
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Failed to get location premission")
    }
}

//MARK: -Map Functions

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendere = MKPolylineRenderer(overlay: overlay)
        rendere.lineWidth = 5
        rendere.strokeColor = .systemBlue
        return rendere
    }
    
    
    /// Function to create line and two dots between first point and second point
    /// - Parameters:
    ///   - pickupCoordinate: start point on the map route
    ///   - destinationCoordinate: finish point on the map
    func createPath(pickupCoordinate : CLLocationCoordinate2D, destinationCoordinate : CLLocationCoordinate2D) {
        let sourcePlaceMark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
     
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
        
        let sourceAnotation = MKPointAnnotation()
        sourceAnotation.title = "\(self.searchFieldFrom ?? "Start")"
        sourceAnotation.subtitle = "Start route"
        if let location = sourcePlaceMark.location {
            sourceAnotation.coordinate = location.coordinate
        }
        
        let destinationAnotation = MKPointAnnotation()
        destinationAnotation.title = "\(self.searchFieldTo ?? "Finish")"
        destinationAnotation.subtitle = "Finish route"
        if let location = destinationPlaceMark.location {
            destinationAnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnotation, destinationAnotation], animated: true)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .automobile
        
        let direction = MKDirections(request: directionRequest)
        
        direction.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("ERROR FOUND : \(error.localizedDescription)")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            
            self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets.init(top: 120.0, left: 30.0, bottom: 100.0, right: 30.0), animated: true)
        }
    }
    
    //Currently doesn't work:
    /// Function to create line and two dots between first point and second point
    /// - Parameters:
    ///   - pickupCoordinate: start point on the map route
    ///   - destinationCoordinate: finish point on the map
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
            request.requestsAlternateRoutes = true
            request.transportType = .automobile

            let directions = MKDirections(request: request)

            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                //for getting just one route
                if let route = unwrappedResponse.routes.first {
                    //show on map
                    self.mapView.addOverlay(route.polyline)
                    //set the map area to show the route
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
                }

                //if you want to show multiple routes then you can get all routes in a loop in the following statement
                //for route in unwrappedResponse.routes {}
            }
        }
    
}

//MARK: -Ligic for UI

extension MapViewController {
    
    @objc private func fromTextChanged(_ textField: UITextField) {
        searchFieldFrom = textField.text
    }

    @objc private func toTextChanged(_ textField: UITextField) {
        searchFieldTo = textField.text
        if textField.text != nil && textField.text != "" {
            addSearcRouteButton()
        } else {
            removeSearchRouteButton()
        }
    }
    
    private func addSearcRouteButton() {
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(self.searchRouteButton)
        }
    }
    
    private func removeSearchRouteButton() {
        DispatchQueue.main.async {
            self.view.sendSubviewToBack(self.searchRouteButton)
        }
    }
    
    @objc private func getRouteMap() {
        self.pointFrom = nil
        self.pointTo = nil
        getRouteCoordinates()
    }
    
    private func getRouteCoordinates() {
        
        if searchFieldFrom == nil || searchFieldFrom == "" {
            if currentLocation != nil {
                DispatchQueue.main.async {
                    self.pointFrom = self.currentLocation!.coordinate
                }
                if pointTo != nil && pointFrom != nil {
                    print("Posting notification From")
                    print("From \(self.pointFrom) to \(self.pointTo)")
                    NotificationCenter.default.post(name: Notification.Name("showRoad"), object: nil)
                }
            }
        } else {
            getLocationCoordinates(searchFieldFrom!) { region in
                guard let region = region else {
                    print("Haven't got location region")
                    return
                }

                DispatchQueue.main.async {
                    self.pointFrom = region.center
                    if self.pointTo != nil && self.pointFrom != nil {
                        print("Posting notification FROM")
                        print("From \(self.pointFrom) to \(self.pointTo)")
                        NotificationCenter.default.post(name: Notification.Name("showRoad"), object: nil)
                    }
                }
            }
        }
            
        if searchFieldTo == nil || searchFieldTo == "" {
            DispatchQueue.main.async {
                self.present(CustomWarnAlert(message: "Set destination point!", actionHandler: nil), animated: true)
            }
        } else {
            getLocationCoordinates(searchFieldTo!) { region in
                guard let region = region else {
                    print("Haven't got location region")
                    return
                }

                DispatchQueue.main.async {
                    self.pointTo = region.center
                    if self.pointTo != nil && self.pointFrom != nil {
                        print("Posting notification TO")
                        print("From \(self.pointFrom) to \(self.pointTo)")
                        NotificationCenter.default.post(name: Notification.Name("showRoad"), object: nil)
                    }
                }
            }
        }
    }
    
    private func showRoute() {
    
        if pointFrom != nil {
            if pointTo != nil {
                DispatchQueue.main.async {
                    
                    let fromAnnotation = AnnotationForMap(title: self.fromSearchField.text ?? "You are here", coordinate: self.pointFrom! , info: "Begin route")
                    let toAnnotation = AnnotationForMap(title: self.toSearchField.text ?? "Finish route", coordinate: self.pointTo! , info: "End route")
                    self.mapView.addAnnotation(fromAnnotation)
                    self.mapView.addAnnotation(toAnnotation)
//                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
                }
                showRouteOnMap(pickupCoordinate: pointFrom!, destinationCoordinate: pointTo!)
            } else {
                print("PointTo is nil")
            }
        } else {
            print("PointFrom is nil")
        }

    }
    
}


