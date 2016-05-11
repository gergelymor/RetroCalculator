//
//  ViewController.swift
//  Retro Calculator
//
//  Created by Gergely Mor Bacskai on 30/04/16.
//  Copyright © 2016 bgm. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String{
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outputlbl: UILabel!
    var btnSound: AVAudioPlayer!
    var runningNumber = ""
    var leftSideStr = ""
    var rightSideStr = ""
    var currentOperation: Operation = Operation.Empty
    var result = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: path!)
        do{
            try btnSound = AVAudioPlayer(contentsOfURL: soundURL)
            btnSound.prepareToPlay()
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    @IBAction func numberPressed(btn:UIButton!){
        playSound()
        if String(runningNumber).characters.count < 15 {
            if btn.tag != 0 || outputlbl.text != "0"{
                runningNumber += "\(btn.tag)"
                outputlbl.text = runningNumber
            }
        }
    }
    
    @IBAction func onClearPressed(sender: UIButton) {
        playSound()
        rightSideStr = ""
        leftSideStr = ""
        runningNumber = ""
        currentOperation = Operation.Empty
        outputlbl.text = "0"
        result = ""
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(Operation.Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(Operation.Multiply )
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(Operation.Subtract)
    }
    
    @IBAction func onAdditonPressed(sender: AnyObject) {
        processOperation(Operation.Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        //isEqualPressedNow = true
        processOperation(currentOperation)
    }
    
    func processOperation(op: Operation){
        playSound()
        if currentOperation != Operation.Empty{
            
            //pressing operation after another operation 
            if runningNumber != ""{
                rightSideStr = runningNumber
                runningNumber = ""
                if leftSideStr == ""{
                    leftSideStr = "0"
                }
                
                if currentOperation == Operation.Multiply{
                    result = "\(Double(leftSideStr)! * Double(rightSideStr)!)"
                }
                else if currentOperation == Operation.Divide{
                    result = "\(Double(leftSideStr)! / Double(rightSideStr)!)"
                }
                else if currentOperation == Operation.Subtract{
                    result = "\(Double(leftSideStr)! - Double(rightSideStr)!)"
                }
                else if currentOperation == Operation.Add{
                    result = "\(Double(leftSideStr)! +  Double(rightSideStr)!)"
                }
                
                if result.characters.count>16{
                    result = result[result.startIndex.advancedBy(0)...result.startIndex.advancedBy(14)]
                }
                leftSideStr = result
                outputlbl.text = result

            }
            currentOperation = op
        }
        else{
            leftSideStr = runningNumber
            runningNumber = ""
            currentOperation = op
        }
    }
    
    func playSound(){
        if btnSound.playing{
            btnSound.stop()
        }
        btnSound.play()
    }

}

