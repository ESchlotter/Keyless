//
//  ChangePinController.swift
//  Door Unlocker
//
//  Created by Eduard Schlotter on 06/03/2017.
//  Copyright © 2017 Eduard Schlotter. All rights reserved.
//

import UIKit
import MessageUI
import CoreBluetooth

class ChangePinController: UIViewController, UITextFieldDelegate {

    @IBOutlet var newPin: UITextField!
    @IBOutlet var sendButton: UIButton!

    
    @IBAction func Send(_ sender: UIButton) {
        if(newPin.text?.characters.count == 5){
            let pin = newPin.text
            serial.sendMessageToDevice("\(pin!)")
            print(pin!)
            newPin.text = ""
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        newPin.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 5
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
