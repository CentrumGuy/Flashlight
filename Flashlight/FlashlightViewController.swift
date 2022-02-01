//
//  ViewController.swift
//  Flashlight
//
//  Created by Shahar Ben-Dor on 1/27/22.
//

import UIKit
import AVFoundation

class FlashlightViewController: UIViewController {
    
    @IBOutlet weak var flashlightButton: UIButton!
    @IBOutlet weak var screenlightButton: UIButton!
    @IBOutlet weak var brightnessSlider: UISlider!
    
    var defaultBrightness: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flashlightButton.layer.cornerRadius = flashlightButton.bounds.height/2
        screenlightButton.layer.cornerRadius = screenlightButton.bounds.height/2
        
        flashlightButton.setImage(UIImage(named: "flashlight_off"), for: .normal)
        flashlightButton.setImage(UIImage(named: "flashlight_on"), for: .selected)
        
        screenlightButton.setImage(UIImage(named: "screenlight_off"), for: .normal)
        screenlightButton.setImage(UIImage(named: "screenlight_on"), for: .selected)
        
        view.backgroundColor = .black
    }
    
    @IBAction func didTapFlashlightButton(_ sender: Any) {
        flashlightButton.isSelected = !flashlightButton.isSelected
        
        if let device = AVCaptureDevice.default(for: .video), device.hasFlash {
            do {
                try device.lockForConfiguration()
                if flashlightButton.isSelected {
                    try device.setTorchModeOn(level: max(brightnessSlider.value, 0.001))
                } else {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
        
    }
    
    @IBAction func didTapScreenlightButton(_ sender: Any) {
        screenlightButton.isSelected = !screenlightButton.isSelected
        
        if screenlightButton.isSelected {
            defaultBrightness = UIScreen.main.brightness
            UIScreen.main.brightness = CGFloat(brightnessSlider.value)
            view.backgroundColor = .white
        } else {
            UIScreen.main.brightness = defaultBrightness
            view.backgroundColor = .black
        }
    }
    
    @IBAction func didSlideBrightnessSlider(_ sender: Any) {
        if let device = AVCaptureDevice.default(for: .video), device.hasFlash, flashlightButton.isSelected {
            do {
                try device.lockForConfiguration()
                try device.setTorchModeOn(level: max(brightnessSlider.value, 0.001))
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
        
        if screenlightButton.isSelected {
            UIScreen.main.brightness = CGFloat(brightnessSlider.value)
        }
    }
    
}

