//
//  ViewController2.swift
//  Door Unlocker
//
//  Created by Eduard Schlotter on 05/12/2016.
//  Copyright © 2016 Eduard Schlotter. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var NavBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBarToTheView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavBarToTheView() {
        let size = CGSize(width: 350, height:200)
        self.NavBar.sizeThatFits(size)
        self.NavBar.frame = CGRect(x: 0, y: 0, width: 375, height: 53)    // Here you can set you Width and Height for your navBar
        self.view.addSubview(NavBar)
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
