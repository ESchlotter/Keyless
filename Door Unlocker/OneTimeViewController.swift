//
//  OneTimeViewController.swift
//  Door Unlocker
//
//  Created by Eduard Schlotter on 05/12/2016.
//  Copyright © 2016 Eduard Schlotter. All rights reserved.
//

import UIKit
import MessageUI

class OneTimeViewController: UIViewController, MFMessageComposeViewControllerDelegate, UITextFieldDelegate {

    @IBOutlet var Send: UIButton!
    
    @IBOutlet var Phone: UITextField!
    
    @IBOutlet var FourDigits: UITextField!
    
    @IBAction func Action(_ sender: UIButton) {
        let messageVC = MFMessageComposeViewController()
        let number = Phone.text
        let myVar: String=String(fourUniqueDigits)
        messageVC.body = "Use this code for the keypad "+myVar+" followed by the last 4 digits of the tracking number.";
        messageVC.recipients = [number!]
        messageVC.messageComposeDelegate = self;
        
        self.present(messageVC, animated: false, completion: nil)
        
        
    }
   
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result.rawValue {
        case 0:
            //controller.present(ViewController2(), animated: true, completion: nil)
            print("message cancelled")
            controller.dismiss(animated: true, completion: nil)
            
        case 1 :
            print("message failed")
            controller.dismiss(animated: true, completion: nil)
            
        case 2 :
            print("message sent")
            controller.dismiss(animated: true, completion: nil)
            
        default:
            break
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        FourDigits.delegate = self
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var fourUniqueDigits: String {
        var result = ""
        repeat {
            // create a string with up to 4 leading zeros with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
            // generate another random number if the set of characters count is less than four
        } while Set<Character>(result.characters).count < 4
        return result    // ran 5 times
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 4
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
