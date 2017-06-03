
import UIKit
import CoreBluetooth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BluetoothSerialDelegate {
        
        
        var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
        
        /// The peripheral the user has selected
        var selectedPeripheral: CBPeripheral?
        
        var window: UIWindow?
        
        
        class AppDelegate: UIResponder, UIApplicationDelegate {
        }
        
        func applicationWillResignActive(_ application: UIApplication) {
            serial.delegate = self
            if serial.centralManager.state != .poweredOn {
                return
            }
            
            // start scanning and schedule the time out
            serial.startScan()
            
            // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
            // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        }
        
        func applicationDidEnterBackground(_ application: UIApplication) {
            while(true){
                if(!serial.isReady){return}
                serial.startScan()
                if(serial.connectedPeripheral != nil){
                    serial.sendMessageToDevice("11")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "off"), object: nil)
                    let message = "Homeowner Unlocked"
                    let formatter = DateFormatter()
                    // initially set the format based on your datepicker date
                    formatter.dateFormat = "HH:mm - "
                    var myString = formatter.string(from: Date())
                    myString += message
                    print(myString)
                    logs.insert(myString, at: 0)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                    return
                }
            }
            
            // start scanning and schedule the time out
            
            // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
            // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        }
        
        func applicationWillEnterForeground(_ application: UIApplication) {
            if serial.centralManager.state != .poweredOn {
                return
            }
            
            // start scanning and schedule the time out
            serial.startScan()
            // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        }
        
        func applicationDidBecomeActive(_ application: UIApplication) {

            // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        }
        
        func applicationWillTerminate(_ application: UIApplication) {
            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        }
        
        func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "not"), object: nil)
            peripherals = []
        }
        func serialDidChangeState() {
            
            if serial.centralManager.state != .poweredOn {
                print("oops")
            }
        }
        
        func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
            print(peripherals)
            // check whether it is a duplicate
            for exisiting in peripherals {
                if exisiting.peripheral.identifier == peripheral.identifier { return }
            }
            
            // add to the array, next sort & reload
            let theRSSI = RSSI?.floatValue ?? 0.0
            peripherals.append(peripheral: peripheral, RSSI: theRSSI)
            peripherals.sort { $0.RSSI < $1.RSSI }
            print(peripherals)
            if(peripheral.name=="MLT-BT05"){
                selectedPeripheral = peripheral
                serial.connectToPeripheral(selectedPeripheral!)
            }
        }
    
    func serialIsReady(_ peripheral: CBPeripheral) {
        print("Ready")
    }
    
    func serialDidReceiveString(_ message: String) {
        
        if(message.contains("Temporary Unlocked") || message.contains("Keypad Unlocked")){
            print("Unlocked")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "off"), object: nil)//send notification
        }
        
        else if(message.contains("Keypad Locked")){
            print("Locked")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "on"), object: nil)//send notification
        }
        
        // add the received text to the textView, optionally with a line break at the end
        if (message.characters.count > 5){
            print(message)
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date
            formatter.dateFormat = "HH:mm - "
            var myString = formatter.string(from: Date())
            myString += message
            print(myString)
            logs.insert(myString, at: 0)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }
        print(message.characters.count)
    }
    

    
}


