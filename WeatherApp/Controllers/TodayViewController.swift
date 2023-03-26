//
//  TodayViewController.swift
//  WeatherApp
//
//  Created by Beka Buturishvili on 14.02.23.
//

import UIKit
import CoreLocation

class TodayViewController: UIViewController {
    
    var locationManager: CLLocationManager!
    
    private var cities: [City] = [City]()
    
    private var popUpIsHidden = true
    
    private var dataIsRetrieved = false
    
    var effect: UIVisualEffect!
    
    private var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.backgroundColor = .clear
        view.clearsContextBeforeDrawing = true
        view.autoresizesSubviews = true
        return view
    }()
    
    private lazy var popUpView: UIView = {
        let view = AddCityPopUpView(frame: CGRect(x: 40, y: 150, width: view.bounds.width * 3/4, height: view.bounds.height * 1/3))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.alpha = 0
        return view
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.tintColor = .blueBackgroundColor
        let plusSign = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22,weight: .bold))
        button.setImage(plusSign, for: .normal)
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var todayCollectionView: UICollectionView = {
        let layout = HSCycleGalleryViewLayout()
        layout.itemWidth = view.bounds.width * 0.8
        layout.itemHeight = view.bounds.height * 0.5
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), collectionViewLayout: layout)
        collectionView.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: TodayCollectionViewCell.identifier)
        collectionView.backgroundColor = .blueBackgroundColor
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        DispatchQueue.global(qos: .userInitiated).async {
//            // Wait for location update before executing rest of the code
//            while self.locationManager.location == nil {}
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
//        retrieveAndReloadDataAfterFirstRun()
        view.backgroundColor = .blueBackgroundColor
        configureNavBar()
        view.addSubview(todayCollectionView)
        view.addSubview(addButton)
        todayCollectionView.delegate = self
        todayCollectionView.dataSource = self
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        todayCollectionView.refreshControl = UIRefreshControl()
        todayCollectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        addShadowsToButton()
        configureConstraints()
    }
    
    private func retrieveAndReloadDataAfterFirstRun() {
        if(dataIsRetrieved == false) {
            view.backgroundColor = .white
            let activity = UIActivityIndicatorView()
            activity.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            activity.center = view.center
            activity.style = .large
            view.addSubview(activity)
            activity.stopAnimating()
            dataIsRetrieved = true
        }
    }
    
    private func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in

            self?.todayCollectionView.reloadData()
        }
        self.todayCollectionView.refreshControl?.endRefreshing()
    }
    
    @objc private func didPullToRefresh() {
        refreshData()
    }
    
    @objc private func didTapAddButton() {
        DispatchQueue.main.async { [weak self] in
            self?.animateIn()
        }
    }
    
    private func configureNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(didTapRefreshButton))
        navigationItem.leftBarButtonItem?.tintColor = .accentColor
        title = "Today"
        
    }
    
    private func animateIn() {
        view.addSubview(visualEffectView)
        view.addSubview(popUpView)
        configurePopViewConstraints()
        popUpView.alpha = 0
        popUpView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.popUpView.alpha = 1
            self.popUpView.transform = .identity
            
        }
    }
    
    private func animateOut() {
        UIView.animate(withDuration: 0.4) {
            self.popUpView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.popUpView.alpha = 0
            self.visualEffectView.effect = nil
        }completion: { complete in
            self.popUpView.removeFromSuperview()
            self.visualEffectView.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
            if touch?.view != popUpView {
                animateOut()
            }
    }
    
    private func addShadowsToButton() {
        self.addButton.layer.shadowColor = UIColor.white.cgColor
        self.addButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.addButton.layer.shadowRadius = 10
        self.addButton.layer.shadowOpacity = 0.4
        self.addButton.layer.masksToBounds = false
        self.addButton.layer.shadowPath = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc private func didTapRefreshButton() {
        refreshData()
    }

    private func getCurrentWeather(latitude: String, longitude: String) {
        APICaller.shared.getCurrentWeather(latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let city):
                self.cities.append(city)
                DispatchQueue.main.async { [weak self] in
                    self?.todayCollectionView.reloadData()
                }
                print(city.name)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getWeatherWithCityName(name: String) {
        APICaller.shared.getCityWith(cityName: name) { result in
            switch result {
            case .success(let city):
                self.cities.append(city)
                DispatchQueue.main.async { [weak self] in
                    self?.todayCollectionView.reloadData()
                }
                print(city.name)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configurePopViewConstraints() {
        let popUpViewConstraints = [
            popUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popUpView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            popUpView.heightAnchor.constraint(equalTo: popUpView.widthAnchor, multiplier: 1)
        ]
        
        let visualEffectViewConstraints = [
            visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(popUpViewConstraints)
        NSLayoutConstraint.activate(visualEffectViewConstraints)
        
    }
    
    private func configureConstraints() {
        let addButtonConstraints = [
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height * 1/8),
            addButton.widthAnchor.constraint(equalToConstant: 44),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor),
        ]
        
        NSLayoutConstraint.activate(addButtonConstraints)
    }

}

extension TodayViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayCollectionViewCell.identifier, for: indexPath) as? TodayCollectionViewCell else {
            return UICollectionViewCell()
        }
        if(!cities.isEmpty) {
            cell.configure(with: cities[indexPath.row])
        }
        return cell
    }
}

extension TodayViewController: CLLocationManagerDelegate {
    func getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func handleAuthenticalStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showLocationDisabledAlert()
        case .denied:
            showLocationDisabledAlert()
        case .authorizedAlways:
            locationManager.requestLocation()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            print("Unknown case of status in handleAuthenticalStatus\(status)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Checking Authentication status")
        handleAuthenticalStatus(status: status)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let userLocation = locations.last else { return }
            
            let latitude = String(userLocation.coordinate.latitude)
            let longitude = String(userLocation.coordinate.longitude)
            
            print("Latitude: \(latitude), Longitude: \(longitude)")
        
            getCurrentWeather(latitude: latitude, longitude: longitude)
           
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        }
        
        func showLocationDisabledAlert() {
            let alert = UIAlertController(title: "Location Access Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: nil)
                }
            }
            alert.addAction(settingsAction)
            
            present(alert, animated: true, completion: nil)
        }

}
