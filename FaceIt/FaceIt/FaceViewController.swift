//
//  ViewController.swift
//  FaceIt
//
//  Created by Mao on 24/10/2016.
//  Copyright © 2016 cdts. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale(_:))))
            let happierSwipeGestureRecongnizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappiness))
            happierSwipeGestureRecongnizer.direction = .Up
            faceView.addGestureRecognizer(happierSwipeGestureRecongnizer)
            let sadderSwipeGestureRecongnizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappiness))
            sadderSwipeGestureRecongnizer.direction = .Down
            faceView.addGestureRecognizer(sadderSwipeGestureRecongnizer)
            updateUI()
        }
    }
    
    @IBAction func toggleEyes(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            switch expression.eyes {
            case .Open:
                expression.eyes = .Closed
            case .Closed:
                expression.eyes = .Open
            case .Squinting: 
                break
            }
        }
    }
    private struct Animation {
        static let ShakeAngle = CGFloat(M_PI/6)
        static let ShakeDuration = 0.5
    }
    @IBAction func headShake(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(
            Animation.ShakeDuration,
            animations: { 
                self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, Animation.ShakeAngle)
            }) { finished in
                UIView.animateWithDuration(
                    Animation.ShakeDuration,
                    animations: {
                        self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, -Animation.ShakeAngle*2)
                }) { finished in
                    UIView.animateWithDuration(
                        Animation.ShakeDuration,
                        animations: {
                            self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, Animation.ShakeAngle)
                    }) { finished in
                    }
                }
        }
    }
    func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    private let mouthCurvatures = [ FacialExpression.Mouth.Frown: -1.0, .Grin: 0.5, .Smile: 1.0, .Smirk: -0.5, .Neutral: 0.0 ]
    private let eyeBrowTilts = [ FacialExpression.EyeBrows.Relaxed: 0.5, .Furrowed: -0.5, .Normal: 0.0 ]
    
    var expression: FacialExpression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile) {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateUI() {
        if faceView != nil {
            switch expression.eyes {
            case .Open:
                faceView.eyeOpen = true
            case .Closed:
                faceView.eyeOpen = false
            case .Squinting:
                faceView.eyeOpen = false
            }
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
    }


}

