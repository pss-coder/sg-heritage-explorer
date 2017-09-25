//
//  ViewController.swift
//  SG Heritage Explorer
//
//  Created by VongolaKillerAir on 24/9/17.
//  Copyright © 2017 PawandeepSingh. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
import SwiftLocation
import CoreLocation

class ViewController: UIViewController,MGLMapViewDelegate,CLLocationManagerDelegate {

    
    
    //MARK: Properties
    
    private let baseMapStyle:[String] = ["Default.json","Night.json","Grey.json","Original.json"];
    private let oneMapBaseMapURL = "https://maps-json.onemap.sg/Default.json";
    @IBOutlet weak var mapView: MGLMapView!
    
    var locationManager = CLLocationManager();

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DisplayOneMapBaseMap();
        mapView.delegate = self;
        
        setGeoFencingFor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    //MARK: PRIVATE FUNCTIONS
//========================================  PRIVATE FUNCTIONS  ================================
    
    /**
     Displays OneMap Base Map into Map View.
     This method also sets zoom level and displays user current location.
     - Returns: no return value
     */
    private func DisplayOneMapBaseMap()
    {
        //using onemap base map
        let styleURL = URL(string:"https://maps-json.onemap.sg/Default.json");//"\(oneMapBaseMapURL)\(baseMapStyle[0])"
       // print(oneMapBaseMapURL+baseMapStyle[0]);
        mapView.styleURL = styleURL;
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // make the map resizeable
        
        //Setting the max and min of zoom level of map
        mapView.minimumZoomLevel = 10.0;
        mapView.maximumZoomLevel = 18.0;
        
        //Show User Current Locations
        mapView.showsUserLocation = true;
         mapView.setUserTrackingMode(.followWithHeading, animated: false)
       // mapView.setZoomLevel(20, animated: false);
        
        let merlionParkLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(1.2867888749929002, 103.8545510172844);
//       // let currloc = CLLocationCoordinate2DMake(mapView.userLocation?.coordinate.latitude!,
//                                                 mapView.userLocation?.coordinate.longitude!);

       mapView.setCenter(merlionParkLocation,zoomLevel: 12, animated: false);
        
    }
    
    /**
     Method will Display Heritage Sites onto Map
     */
    private func LoadHeritage(){}
    /***/
    
    /**
     Method will Set up geofencing for each Heritage Sites
     */
    private func setGeoFencingFor()
    {
        //set up geofencing monitoring for heritage
        let geofenceRegionCenter = CLLocationCoordinate2DMake(1.286789, 103.854501);
        let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 500, identifier: "Merlion Park");
        CreateGeoFence(forRegion: geofenceRegion);
        
        //display geofencing region (optional to have)
        let polygon = MapUtilities.DrawPolygonCircleForCoordinate(coordinate: geofenceRegionCenter, withMeterRadius: 500);
        self.mapView.addAnnotation(polygon)
    }
    
     func CreateGeoFence(forRegion:CLCircularRegion)
    {
        //let geofenceRegionCenter = CLLocationCoordinate2DMake(1.286789, 103.854501);
        //let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 500, identifier: "Merlion Park");
        // polygonCircleForCoordinate(coordinate: geofenceRegionCenter, withMeterRadius: 500);
        print("geofence start for")
        
        do {
            //let loc = CLLocationCoordinate2DMake( 42.972474, 13.757332)
            //let radius = 100.0
            
            try SwiftLocation.Location.monitor(region: forRegion, enter: { _ in
                print("Entered in region! \(forRegion.identifier) ")
                //self.showAlert(title: "Entered", message: "Welcome \(geofenceRegion.identifier)")
                
            }, exit: { _ in
                print("Exited from the region \(forRegion.identifier)")
                // self.showAlert(title: "Exitted", message: "Bye \(geofenceRegion.identifier)")
                
            }, error: { req, error in
                print("An error has occurred \(error)")
                req.cancel() // abort the request (you can also use `cancelOnError=true` to perform it automatically
            })
        } catch {
            print("Cannot start heading updates: \(error)")
        }
        
    }
    
    
    
//===================================  MAPBOX DELEGATES  ================================
    
        //MARK: Annotation Callout
    /** Implement the delegate method that allows annotations to show callouts when tapped.
     */
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    
    /**
     Delagate Method to design LEFT side of the callout annotation.
     */
    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        if (annotation.title! == "Merlion Park") {
            // Callout height is fixed; width expands to fit its content.
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
            label.textAlignment = .right
            label.textColor = UIColor(red: 0.81, green: 0.71, blue: 0.23, alpha: 1)
            label.text = "Roar"
            return label
            
        }
        
        return nil
    }
    
    /**
     Delagate Method to design RIGHT side of the callout annotation.
     */
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        //PUT THE DIRECTIONS BUTTON HERE
        return UIButton(type: .detailDisclosure)
    }
    
    //DIRECTIONS  BTN CLICK
    /**
     Delagate Method to Handle when RIGHT SIDE CALLOUT IS TAPPED
     */
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        // Hide the callout view.
        mapView.deselectAnnotation(annotation, animated: false)
        
        // Show an alert containing the annotation's details
        let alert = UIAlertController(title: annotation.title!!, message: "A lovely (if touristy) place.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    /**
     Delagate method to handle when surrounding callout is tapped.
     */
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
//        // Optionally handle taps on the callout.
//        //WHEN IMAGE OR THE CALLOUT IS TAPPED :
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "popUp") as! PopUpViewController;
//        // print(annotation.title!);
//        
//        // newViewController.text = "test 123";
//        self.present(newViewController, animated: true, completion: nil)
//        newViewController.labeltest.text = annotation.title!;
        print("Tapped the callout for: \(annotation)")
        
        // Hide the callout.
        mapView.deselectAnnotation(annotation, animated: true)
    }
    
//  ====================================   ANNOTATION STYLE LOOK ==============================
    //MARK: Annotation Style
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 1
    }
    //    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
    //        return .white
    //    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        // Give our polyline a unique color by checking for its `title` property
        if (annotation.title == "Crema to Council Crest" && annotation is MGLPolyline) {
            // Mapbox cyan
            return UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1)
        }
        else
        {
            return .red
        }
    }
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return UIColor(red: 59/255, green: 178/255, blue: 208/255, alpha: 1)
    }
    
    
    
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        // Set the line width for polyline annotations
        return 2.0
    }
    


}

