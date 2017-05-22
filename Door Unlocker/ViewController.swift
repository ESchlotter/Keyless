//
//  ViewController.swift
//  Project Keyless
//
//  Created by Eduard Schlotter on 04/12/2016.
//  Copyright © 2016 Eduard Schlotter. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController,BluetoothSerialDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var LockStatus: UILabel!
    
    @IBOutlet weak var NavBar: UINavigationBar!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var Label: UINavigationItem!

    @IBOutlet var Switch: UISwitch!
    
    @IBAction func SwitchTurn(_ sender: Any) {
        if(Switch.isOn){
            serial.sendMessageToDevice("00")
            if(LockStatus.text != "       Not Connected"){LockStatus.text = "       Locked"}
        }
        else{
            serial.sendMessageToDevice("11")
            if(LockStatus.text != "       Not Connected"){LockStatus.text = "       Unlocked"}
        }
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let logs = serial.getLogs()
        return (logs.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let logs = serial.getLogs()
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = logs[indexPath.row]
        
        return(cell)
    }
    
    func refresh(){
        tableView.reloadData()
    }
    
    func changeOn(){
        print("on")
        LockStatus.text = "       Locked"
        self.Switch.setOn(true, animated: true)
    }
    func changeOff(){
        print("off")
        LockStatus.text = "       Unlocked"
        self.Switch.setOn(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeOn), name: NSNotification.Name(rawValue: "on"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeOff), name: NSNotification.Name(rawValue: "off"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notConnected), name: NSNotification.Name(rawValue: "not"), object: nil)
        
        serial = BluetoothSerial(delegate: self)
        
        serial.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func notConnected() {
        LockStatus.text = "       Not Connected"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        
        
    }
    
    func serialDidChangeState() {
        if serial.centralManager.state != .poweredOn {
            dismiss(animated: true, completion: nil)
        }
    }

}
