//
//  ViewController.swift
//  Swift_RockPaperScissors
//
//  Created by Logan McKinzie on 6/20/15.
//  Copyright (c) 2015 Logan McKinzie. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {
    
    // Outlets
    // Outlets for two tab bar buttons.
    @IBOutlet weak var findOpponent: UIBarButtonItem!
    @IBOutlet weak var readyToPlay: UIBarButtonItem!
    
    // Outlet for disconnect button.
    @IBOutlet weak var disconnectButton: UIButton!
    
    // Outlet for change username button.
    @IBOutlet weak var changeNameButton: UIButton!
    
    // Outlet for text that tells the user to connect to someone to play.
    @IBOutlet weak var connectToPlay: UILabel!
    
    // Outlets for the usernames of the user and opponent that are displayed underneath their scores.
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var opponentName: UILabel!
    
    // Outlets for boxes that contain the images for each user's choice.
    @IBOutlet weak var userChoiceBox: UIView!
    @IBOutlet weak var opponentChoiceBox: UIView!
    
    // Outlets for images that contain each user's choice.
    @IBOutlet weak var userChoiceImage: UIImageView!
    @IBOutlet weak var opponentChoiceImage: UIImageView!
    
    // Outlets for user scores.
    @IBOutlet weak var userScore: UILabel!
    @IBOutlet weak var opponentScore: UILabel!
    
    // Outlet for the text in the upper right corner that signals that the other user is ready.
    @IBOutlet weak var opponentIsReady: UILabel!
    
    // Outlets for all the countdown labels.
    @IBOutlet weak var countdownThree: UILabel!
    @IBOutlet weak var countdownTwo: UILabel!
    @IBOutlet weak var countdownOne: UILabel!
    @IBOutlet weak var countdownShoot: UILabel!
    @IBOutlet weak var countdownS: UILabel!
    
    // Outlet for the view containing the images that the user can tap to choose what they want to play.
    @IBOutlet weak var choiceView: UIView!
    
    // Outlets for the images that the user can tap to choose what they want to play.
    @IBOutlet weak var rockImage: UIImageView!
    @IBOutlet weak var paperImage: UIImageView!
    @IBOutlet weak var scissorsImage: UIImageView!
    
    // Outlet for the text displaying the user's name.
    @IBOutlet weak var displayNameText: UILabel!
    
    // Outlets for game instructions.
    @IBOutlet weak var info1: UILabel!
    @IBOutlet weak var info2: UILabel!
    @IBOutlet weak var info3: UILabel!
    
    
    // This stores the opponent's peerId.displayname.
    var opponentStoredName = ""
    var userStoredName = ""
    
    // These variables track both users' ready status.
    var readyStatus = "false"
    var opponentStatus = "false"
    
    // These ints track both users' scores.
    var userScoreInt = 0
    var opponentScoreInt = 0
    
    // These store both users' choices for that round.
    var opponentChoiceStored = "empty"
    var choice = "empty"
    
    // Count for the countdownTimer
    var count = 4
    var timer = NSTimer()
    
    
    
    // Variables for MultipeerConnectivity.
    var peerID: MCPeerID! // Our device's name, which will be seen by other browsing devices.
    var session: MCSession! // The 'connection' between devices. Basically a room with all the connected devices inside.
    var browser: MCBrowserViewController! // Prebuilt ViewController that searches for any nearby advertisers.
    var advertiser: MCAdvertiserAssistant! // This helps us easily advertise ourselves to nearby MCBrowsers.
    
    // App specific serviceID.
    let serviceID = "rps-logan-p2p"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findOpponent.enabled = false
        
        // Gives the user that name.
        peerID = MCPeerID(displayName: userStoredName)
        displayNameText.text = "Hello, \(userStoredName)!"
        
        session = MCSession(peer: peerID)
        session.delegate = self
        
        // Advertise ourself to others using the info from our MCSession.
        advertiser = MCAdvertiserAssistant(serviceType: serviceID, discoveryInfo: nil, session: session)
        advertiser.start()
        
        findOpponent.enabled = true
        
        
        // Tap gestures for the choices the user can make when playing.
        var tapGesture1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "TapGestureRock:")
        var tapGesture2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "TapGesturePaper:")
        var tapGesture3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "TapGestureScissors:")
        
        // Adds the gestures to the corresponding imageviews.
        rockImage.addGestureRecognizer(tapGesture1)
        paperImage.addGestureRecognizer(tapGesture2)
        scissorsImage.addGestureRecognizer(tapGesture3)
        
    }
    
    
    
    // MARK: - Tap Gesture Functions
    /// Tap Gesture for Rock
    func TapGestureRock (sender: UITapGestureRecognizer) {
        
        // Sets the user's choice to what they tapped.
        choice = "Rock"
        
        // Changes the image in the user's choice image to what they tapped.
        userChoiceImage.image = UIImage(named: "rock")
    }
    
    /// Tap Gesture for Paper
    func TapGesturePaper (sender: UITapGestureRecognizer) {
        
        choice = "Paper"
        userChoiceImage.image = UIImage(named: "paper")
    }
    
    /// Tap Gesture for Scissors
    func TapGestureScissors (sender: UITapGestureRecognizer) {
        
        choice = "Scissors"
        userChoiceImage.image = UIImage(named: "scissors")
    }
    
    
    
    // MARK: - Countdown Function
    /// This functions manages the actions that occur when the countdown for the game starts.
    func countTimer () {
        
        switch count {
        case 4:
            countdownThree.hidden = false
            --count
        case 3:
            countdownTwo.hidden = false
            --count
        case 2:
            countdownOne.hidden = false
            --count
        case 1:
            countdownThree.hidden = true
            countdownTwo.hidden = true
            countdownOne.hidden = true
            countdownS.hidden = false
            --count
        case 0:
            // These hide all the countdown items and choice images.
            rockImage.hidden = true
            paperImage.hidden = true
            scissorsImage.hidden = true
            countdownS.hidden = true
            
            if let data = choice.dataUsingEncoding(NSUTF8StringEncoding) {
                
                // Sends our choice to our peer.
                session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: nil)
            }
            
            timer.invalidate()
            count = 4

        default:
            println("Something did a bad during the countdown.")
        }
    }
    
    
    
    // MARK: - Decide Winner Function
    /// This is called when the countdown is totally finished and both users have received data from each other.
    func decideWinner () {
        
        // Unhides the text that will show if the user won or not.
        countdownShoot.hidden = false
        
        // Switch statement for the opponent's choice.
        switch opponentChoiceStored {
        case "Rock":
            // Set the opponent's choice image to what they chose.
            self.opponentChoiceImage.image = UIImage(named: "rock")
            
            // If statement that checks the user's own choice and determines if the round was a tie, if the user won, or if the user lost.
            if choice == "Rock" {
                countdownShoot.text = "Tie!"
                
            } else if choice == "Paper" {
                countdownShoot.text = "Winner!"
                userScore.text = (++userScoreInt).description
                
            } else if choice == "Scissors" {
                countdownShoot.text = "Loser!"
                opponentScore.text = (++opponentScoreInt).description
                
                // If the user doesn't make a choice, we punish them for it.
            } else if choice == "empty" {
                countdownShoot.text = "You didn't choose."
                opponentScore.text = (++opponentScoreInt).description
            }
            
        case "Paper":
            self.opponentChoiceImage.image = UIImage(named: "paper")
            
            if choice == "Rock" {
                countdownShoot.text = "Loser!"
                opponentScore.text = (++opponentScoreInt).description
                
            } else if choice == "Paper" {
                countdownShoot.text = "Tie!"
                
            } else if choice == "Scissors" {
                countdownShoot.text = "Winner!"
                userScore.text = (++userScoreInt).description
                
            }  else if choice == "empty" {
                countdownShoot.text = "You didn't choose."
                opponentScore.text = (++opponentScoreInt).description
            }
            
        case "Scissors":
            self.opponentChoiceImage.image = UIImage(named: "scissors")
            
            if choice == "Rock" {
                countdownShoot.text = "Winner!"
                userScore.text = (++userScoreInt).description
                
            } else if choice == "Paper" {
                countdownShoot.text = "Loser!"
                
                opponentScore.text = (++opponentScoreInt).description
            } else if choice == "Scissors" {
                countdownShoot.text = "Tie!"
                
            }  else if choice == "empty" {
                countdownShoot.text = "You didn't choose."
                opponentScore.text = (++opponentScoreInt).description
            }
            
        default:
            println("Something went wrong.")
        }
        
        // Reset the users' ready statuses and reenable the ready to play button, allowing the user's to replay the game.
        readyStatus = "false"
        opponentStatus = "false"
        readyToPlay.enabled = true
    }
    
    
    
    // MARK: - Ready To Play Function
    /// This is called when both players are ready to play.
    func readyUp () {
        
        // Closes the keyboard if the user left it up.
        view.endEditing(true)
        
        // Changes the userName text underneath the user's score to their name.
        userName.text = peerID.displayName
        
        // Here we change the opponent name under the score to match the connected peer.
        opponentName.text = "\(opponentStoredName)"
        
        // Disables the find opponent button, because we don't need to find an opponent anymore.
        findOpponent.enabled = false
        
        // In the rest of this function we hide and unhide many pieces of the UI in order to transition the game from connecting to someone to playing with someone, and to reset the game if the users want to play again.
        // Here we make sure the choice images are unhidden.
        rockImage.hidden = false
        paperImage.hidden = false
        scissorsImage.hidden = false
        
        // This rehides the winner/loser/tied text.
        countdownShoot.hidden = true
        
        // These reset the users' choices.
        opponentChoiceStored = "empty"
        choice = "empty"
        
        // These hide everything related to choosing a username.
        connectToPlay.hidden = true
        displayNameText.hidden = true
        info1.hidden = true
        info2.hidden = true
        info3.hidden = true
        
        // These unhide the usernames underneath the score.
        userName.hidden = false
        opponentName.hidden = false
        
        // These unhide the choice boxes containing images the users choose.
        userChoiceBox.hidden = false
        opponentChoiceBox.hidden = false
        
        // These unhide the choice boxes' images that the users choose.
        userChoiceImage.image = nil
        opponentChoiceImage.image = nil
        
        // These unhide the users' scores.
        userScore.hidden = false
        opponentScore.hidden = false
        
        // This unhides the view that contains the three choices for each user.
        choiceView.hidden = false
        
        // Removes any text from the winner/loser/tied text label.
        countdownShoot.text = ""
        
        // Removes the change username button.
        changeNameButton.hidden = true
        
        // Starts the countdown timer.
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "countTimer", userInfo: nil, repeats: true)
    }
    
    
    
    // MARK: - IBActions
    /// This action runs when the user taps the disconnect button.
    @IBAction func disconnect(sender: UIButton) {
        session.disconnect()
        self.advertiser.start()
    }
    
    /// This actions runs when the user taps the change username button. It takes them back to the first view controller.
    @IBAction func changeUsername(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        session.disconnect()
        self.advertiser.stop()
    }
    
    /// This action is run when the user taps the find opponent button.
    @IBAction func findOpponentAction(sender: UIBarButtonItem) {
        
        // Checks if we have a session.
        if session != nil {
            
            // This sets the browser to search for advertisers that share the same serviceID.
            browser = MCBrowserViewController(serviceType: serviceID, session: session)
            browser.delegate = self
            
            // Presents the view controller that allows the user to find a peer.
            self.presentViewController(browser, animated: true, completion: nil)
            
        }
    }
    
    /// This action is run when the user taps the ready to play button.
    @IBAction func readyToPlayAction(sender: UIBarButtonItem) {
        
        // Since the user is ready to play, we disable the find opponent button to prevent them from finding another opponent and interrupting the session.
        readyToPlay.enabled = false
        
        // Set's the user's ready status to true.
        readyStatus = "true"
        
        // Sends the ready status of this user to their opponent.
        if let data = readyStatus.dataUsingEncoding(NSUTF8StringEncoding) {
            
            session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: nil)
        }
        
        // Now we check if both users are ready to play, and if they are we run the readyup function. If not, we will check again when we recieve data from the other user.
        if opponentStatus == "true" && readyStatus == "true" {
            readyUp()
        }
    }
    
    
    
    // MARK: - MCBrowserControllerDelegate
    // Whether or not the user found an opponent, we dismiss the view when they either finish or cancel, just to make sure it goes away.
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
        browserViewController.dismissViewControllerAnimated(true, completion: {})
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
        browserViewController.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    
    // MARK: - MCSessionDelegate
    // Remote peer changed state.
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        
        // This method fires when connections are made or dropped.
        dispatch_async(dispatch_get_main_queue(), {
            if state == MCSessionState.Connected {
                if session.connectedPeers.count == 1 {
                    
                    // Once we have connected to one user, we stop advertising ourselves.
                    self.advertiser.stop()
                    
                    self.disconnectButton.enabled = true
                    
                    self.connectToPlay.text = "Connected to \(peerID.displayName)"
                    
                    self.opponentStoredName = peerID.displayName
                    
                    self.opponentIsReady.text = "\(self.opponentStoredName) is not ready."
                    
                    // Now that we have an opponent, we enable the ready to play button.
                    self.findOpponent.enabled = false
                    self.opponentIsReady.hidden = false
                    self.readyToPlay.enabled = true
                    self.info1.hidden = false
                    self.info2.hidden = false
                    self.info3.hidden = false
                }
                
            } else if state == MCSessionState.Connecting {
                self.connectToPlay.text = "Connecting to opponent..."
                
            } else if state == MCSessionState.NotConnected {
                // Here we do some stuff when we get disconnected from the other user. Mostly just hiding and unhiding views until the UI looks like it did before we connected to anyone. We also reset any info related to the game.
                self.connectToPlay.text = "Connect with someone to play! Just tap the find opponent button in the top right."
                
                self.readyToPlay.enabled = false
                self.findOpponent.enabled = true
                self.disconnectButton.enabled = false
                
                self.opponentIsReady.hidden = true
                
                self.connectToPlay.hidden = false
                
                self.userName.hidden = true
                self.opponentName.hidden = true
                
                self.userChoiceBox.hidden = true
                self.opponentChoiceBox.hidden = true
                
                self.userScore.hidden = true
                self.opponentScore.hidden = true
                
                self.displayNameText.hidden = false
                
                self.choiceView.hidden = true
                
                self.countdownShoot.hidden = true
                
                self.countdownShoot.text = ""
                self.userScoreInt = 0
                self.opponentScoreInt = 0
                self.userScore.text = "0"
                self.opponentScore.text = "0"
                
                self.changeNameButton.hidden = false
                
                self.info1.hidden = true
                self.info2.hidden = true
                self.info3.hidden = true
                
            } else {
                fatalError("ERROR")
            }})
    }
    
    // This fires when we have received data from a remote peer.
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        
        // This tries to decode the NSData object into a string.
        if let data: String = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
            
            // Here we check if that info is "true", meaning it is related to the ready status.
            if data == "true" {
                
                // If it is "true", we dispatch to the main thread to perform some UI updates.
                dispatch_async(dispatch_get_main_queue(), {
                    
                    // Here we change the text in the upper right corner of the screen to inform the user their opponent is ready.
                    self.opponentIsReady.text = "\(self.opponentStoredName) is ready!"
                    self.opponentStatus = "true"
                    
                    // Now we check if both users are ready to play, and if they are we run the readyup function. If not, we will check again when we send data to the other user.
                    if self.opponentStatus == "true" && self.readyStatus == "true" {
                        self.readyUp()
                    }
                })
                
                // If the data isn't equal to "true", then we can assume it is related to a choice the user made during the countdown, as this is the only other time they can send data.
            } else {
                
                // This switch statement checks if the opponent chose rock, paper, or scissors.
                switch data {
                case "Rock":
                    
                    // This stores what the opponent choose to a variable, and then dispatches to the main thread to decide a winner. We do this because when we decide a winner we perform a lot of UI updates.
                    self.opponentChoiceStored = "Rock"
                    dispatch_async(dispatch_get_main_queue(), {
                        self.decideWinner()
                    })
                    
                case "Paper":
                    self.opponentChoiceStored = "Paper"
                    dispatch_async(dispatch_get_main_queue(), {
                        self.decideWinner()
                    })
                    
                case "Scissors":
                    self.opponentChoiceStored = "Scissors"
                    dispatch_async(dispatch_get_main_queue(), {
                        self.decideWinner()
                    })
                    
                case "empty":
                    // This case is only hit if the opponent chose nothing before time ran out. Then we check if both users chose nothing, or if only one of them did it. If only one of them did it, we punish them by giving their opponent a point.
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.countdownShoot.hidden = false
                        if self.choice == "empty" {
                            self.countdownShoot.text = "No one choose."
                            self.readyStatus = "false"
                            self.opponentStatus = "false"
                            self.readyToPlay.enabled = true
                            
                        } else {
                            self.countdownShoot.text = "They didn't choose."
                            self.userScore.text = (++self.userScoreInt).description
                            self.readyStatus = "false"
                            self.opponentStatus = "false"
                            self.readyToPlay.enabled = true
                        }
                    })
                    
                default:
                    println("Something broke.")
                }
                
                // After all of this, we change the ready statuses back to false so the users can replay.
                dispatch_async(dispatch_get_main_queue(), {
                    self.opponentIsReady.text = "\(self.opponentStoredName) is not ready."
                    self.opponentStatus = "false"
                })
            }
        }
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
    }
}

