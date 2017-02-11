//
//  MoviesNavigationController.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 2/9/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit

class MoviesNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let switchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "segueIconSmall"), style: .plain, target: self, action: #selector(MoviesViewController.onSwitch(_:)))
        navigationItem.rightBarButtonItem = switchButton
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
