//
//  ViewController.swift
//  AnimationLab
//
//  Created by Andy (Liang) Dong on 9/16/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var trayArrowImageView: UIImageView!
    
    var trayOriginalCenter: CGPoint!
    var trayViewUpY: CGFloat?
    var trayViewDownY: CGFloat?
    
    var newlyCreatedFace: UIImageView!
    var originFaceCenter: CGPoint!
    var customFace: UIImageView!
    var customFaceCenter: CGPoint!
    
    @IBAction func onPanTrayView(sender: UIPanGestureRecognizer) {
        var point = sender.locationInView(trayView)
        var velocity = sender.velocityInView(trayView)
        var translation = sender.translationInView(trayView)
        
        if sender.state == UIGestureRecognizerState.Began {
            println("Gesture began at: \(point)")
            trayOriginalCenter = trayView.center
        } else if sender.state == UIGestureRecognizerState.Changed {
            println("Gesture changed at: \(point)")
            let newUpY = trayOriginalCenter.y + translation.y
            if newUpY < self.trayViewUpY! {
                trayView.center = CGPoint(x: trayOriginalCenter.x, y: self.trayViewUpY!)
            } else {
                trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            }
        } else if sender.state == UIGestureRecognizerState.Ended {
            println("Gesture ended at: \(point)")
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                if velocity.y > 0 {
                    print("move down")
                    self.trayView.center = CGPoint(x: self.trayOriginalCenter.x, y: self.trayViewDownY!)
                    self.trayArrowImageView.transform =
                        CGAffineTransformMakeRotation(CGFloat(M_PI))
                } else {
                    print("move up")
                    self.trayView.center = CGPoint(x: self.trayOriginalCenter.x, y: self.trayViewUpY!)
                    self.trayArrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(0))
                }

            })
        }
    }
   

    @IBAction func onPanFaces(sender: UIPanGestureRecognizer) {
        var point = sender.locationInView(trayView)
        var translation = sender.translationInView(trayView)

        if sender.state == UIGestureRecognizerState.Began {
            var imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            newlyCreatedFace.userInteractionEnabled = true
            
            var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            var pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "onCustomPinch:")
            pinchGestureRecognizer.delegate = self
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            var rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: "onCustomRotate:")
            newlyCreatedFace.addGestureRecognizer(rotationGestureRecognizer)
            var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onCustomDoubleTap:")
            tapGestureRecognizer.numberOfTapsRequired = 2
            newlyCreatedFace.addGestureRecognizer(tapGestureRecognizer)
            
            view.addSubview(newlyCreatedFace)
            originFaceCenter = imageView.center
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
        } else if sender.state == UIGestureRecognizerState.Changed {
            newlyCreatedFace.center = CGPoint(x: originFaceCenter.x + translation.x,
                y: originFaceCenter.y + translation.y + trayView.frame.origin.y)
        } else if sender.state == UIGestureRecognizerState.Ended {
            
        }
    }
    
    @IBAction func onCustomPan(sender: UIPanGestureRecognizer) {
        var point = sender.locationInView(view)
        var translation = sender.translationInView(view)

        
        if sender.state == UIGestureRecognizerState.Began {
            customFace = sender.view as! UIImageView
            customFaceCenter = customFace.center
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                 self.customFace.transform = CGAffineTransformMakeScale(1.25, 1.25)
            })
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            customFace.center = CGPoint(x: customFaceCenter.x + translation.x,
                y: customFaceCenter.y + translation.y )
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.customFace.transform = CGAffineTransformMakeScale(1, 1 )
            })
        }

    }
    
    @IBAction func onCustomPinch(sender: UIPinchGestureRecognizer) {
        customFace = sender.view as! UIImageView
        let scale = sender.scale
        customFace.transform = CGAffineTransformMakeScale(scale, scale)
    }
    
    @IBAction func onCustomRotate(sender: UIRotationGestureRecognizer){
        sender.view!.transform = CGAffineTransformRotate(sender.view!.transform, sender.rotation)
    }
    
    @IBAction func onCustomDoubleTap(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        trayViewUpY =  CGFloat(560)
        trayViewDownY = CGFloat(745)
        
       
      }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

