//
//  LocationsViewController.swift
//  MagicCoin
//
//  Created by ASH on 8/12/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationsViewController: UIViewController {
    
    enum SegmentIndex: Int {
        case map
        case list
        case count
        
        static func titleFor(enumCase :SegmentIndex) -> String {
            switch enumCase {
            case .map:
                return "Map"
            case .list:
                return "List"
            default:
                return ""
            }
        }
    }
    
    let controllerTitle = "Locations"
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var segmentedControlView: MGCSegmentedControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var tableViewHiddenTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewShownTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mapContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var terminalInfoViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timetableLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var zoomLevel: Float = 15.0
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: 50.450044, longitude: 30.523659) //Kiev
    
    var terminals = [Terminal]()
    var markerTerminalMap = [GMSMarker : Terminal]()
    
    var terminalInfoIsHidden: Bool {
        get {
            return !terminalInfoViewBottomConstraint.isActive
        }
    }
    
    var tableViewDataSource: TableDataSource<TerminalTableViewCell, Terminal>!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = controllerTitle
        setupSegmentedControl()
        
        locationManager = LocationManagerHolder.shared.locationManager
        currentLocation = locationManager.location
        locationManager.delegate = self
        
        loadTerminals()
        setupMapView()
        hideTableView()
        hideTerminalInfo()
        setupTableView()
        updateTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        hideTableView()
        hideTerminalInfo()
    }
    
    //MARK: - Actions
    
    @IBAction func onBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func onZoomInButton(_ sender: UIButton) {
        zoomLevel += 1
        mapView.animate(toZoom: zoomLevel)
    }
    
    @IBAction func onZoomOutButton(_ sender: UIButton) {
        zoomLevel -= 1
        mapView.animate(toZoom: zoomLevel)
    }
    
    @IBAction func onTerminalInfoButton(_ sender: UIButton) {
        hideTerminalInfo()
    }
    //MARK: - Private
    
    private func setupMapView() {
        let defaultCoordinate = defaultLocation.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: defaultCoordinate.latitude,
                                              longitude: defaultCoordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: mapContainerView.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
        mapContainerView.insertSubview(mapView, at: 0)
        
        setupMarkers()
    }
    
    private func setupMarkers() {
        for terminal in terminals {
            let marker = GMSMarker()
            marker.position = terminal.location.coordinate
            marker.title = "Terminal \(terminal.id)"
            marker.snippet = terminal.address
            marker.icon = #imageLiteral(resourceName: "MarkerSmall")
            marker.map = mapView
            
            markerTerminalMap[marker] = terminal
        }
    }
    
    private func loadTerminals() {
        terminals = PredefinedData.terminals
    }
    
    private func setupSegmentedControl() {
        segmentedControlView.countersVisible = false
        let buttonsCount = SegmentIndex.count.rawValue
        segmentedControlView.buttonsCount = buttonsCount
        for index in 0..<buttonsCount {
            if let enumCase = SegmentIndex(rawValue: index) {
                let title = SegmentIndex.titleFor(enumCase: enumCase)
                segmentedControlView.setTitle(title, forButtonAt: index)
            }
        }
        
        segmentedControlView.delegate = self
    }
    
    fileprivate func showTableView() {
        UIView.animate(withDuration: 0.3) {[unowned self] in
            self.tableViewHiddenTopConstraint.isActive = false
            self.tableViewShownTopConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func hideTableView() {
        UIView.animate(withDuration: 0.3) {[unowned self] in
            self.tableViewShownTopConstraint.isActive = false
            self.tableViewHiddenTopConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func showTerminalInfo() {
        UIView.animate(withDuration: 0.3) {[unowned self] in
            self.mapContainerBottomConstraint.isActive = false
            self.terminalInfoViewBottomConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func hideTerminalInfo() {
        UIView.animate(withDuration: 0.3) {[unowned self] in
            self.mapContainerBottomConstraint.isActive = true
            self.terminalInfoViewBottomConstraint.isActive = false
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func fillTerminalInfoWith(terminal: Terminal) {
        nameLabel.text = terminal.name
        idLabel.text = "Terminal #\(terminal.id)"
        addressLabel.text = terminal.address
        timetableLabel.text = terminal.timetable
        if terminal.distance > 0 {
            distanceLabel.text = "\(terminal.distance)m"
        } else {
            distanceLabel.text = ""
        }
    }
    
    private func setupTableView() {
        tableView.register(TerminalTableViewCell.nib, forCellReuseIdentifier: TerminalTableViewCell.nibName)
        tableView.separatorInset = UIEdgeInsetsMake(0, 30, 0, 30)
    }
    
    fileprivate func updateTableView() {
        tableViewDataSource = TableDataSource(cellIdentifier: TerminalTableViewCell.nibName, items: terminals, configureCell: { (cell, terminal) in
            cell.model = terminal
        })
        
        tableView.dataSource = tableViewDataSource
        tableView.reloadData()
    }
}

//MARK: - CLLocationManagerDelegate

extension LocationsViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        currentLocation = location
        updateTableView()
        
        let locationCoordinate = location.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: locationCoordinate.latitude,
                                              longitude: locationCoordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

//MARK: - MGCSegmentedControlDelegate

extension LocationsViewController: MGCSegmentedControlDelegate {
    func didTapButton(at index: Int) {
        switch index {
        case SegmentIndex.map.rawValue:
            print("map")
            hideTableView()
        case SegmentIndex.list.rawValue:
            print("list")
            hideTerminalInfo()
            showTableView()
        default:
            break
        }
    }
}

//MARK: - GMSMapViewDelegate

extension LocationsViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        var showMakerInfo = true
        if let terminal = markerTerminalMap[marker] {
            if terminalInfoIsHidden {
                fillTerminalInfoWith(terminal: terminal)
                showTerminalInfo()
            } else {
                hideTerminalInfo()
            }
            
        } else {
            showMakerInfo = false
        }
        
        return showMakerInfo
    }
}

//MARK: - UITableViewDelegate

extension LocationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let terminal = terminals[indexPath.row]
        UIView.animate(withDuration: 0.2, animations: {[unowned self] in
            self.segmentedControlView.selectButtonAt(index: SegmentIndex.map.rawValue)
            self.hideTableView()
        }) { (completed) in
            UIView.animate(withDuration: 0.3, animations: { [unowned self] in
                self.fillTerminalInfoWith(terminal: terminal)
                self.showTerminalInfo()
            })
        }
    }
}
