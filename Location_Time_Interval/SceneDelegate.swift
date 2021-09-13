//
//  SceneDelegate.swift
//  Location_Time_Interval
//
//  Created by Yudhishta Dhayalan on 07/09/21.
//

import UIKit
import CoreData
import CoreLocation

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    
    var locationManager = CLLocationManager()
    var backgroundUpdateTask: UIBackgroundTaskIdentifier!
    var bgtimer = Timer()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var current_time = NSDate().timeIntervalSince1970

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var models = [LocationListItem]()
    
    var customLocations  = [LocationListItem]()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
//        self.doBackgroundTask()
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("Entering Backround")
        self.doBackgroundTask()
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
    func doBackgroundTask() {
        
        DispatchQueue.main.async {
            
            self.beginBackgroundUpdateTask()
            
            self.StartupdateLocation()
            // 1*60
            /*
            self.bgtimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(AppDelegate.bgtimer(_:)), userInfo: nil, repeats: true)
//            RunLoop.current.add(self.bgtimer, forMode: RunLoopMode.defaultRunLoopMode)
            RunLoop.current.add(self.bgtimer, forMode: RunLoop.Mode.default)
            RunLoop.current.run()
            
            self.endBackgroundUpdateTask()
            */
        }
    }
    
    func beginBackgroundUpdateTask() {
        self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.endBackgroundUpdateTask()
        })
    }
    
    func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskIdentifier.invalid
    }
    
    
    func StartupdateLocation() {
        locationManager.delegate = self
        
        //Background Updates
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while requesting new coordinates")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        
        print("New Coordinates: ")
//        print(self.latitude)
//        print(self.longitude)
        print(locValue.latitude)
        print(locValue.longitude)
        
        // ❌❌❌❌❌❌❌❌❌❌ Store Lattitude and longitude here ❌❌❌❌❌❌❌❌❌❌
        createItem(lattitude: "\(self.latitude)", longitude: "\(self.longitude)")
        
    }
    
    @objc func bgtimer(_ timer:Timer!){
        self.updateLocation()
    }
    
    func updateLocation() {
        self.locationManager.startUpdatingLocation()
        self.locationManager.stopUpdatingLocation()
    }
    
    
    
    
//    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
//        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
//            completion(placemarks?.first?.locality,
//                       placemarks?.first?.country,
//                       error)
//        }
//    }
    

}


//MARK: --- Core Data ---------->

extension SceneDelegate {
    
    // Get All Item --------------->
    
    func getAllItem() {
        do {
            models = try context.fetch(LocationListItem.fetchRequest())
            
            DispatchQueue.main.async {
                //reload 
            }
            
        } catch {
            
        }
    }
    
    func getAllDataaaa() {
        
        do {
            var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationListItem")
            let results  = try context.fetch(fetchRequest)
            let locations = results as! [LocationListItem]
            customLocations = locations
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
    }
    
    // Create --------------->
    
    func createItem(lattitude: String, longitude: String) {
        
        let newItem = LocationListItem(context: context)
        newItem.lattitude = lattitude
        newItem.longitude = longitude
        do {
            try context.save()
//            getAllItem()
            getAllDataaaa()
            
//            print("🧖🏼‍♀️🧖🏼‍♀️🧖🏼‍♀️🧖🏼‍♀️🧖🏼‍♀️🧖🏼‍♀️🧖🏼‍♀️🧖🏼‍♀️🧖🏼‍♀️🧖🏼‍♀️ \(lattitude) --- \(longitude)🧖🏼‍♀️🧖🏼‍♀️🧖🏼‍♀️🧖🏼‍♀️🧖🏼‍♀️🧖🏼‍♀️🧖🏼‍♀️🧖🏼‍♀️🧖🏼‍♀️🧖🏼‍♀️")

        } catch {
            
        }
    }
    
    
    // Update --------------->
    
    func updateItem(item: LocationListItem, newLattitude: String, newLongitude: String) {
        item.lattitude = newLattitude
        item.longitude = newLongitude
        do {
            try context.save()
//            getAllItem()
            getAllDataaaa()
        } catch {
            
        }
    }
    
}
