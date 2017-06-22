//
//  ViewController.swift
//  home-monitoring
//
//  Created by Konrad on 12.06.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ESTDeviceManagerDelegate, ESTDeviceConnectableDelegate{
    
    
    @IBOutlet weak var temperatureInfoLabel: UILabel!
    
    var monitoringDevice: ESTDeviceLocationBeacon?
    let monitoringDeviceIdentifier: String = "4e4fdfa0dc89ddde6397211621338628"
    lazy var monitoringDeviceManager: ESTDeviceManager = {
        let manager = ESTDeviceManager()
        manager.delegate = self
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let beaconFilter = ESTDeviceFilterLocationBeacon(identifier: self.monitoringDeviceIdentifier)
        self.monitoringDeviceManager.startDeviceDiscovery(with: beaconFilter)
    }
    
    func deviceManager(_ manager: ESTDeviceManager, didDiscover devices: [ESTDevice]) {
        guard let device = devices.first as? ESTDeviceLocationBeacon else { return }
        self.monitoringDeviceManager.stopDeviceDiscovery()
        self.monitoringDevice = device
        self.monitoringDevice?.delegate = self
        self.monitoringDevice?.connect()
    }
    
    func estDeviceConnectionDidSucceed(_ device: ESTDeviceConnectable) {
        print("Connection Output Status: Connected")
        let temperatureInfo = Int((monitoringDevice?.settings?.sensors.temperature.getValue())!)
        temperatureInfoLabel.text = "\(temperatureInfo) °C"
    }
    
    func estDevice(_ device: ESTDeviceConnectable, didFailConnectionWithError error: Error) {
        print("Connection Output Status: \(error.localizedDescription)")
    }
    
    func estDevice(_ device: ESTDeviceConnectable, didDisconnectWithError error: Error?) {
        print("Connection Output Status: Disconnected")
    }


}

