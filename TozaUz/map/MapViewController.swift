//
//  MapViewController.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 06/07/24.
//

import UIKit
import MapboxMaps
import CoreLocation
import Alamofire

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var mapView: MapView!
    var locationManager: CLLocationManager!
    var userLocation: CLLocationCoordinate2D?

    @objc func handleNotification(_ notification: Notification) {
        addMarkers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: .myNotification, object: nil)


        // Set up the map view
        mapView = MapView(frame: view.bounds)
        
        mapView.backgroundColor = .systemBackground
        title = "map".translate()
        print("xxxx", UD.mode ?? "")
        let viewMode = UD.mode ?? ""
        if viewMode == "light" {
            mapView.mapboxMap.styleURI = .standard
        } else if viewMode == "dark" {
            mapView.mapboxMap.styleURI = .dark
        } else if viewMode == "system" {
            let mode = Functions.getDeviceMode()
            if mode == .light {
                mapView.mapboxMap.styleURI = .standard
            } else if mode == .dark {
                mapView.mapboxMap.styleURI = .dark
            } else {
                mapView.mapboxMap.styleURI = .standard
            }
        }
        
        let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: 41.2995, longitude: 69.2401), zoom: 6, bearing: 0, pitch: 0)
        mapView.mapboxMap.setCamera(to: cameraOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        mapView.ornaments.logoView.isHidden = true
        mapView.ornaments.attributionButton.isHidden = true
        //
//        let configuration = Puck2DConfiguration.makeDefault(showBearing: true)
//        mapView.location.options.puckType = .puck2D(configuration)
        
        
        let configuration = Puck2DConfiguration.makeDefault(showBearing: true)
        mapView.location.options.puckType = .puck2D(configuration)

        // Set up location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Set up the button
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 30
        button.setImage(UIImage(systemName: "location.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.label), for: .normal)
        button.addTarget(self, action: #selector(navigateToUserLocation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.backgroundColor = UIColor(named: "ColorTest")
        button.applyShadow()
        
        let height = self.tabBarController?.tabBar.frame.height ?? 49.0
        // Set up button constraints
        button.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-height - 20)
            make.right.equalToSuperview().offset(-20)
            make.height.width.equalTo(60)
        }
      
        // Add markers
        addMarkers()
    
    }
    
    // Location manager delegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location.coordinate
        }
    }
    
    // Navigate to user location
    @objc func navigateToUserLocation() {
        guard let userLocation = userLocation else {
            print("User location not available")
            return
        }
        
        let cameraOptions = CameraOptions(center: userLocation, zoom: 12, bearing: 0, pitch: 0)
        mapView.mapboxMap.setCamera(to: cameraOptions)
    }
    
    // Add markers to the map
    func addMarkers() {
        print("xxxx", mapLocations)
        var coordinates = [CLLocationCoordinate2D]()

        for location in mapLocations {
            coordinates.append(CLLocationCoordinate2DMake(location.longitude, location.latitude))
        }
        
        var pointAnnotations = [PointAnnotation]()
        
        for coordinate in coordinates {
            var pointAnnotation = PointAnnotation(coordinate: coordinate)
            
            // Load the custom image from the asset catalog
            if let image = UIImage(named: "trash-bin") {
                pointAnnotation.image = .init(image: image, name: "UZ")
            } else {
                print("Failed to load image named 'UZ'")
            }
            
            pointAnnotations.append(pointAnnotation)
        }
        
        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        pointAnnotationManager.annotations = pointAnnotations
    }
}

extension MapViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let viewMode = UD.mode ?? ""
        if viewMode == "light" {
            mapView.mapboxMap.styleURI = .standard
        } else if viewMode == "dark" {
            mapView.mapboxMap.styleURI = .dark
        } else if viewMode == "system" {
            let mode = Functions.getDeviceMode()
            if mode == .light {
                mapView.mapboxMap.styleURI = .standard
            } else if mode == .dark {
                mapView.mapboxMap.styleURI = .dark
            } else {
                mapView.mapboxMap.styleURI = .standard
            }
        }}

}
