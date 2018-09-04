//
//  ViewController.swift
//  home-monitoring
//
//  Created by Konrad on 12.06.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

import UIKit

/**
 This class controls the flow of connecting to your own beacon and reading its sensors values
 */

class ViewController: UIViewController, ESTDeviceManagerDelegate, ESTDeviceConnectableDelegate{
    
    // MARK: IBOutlets
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    // MARK: Beacon Connection PopUp
    
    let beaconConnectionStatusPopUp = UIAlertController(title: "Detecting beacon", message: "Looks like you're not connected to the beacon yet. Wait a few seconds!", preferredStyle: UIAlertControllerStyle.alert)
    
    // MARK: Class properties
    
    var monitoringDevice: ESTDeviceLocationBeacon?
    
    // TODO: Insert your beacon identifier here to compile
    let monitoringDeviceIdentifier: String = <#Your beacon identifier#>
    
    lazy var monitoringDeviceManager: ESTDeviceManager = {
        let manager = ESTDeviceManager()
        manager.delegate = self
        return manager
    }()
 
    // MARK: ViewController's Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let beaconFilter = ESTDeviceFilterLocationBeacon(identifier: self.monitoringDeviceIdentifier)
        self.monitoringDeviceManager.startDeviceDiscovery(with: beaconFilter)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.present(beaconConnectionStatusPopUp, animated: true, completion: nil)
    }
    
    // MARK: ESTDeviceManagerDelegate methods
 
    func deviceManager(_ manager: ESTDeviceManager, didDiscover devices: [ESTDevice]) {
        guard let device = devices.first as? ESTDeviceLocationBeacon else { return }
        self.monitoringDeviceManager.stopDeviceDiscovery()
        self.monitoringDevice = device
        self.monitoringDevice?.delegate = self
        self.monitoringDevice?.connect()
    }
    
    func estDeviceConnectionDidSucceed(_ device: ESTDeviceConnectable) {
        print("Connection Output Status: Connected")
        
        self.beaconConnectionStatusPopUp.dismiss(animated: true, completion: nil)
        
        let pressurehPA = Int((monitoringDevice?.settings?.sensors.pressure.getValue())!/100)
        let temperatureCelsius = Int((monitoringDevice?.settings?.sensors.temperature.getValue())!)
        
        temperatureLabel.text = "\(temperatureCelsius) °C"
        pressureLabel.text = "\(pressurehPA) hPa"
    }
    
    func estDevice(_ device: ESTDeviceConnectable, didFailConnectionWithError error: Error) {
        print("Connection Output Status: \(error.localizedDescription)")
    }
    
    func estDevice(_ device: ESTDeviceConnectable, didDisconnectWithError error: Error?) {
        print("Connection Output Status: Disconnected")
    }
}
