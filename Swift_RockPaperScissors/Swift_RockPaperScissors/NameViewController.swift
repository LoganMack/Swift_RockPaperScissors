//
//  NameViewController.swift
//  Swift_RockPaperScissors
//
//  Created by Logan McKinzie on 6/25/15.
//  Copyright (c) 2015 Logan McKinzie. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    
    var username = ""
    
    // Random names for users that do not bother to enter a username.
    let randomNames: [String] = ["RPS", "HUMAN", "ROCK", "PAPER", "SCISSORS", "USER", "PLAYER", "PRO", "RANDOM", "DUDE", "BAT", "SNOW", "GLORY", "GUNS", "MYSTERY", "TARGET", "MONSTER", "THATSNOMOON"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
        let vc = (segue.destinationViewController as! UINavigationController).topViewController as! ViewController
        
        // Pass the username to the new view controller.
        vc.userStoredName = username
        
    }
    
    /// Creates a username for the user, either with text they entered or with a random name.
    @IBAction func confirmName(sender: UIButton) {
        if usernameField.text.isEmpty {
            
            // Chooses a random name for the user.
            var randomName = Int(arc4random_uniform(UInt32(randomNames.count)))
            
            // Gives the user that name.
            username = "\(randomNames[randomName])\(arc4random_uniform(UInt32(999)))"
            
        } else {
            username = usernameField.text
        }
    }
}
