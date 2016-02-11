//
//  SettingsViewController.swift
//  GithubDemo
//
//  Created by Christine Hong on 2/10/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import Foundation

@objc protocol SettingsViewControllerDelegate {
    optional func minimumStars(minStars: Int)
}

class SettingsViewController: UIViewController {
    weak var delegate: SettingsViewControllerDelegate?

    @IBOutlet weak var numStarLabel: UILabel!
    var sliderVal: Int!
    @IBOutlet weak var starSlider: UISlider!
    @IBAction func minStarValueChanged(sender: AnyObject) {
        self.sliderVal = Int(round(self.starSlider.value * 100000))
        self.numStarLabel.text = "\(sliderVal)"
    }
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)

    }
    @IBAction func onSaveButton(sender: AnyObject) {
        delegate?.minimumStars!(self.sliderVal)
        dismissViewControllerAnimated(true, completion: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print ("Segue")
    }


}
