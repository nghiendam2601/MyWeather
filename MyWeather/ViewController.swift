//
//  ViewController.swift
//  MyWeather
//
//  Created by DamMinhNghien on 24/8/24.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet var text: UILabel!
    @IBOutlet var Temp: UILabel!
    @IBOutlet var CityName: UILabel!
    @IBOutlet var Image: UIImageView!
    @IBOutlet var ColorModeButton: UIButton!
    var colorMode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("run View1")

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
        print("run View2")

        Task{
            print("run View3")

            do{
                print("run View4")

                let weatherManager = WeatherManager()
                print("run View5")

                let weather = try await weatherManager.getCurrentWeather()
                print("run View6")

                UpdateUICurrent(text: weather.current.condition.text, temp: weather.current.tempC, name: weather.location.name, image: weather.current.condition.icon)
                print("run View7")

            }       catch WeatherError.urlError{
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
        print("run View8")

        // Do any additional setup after loading the view.
    }
    @MainActor
    func UpdateUICurrent(text: String, temp: Double, name: String, image: String){
        print("run actor1")

        self.text.text = text
        self.Temp.text = "\(temp)°C"
        self.CityName.text = name
        print("run actor2")

        Image.kf.setImage(with: URL(string: "https:\(image)"))
        print("run actor3")

    }
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
    
}
