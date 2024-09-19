//
//  ViewController.swift
//  MyWeather
//
//  Created by DamMinhNghien on 24/8/24.
//

import UIKit
import Kingfisher
import Network

class ViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var text: UILabel!
    @IBOutlet var Temp: UILabel!
    @IBOutlet var CityName: UILabel!
    @IBOutlet var Image: UIImageView!
    @IBOutlet var ColorModeButton: UIButton!
    //MARK: - Properties
    var colorMode: String?
    private let weatherManager = WeatherManager()
    var forecastResponse: [ForecastWeatherModel] = []
    var CurrentWeather: CurrentWeatherModel?
    //MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isHidden = true
        //MARK: LocationManager
        _ = CoreLocationManager.shared
        CoreLocationManager.shared.askForLocationPermission()
        if let savedMode = UserDefaults.standard.string(forKey: "colorMode") {
            if savedMode == "dark" {
                overrideUserInterfaceStyle = .dark
                colorMode = "dark"
            } else {
                overrideUserInterfaceStyle = .light
                colorMode = "light"
            }
        } else {
            overrideUserInterfaceStyle = .unspecified
            colorMode = "light"
        }
        
        // Do any additional setup after loading the view.
        setupCollectionView()
        startNetwork()
    }
    private func fetchWeatherData( type: SearchType, lat: Double = 0, lon: Double = 0, city: String = "") {
        Task {
            do {
                switch type {
                case .city:
                    print("run1")
                    CurrentWeather = try await weatherManager.getCurrentWeather(cityName: city)
                    print("run2")
                    
                    forecastResponse = try await weatherManager.getForecastWeather(cityName: city)
                    print("run3")
                case .cooodinate:
                    print("run1")
                    CurrentWeather = try await weatherManager.getCurrentWeather(lat: lat, lon: lon)
                    print("run2")
                    
                    forecastResponse = try await weatherManager.getForecastWeather(lat: lat, lon: lon)
                    print("run3")                }
              
                
                // Cập nhật UI với dữ liệu thời tiết hiện tại
                if let currentWeather = CurrentWeather{
                    UpdateUICurrent(text: currentWeather.des, temp: currentWeather.temp, name: currentWeather.name, image: currentWeather.icon)
                }
                print("run4")
                // Cập nhật UI với dữ liệu dự báo thời tiết
                if !forecastResponse.isEmpty {
                    print("run5")
                    
                    await MainActor.run {
                        print("run6")
                        searchTextField.text = ""
                        collectionView.isHidden = false
                        collectionView.reloadData()
                    }
                }
            } catch {
                print("Failed to fetch weather data: \(error)")
            }
        }
    }
    //MARK: Check Network Connection
    func startNetwork(){
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            print("nsakska")
            if path.status == .satisfied {
                print("We're connected!")
                CoreLocationManager.shared.getCurrentLocation(completion: {
                    location in
                    print("inside")
                    self.fetchWeatherData(type: .cooodinate,lat: location.coordinate.latitude,lon: location.coordinate.longitude)
                })
            }else if path.status == .requiresConnection{
                print("require")
            }
            else {
                print("No connection.")
            }
            
            //            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        //        let cellMonitor = NWPathMonitor(requiredInterfaceType: .cellular)
    }
    //MARK: UpdateUI
    @MainActor
    func UpdateUICurrent(text: String, temp: Int, name: String, image: String){
        print("run7")
        
        self.text.text = text
        self.Temp.text = "\(temp)°C"
        self.CityName.text = name
        
        Image.kf.setImage(with: URL(string: "https://openweathermap.org/img/wn/\(image)@2x.png"))
        
    }
    //MARK: - ColorMode
    @IBAction func ChangeColorMode(_ sender: UIButton) {
        if overrideUserInterfaceStyle == .dark {
            overrideUserInterfaceStyle = .light
            colorMode = "light"
            UserDefaults.standard.set("light", forKey: "colorMode")
        } else {
            overrideUserInterfaceStyle = .dark
            colorMode = "dark"
            UserDefaults.standard.set("dark", forKey: "colorMode")
        }
    }
    //MARK: Setup CollectionView
    func setupCollectionView(){
        collectionView.register(UINib(nibName: "HourForecastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HourForecast")
        collectionView.dataSource = self
        setupCollectionViewLayout()
        
    }
    //MARK: - CLV Layout
    func setupCollectionViewLayout(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80 , height: 140)
        collectionView.collectionViewLayout = layout
        collectionView.layer.cornerRadius = 10
    }
    
    @IBAction func buttonSearch(_ sender: UIButton) {
        fetchWeatherData(type: .city, city: searchTextField.text!)
    }
    
    @IBAction func currentLocationClick(_ sender: UIButton) {
        CoreLocationManager.shared.getCurrentLocation(completion: {
            location in
            print("inside")
            self.fetchWeatherData(type: .cooodinate,lat: location.coordinate.latitude,lon: location.coordinate.longitude)
        })
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastResponse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourForecast", for: indexPath) as! HourForecastCollectionViewCell
        print("forrowat")
        cell.hour.text = forecastResponse[indexPath.row].hour
        cell.image.kf.setImage(with: URL(string: "https://openweathermap.org/img/wn/\(forecastResponse[indexPath.row].icon)@2x.png"))
        cell.temp.text = "\(forecastResponse[indexPath.row].temp)°C"
        cell.dayMonth.text = forecastResponse[indexPath.row].dayMonth
        return cell
    }
    
    
}
