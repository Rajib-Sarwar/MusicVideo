//
//  MusicDetailViewController.swift
//  MusicVideo
//
//  Created by Ayon Chowdhury on 3/30/16.
//  Copyright © 2016 Ayon Chowdhury. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import LocalAuthentication

class MusicDetailViewController: UIViewController {

    var videos: Videos!
    
    var securitySwitch: Bool = false
    
    @IBOutlet weak var vName: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var vGenre: UILabel!
    @IBOutlet weak var vPrice: UILabel!
    @IBOutlet weak var vRights: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = videos.vArtist
        vName.text = videos.vName
        vPrice.text = videos.vPrice
        vGenre.text = videos.vGenre
        vRights.text = videos.vRights
        
        if videos.vImageData != nil {
            videoImage.image = UIImage(data: videos.vImageData!)
        }else {
            videoImage.image = UIImage(named: "imageNotAvailable")
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredFontChange", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    func preferredFontChange() {
        vName.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        vPrice.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        vGenre.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        vRights.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    
    @IBAction func socialMedia(sender: UIBarButtonItem) {
        securitySwitch = NSUserDefaults.standardUserDefaults().boolForKey("SecSetting")
        
        switch securitySwitch {
        case true:
            touchIdCheck()
        default:
            shareMedia()
        }
    }
    
    func touchIdCheck() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Cancel, handler: nil))
    
        let context = LAContext()
        var touchIDError : NSError?
        let reasonString = "Touch-Id authentication is needed to share info on Social Media"
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &touchIDError) {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, policyError) -> Void in
                if success {
                    dispatch_async(dispatch_get_main_queue()) {
                    [unowned self] in
                        self.shareMedia()
                    }
                } else {
                    alert.title = "Unsuccessful !"
                    
                    switch LAError(rawValue: policyError!.code)! {
                    case .AppCancel:
                        alert.message = "Authentication was cancelled by application"
                    case .AuthenticationFailed:
                        alert.message = "The user failed to provide valid credentials"
                    case .PasscodeNotSet:
                        alert.message = "Passcode is not set on the device"
                    case .SystemCancel:
                        alert.message = "Authentication was cancelled by the system"
                    case .TouchIDLockout:
                        alert.message = "Too many failed attempts"
                    case .UserFallback:
                        alert.message = "Password not accepted, must use Touch-ID"
                        
                    default:
                        alert.message = "Unable to Authenticate"
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        [unowned self] in
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            })
        } else {
            alert.title = "Error"
            
            switch LAError(rawValue: touchIDError!.code)! {
            case .TouchIDNotEnrolled:
                alert.message = "Touch ID is not enrolled"
            case .TouchIDNotAvailable:
                alert.message = "TouchId is not available on the device"
            case .PasscodeNotSet:
                alert.message = "Passcode has not been set"
            case .InvalidContext:
                alert.message = "The context is invalid"
                
            default:
                alert.message = "Local Authentication not available"
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                [unowned self] in
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func playVideo(sender: UIBarButtonItem) {
        let url = NSURL(string: videos.vVideoUrl)!
        
        let player = AVPlayer(URL: url)
        
        let playerViewController = AVPlayerViewController()
        
        playerViewController.player = player
        
        self.presentViewController(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
    
    func shareMedia() {
        let activity1 = "Have you had the opportunity to see this Music Video?"
        let activity2 = ("\(videos.vName) by \(videos.vArtist)")
        let activity3 = "Watch it and tell me what you think?"
        let activity4 = videos.vLinkToiTunes
        let activity5 = "(Shared with the Music Video App - Step It UP!)"
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [activity1, activity2, activity3, activity4, activity5], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            
            if activity == UIActivityTypeMail {
                print("email selected")
            }
        }
        
        presentViewController(activityViewController, animated: true, completion: nil)
    }
}
