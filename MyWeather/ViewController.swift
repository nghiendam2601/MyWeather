//
//  ViewController.swift
//  MyWeather
//
//  Created by DamMinhNghien on 24/8/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var ColorModeButton: UIButton!
    var colorMode: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorMode = "light"
       
        // Do any additional setup after loading the view.
    }
    @IBAction func ChangeColorMode(_ sender: UIButton) {
        if overrideUserInterfaceStyle.self == .dark {
            overrideUserInterfaceStyle = .light

        }else{
            overrideUserInterfaceStyle = .dark

            colorMode = "dark"
        }
    }
    
}

