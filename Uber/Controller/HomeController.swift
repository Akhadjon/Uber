//
//  HomeController.swift
//  Uber
//
//  Created by Akhadjon Abdukhalilov on 11/16/20.
//

import UIKit
import MapKit
import Firebase

private let annotationIdentifier = "DriverAnnotation"

class HomeController: UIViewController, CLLocationManagerDelegate {

    
    //MARK:-Properties
    
    private let mapView = MKMapView()
    private let locationManager = LocationHandler.shared.locationManager
    private let inputActivationView = LocationInputActivationView()
    private let locationInputView =  LocationInputView()
    private let tableView = UITableView()
    private var user:User? {
        didSet{
            locationInputView.user = user
        }
    }
    
    
    //MARK:-Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        print("DEBUG:    \(locationManager?.location)")
        chechUserIsLoggedIn()
        enableLocationServices()
        fetchUserData()
        fetchDrivers()
        //signOut()
    }
    
    
    //MARK: - APi
    func fetchUserData(){
        guard let currentUid = Auth.auth().currentUser?.uid else{return}
        Service.shared.fetchUserData(uid: currentUid) { user in
            self.user = user
        }
    }
    
    func fetchDrivers(){
        guard let location = locationManager?.location else{ return }
        Service.shared.fetchDrivers(location: location) { (driver) in
            guard let coordinate = driver.location?.coordinate else {return}
            let annotation =  DriverAnnonation(uid: driver.uid, coordinate: coordinate)
            
            var driverIsVisable:Bool{
                return self.mapView.annotations.contains { annotation -> Bool in
                    guard let annotation = annotation as? DriverAnnonation else {return false}
                    if driver.uid == driver.uid {
                        //update posiion
                        print("DEBUG: handle update driver location ")
                        return true
                    }
                    return false
                }
            }
            if !driverIsVisable{
                self.mapView.addAnnotation(annotation)
            }
           
        }
    }
    
    private func chechUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let controller = UINavigationController(rootViewController: LoginController())
                controller.modalPresentationStyle = .fullScreen
                self.present(controller,animated: false,completion: nil)
            }
        }else{
            configureUI()
        }
    }
    
    private func signOut(){
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let controller = UINavigationController(rootViewController: LoginController())
                controller.modalPresentationStyle = .fullScreen
                self.present(controller,animated: false,completion: nil)
            }
        }catch {
            print("DEBUG: Error in signing out..")
        }
    }
    
    
    //MARK:Helper functions
    
    func configureUI(){
        configureMapView()
        
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimentions(height: 50, width: view.frame.width - 64)
        inputActivationView.anchor(top:view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        inputActivationView.alpha = 0
        inputActivationView.delegate = self
        
        UIView.animate(withDuration: 2){
            self.inputActivationView.alpha = 1
        }
        
        configureTableView()
    }
    
    func configureMapView(){
        view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
       
    }
    
    func configureLocationInputView(){
       
        view.addSubview(locationInputView)
        locationInputView.anchor(top:view.topAnchor,left: view.leftAnchor,right: view.rightAnchor,height: 200)
        locationInputView.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.locationInputView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.locationInputView.delegate = self
                self.tableView.frame.origin.y = 200
            })
           
        }
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationCell.self, forCellReuseIdentifier: LocationCell.identifier)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        tableView.frame = CGRect(x: 0, y:view.frame.height, width: view.frame.width, height: view.frame.height-200)
        view.addSubview(tableView)
    }

}

//MARK: - MKMapViewDelegate

extension HomeController:MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnnonation{
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier:annotationIdentifier)
            view.image = #imageLiteral(resourceName: "chevron-sign-to-right")
            return view
        }
        return nil
    }
}

//MARK:-Location services
extension HomeController {

    func enableLocationServices(){
        locationManager?.delegate = self
        switch CLLocationManager.authorizationStatus(){
        case .notDetermined:
            print("DEBUG: not determined...")
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("DEBUG: Auth always")
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("DEBUG: Auth when in use ...")
            locationManager?.requestAlwaysAuthorization()
        @unknown default:
            break
        }
        
    }
    
    
    
}

//MARK:- LocationInputActivationViewDelegate

extension HomeController:LocationInputActivationViewDelegate{
    func presentLocationInputView() {
        inputActivationView.alpha = 0
       configureLocationInputView()
    }
}

//MARK:- LocationInputViewDelegate
extension HomeController:LocationInputViewDelegate{
    func dismissLocationInputView() {
        locationInputView.removeFromSuperview()
        UIView.animate(withDuration: 0.3, animations: {
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.view.frame.height
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.inputActivationView.alpha = 1
            })
           
        }
    }
}

//MARK:- UITableViewDelegate/UITableViewDataSource

extension HomeController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Test"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2:5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier, for: indexPath) as! LocationCell
        return cell
    }
}

