//
//  ViewController.swift
//  Project Keyless
//
//  Created by Eduard Schlotter on 04/12/2016.
//  Copyright © 2016 Eduard Schlotter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var NavBar: UINavigationBar!
    
    @IBOutlet weak var Label: UINavigationItem!
    
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
        self.NavBar.backgroundColor = UIColor.white
        self.view.addSubview(NavBar)
    }

}

