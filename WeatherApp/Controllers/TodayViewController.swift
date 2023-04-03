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
    
    private var cities: Set<City> = Set<City>()
    
    private var popUpIsHidden = true
    
    private var dataIsRetrieved = false
    
    var effect: UIVisualEffect!
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.backgroundColor = .blueBackgroundColor
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .accentColor
        return pageControl
    }()
    
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
        let layout = UPCarouselFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width * 0.8, height: view.frame.height * 0.55)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: TodayCollectionViewCell.identifier)
        collectionView.backgroundColor = .blueBackgroundColor
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navController = self.tabBarController?.viewControllers?[1] as! UINavigationController
        let vc = navController.topViewController as! ForecastViewController
        vc.clearData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let loadingView = LoadingView()
        view.addSubview(loadingView)
        loadingView.frame = view.bounds
        DispatchQueue.main.async {[weak self] in
            self?.getLocation()
        }
        loadingView.removeFromSuperview()
        view.backgroundColor = .blueBackgroundColor
        configureNavBar()
        view.addSubview(todayCollectionView)
        view.addSubview(addButton)
        view.addSubview(pageControl)
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
    
    public func updateDataWithCityName(cityName: String) {
        getWeatherWithCityName(name: cityName)
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
    
    public func animateOut() {
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
                self.cities.insert(city)
                DispatchQueue.main.async { [weak self] in
                    self?.todayCollectionView.reloadSections(IndexSet(integer: 0))
                    self?.pageControl.numberOfPages = self?.todayCollectionView.numberOfItems(inSection: 0) ?? 0
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getWeatherWithCityName(name: String) {
        APICaller.shared.getCityWith(cityName: name) { result in
            switch result {
            case .success(let city):
                self.cities.insert(city)
                DispatchQueue.main.async { [weak self] in
                    self?.todayCollectionView.reloadData()
//                    self?.todayCollectionView.reloadSections(IndexSet(integer: 0))
                    self?.pageControl.numberOfPages = self?.todayCollectionView.numberOfItems(inSection: 0) ?? 0
                }
            case .failure(let error):
                print(error)
                let errorMessage = "City with that name was not found"
                DispatchQueue.main.async { [weak self] in
                    let errorView = ErrorPopupView()
                    errorView.translatesAutoresizingMaskIntoConstraints = false
                    guard let view = self?.view as? UIView else {return}
                    errorView.showMessage(errorMessage, inView: view)
                }
            }
        }
    }
    
    private func configurePopViewConstraints() {
        let todayCollectionViewConstraints = [
            todayCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todayCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            todayCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            todayCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
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
        
        NSLayoutConstraint.activate(todayCollectionViewConstraints)
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
        
        let pageControlConstraints = [
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(addButtonConstraints)
        NSLayoutConstraint.activate(pageControlConstraints)
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
            cell.configure(with: cities.enumerated().first{(index , value) in index == indexPath.row}!.element)
            cell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongPressToDelete)))
        }
        return cell
    }
    
    private func deleteCell(at indexPath: IndexPath) {
        if cities.count > 1 {
            let city = cities.enumerated().first{(index , value) in index == indexPath.row}!.element
            cities.remove(city)
            todayCollectionView.deleteItems(at: [indexPath])
            pageControl.numberOfPages = self.todayCollectionView.numberOfItems(inSection: 0)
        } else {
            let errorMessage = "You can't delete city weather information when there is only one city."
            DispatchQueue.main.async { [weak self] in
                let errorView = ErrorPopupView()
                errorView.translatesAutoresizingMaskIntoConstraints = false
                guard let view = self?.view as? UIView else {return}
                errorView.showMessage(errorMessage, inView: view)
            }
        }
    }
    
    @objc private func didLongPressToDelete(_ sender: UILongPressGestureRecognizer) {
        if(sender.delaysTouchesEnded) {
            let location = sender.location(in: todayCollectionView)
            guard let indexPath = todayCollectionView.indexPathForItem(at: location) else {return}
            let vc = UIAlertController(title: "Delete City", message: "Are you sure that you want to delete this city Weather?", preferredStyle: .actionSheet)
            vc.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                self?.deleteCell(at: indexPath)
            }))
            vc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
        let navController = self.tabBarController?.viewControllers?[1] as! UINavigationController
        let vc = navController.topViewController as! ForecastViewController
        let city = cities.enumerated().first{(index , value) in index == indexPath.row}!.element
        let lat: String = String(city.coord.lat!)
        let lon: String = String(city.coord.lon!)
        
        vc.configureWith(lat: lat, lon: lon)
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
        handleAuthenticalStatus(status: status)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let userLocation = locations.last else { return }
            
            let latitude = String(userLocation.coordinate.latitude)
            let longitude = String(userLocation.coordinate.longitude)
        
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
