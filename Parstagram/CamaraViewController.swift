//
//  CamaraViewController.swift
//  Parstagram
//
//  Created by RAUL RIVERO RUBIO on 3/5/20.
//  Copyright © 2020 codepath-cit238b-spring2020. All rights reserved.
//

import UIKit

class CamaraViewController: UIViewController, UIImagePickerControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitEvent(_ sender: Any) {
        
    }
    
    @IBAction func cameraEvent(_ sender: Any) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
