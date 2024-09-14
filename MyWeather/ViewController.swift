//
//  ViewController.swift
//  MyWeather
//
//  Created by DamMinhNghien on 24/8/24.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var text: UILabel!
    @IBOutlet var Temp: UILabel!
    @IBOutlet var CityName: UILabel!
    @IBOutlet var Image: UIImageView!
    @IBOutlet var ColorModeButton: UIButton!
    //MARK: - Properties
    var colorMode: String?
    var weatherData: CurrentWeatherModel?
    //MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        //MARK: Concurency
        Task{
            do{
                let weatherManager = WeatherManager()
                weatherData = try await weatherManager.getWeather()
                print("run1")
                if let weather = weatherData{
                    UpdateUICurrent(text: weather.des, temp: weather.temp, name: weather.name, image: weather.icon)
                }
            }catch WeatherError.urlError{
                print("url error")
            }catch WeatherError.ResponseError{
                print("response error")
            }catch WeatherError.DecodingError{
                print("decoding error")
            }catch{
                print("unexpected error")
            }
        }
        colorMode = "light"
        
        // Do any additional setup after loading the view.
        setupCollectionView()
    }
    //MARK: UpdateUI
    func UpdateUICurrent(text: String, temp: Int, name: String, image: String){
        self.text.text = text
        self.Temp.text = "\(temp)°C"
        self.CityName.text = name
        
        Image.kf.setImage(with: URL(string: "https://openweathermap.org/img/wn/\(image)@2x.png"))
//            // Thay "64x64" bằng "128x128" để lấy hình ảnh lớn hơn
//            let largerIconURLString = image.replacingOccurrences(of: "64x64", with: "128x128")
//            let fullIconURLString = "https:\(largerIconURLString)"
//            if let iconURL = URL(string: fullIconURLString) {
//                Image.kf.setImage(with: iconURL)
    
        
        collectionView.reloadData()
        
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
        layout.minimumInteritemSpacing = 2
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80 , height: 120)
        collectionView.collectionViewLayout = layout
    }
   
    
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("section")
//        return weatherData?.forecast.forecastday[0].hour.count ?? 0
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourForecast", for: indexPath) as! HourForecastCollectionViewCell
        print("forrowat")
//        cell.hour.text = weatherData?.forecast.forecastday[0].hour[indexPath.row].time
////        if let iconPath = weatherData?.forecast.forecastday[0].hour[indexPath.row].condition.icon {
////            // Thay "64x64" bằng "128x128" để lấy hình ảnh lớn hơn
////            let largerIconURLString = iconPath.replacingOccurrences(of: "64x64", with: "128x128")
////            let fullIconURLString = "https:\(largerIconURLString)"
////            if let iconURL = URL(string: fullIconURLString) {
////                cell.image.kf.setImage(with: iconURL)
////            }
////        }
//        cell.image.kf.setImage(with: URL(string: "https:\(weatherData?.forecast.forecastday[0].hour[indexPath.row].condition.icon ?? "")"))
//        cell.temp.text = "\(weatherData?.forecast.forecastday[0].hour[indexPath.row].tempC ?? 0)°C"
        return cell
    }
    
    
}
