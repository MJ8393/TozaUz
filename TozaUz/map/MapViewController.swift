//
//  MapViewController.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 06/07/24.
//

import UIKit
import MapboxMaps
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var mapView: MapView!
    var locationManager: CLLocationManager!
    var userLocation: CLLocationCoordinate2D?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Set up the map view
        mapView = MapView(frame: view.bounds)
        
        mapView.backgroundColor = .systemBackground
        title = "map".translate()
        
        let deviceMode = Functions.getDeviceMode()
        if deviceMode == .light {
            mapView.mapboxMap.styleURI = .standard

        }else {
            mapView.mapboxMap.styleURI = .dark
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
        let coordinates = [
            CLLocationCoordinate2D(latitude: 41.48719788, longitude: 69.58899689),
            CLLocationCoordinate2D(latitude: 41.00427628, longitude: 70.07332611)
        ]
        
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
        let deviceMode = Functions.getDeviceMode()
        if deviceMode == .light {
            mapView.mapboxMap.styleURI = .standard

        }else {
            mapView.mapboxMap.styleURI = .dark
        }
        }

}
