//
//  ViewController.swift
//  Project Keyless
//
//  Created by Eduard Schlotter on 04/12/2016.
//  Copyright © 2016 Eduard Schlotter. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController,BluetoothSerialDelegate {

    @IBOutlet weak var NavBar: UINavigationBar!
    
    @IBOutlet weak var Label: UINavigationItem!


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serial = BluetoothSerial(delegate: self)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        
    }
    func serialDidChangeState() {
        
        if serial.centralManager.state != .poweredOn {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadStartViewController"), object: self)
            dismiss(animated: true, completion: nil)
        }
    }

    


}

