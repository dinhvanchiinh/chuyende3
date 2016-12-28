//
//  MainViewController.swift
//  Add 1
//
//  Created by Reinder de Vries on 11-06-15.
//  Copyright (c) 2015 LearnAppMaking. All rights reserved.
//

import UIKit
import MBProgressHUD

class MainViewController: UIViewController
{
    @IBOutlet weak var numbersLabel:UILabel?
    @IBOutlet weak var scoreLabel:UILabel?
    @IBOutlet weak var inputField:UITextField?
    @IBOutlet weak var timeLabel:UILabel?
    
    var score:Int = 0
    var timer:Timer?
    var seconds:Int = 60
    
    var hud:MBProgressHUD?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setRandomNumberLabel()
        updateScoreLabel()
        updateTimeLabel()
        
        hud = MBProgressHUD(view:self.view)
        
        if(hud != nil)
        {
            self.view.addSubview(hud!)
        }
        
        inputField?.addTarget(self, action: #selector(textFieldDidChange(textField:)), for:UIControlEvents.editingChanged)
    }
    
    func textFieldDidChange(textField:UITextField)
    {
        if inputField?.text?.characters.count ?? 0 < 7
        {
            return
        }
        
        if  let numbers_text    = numbersLabel?.text,
            let input_text      = inputField?.text,
            let numbers         = String(numbers_text),
            let input           = String(input_text)
        {
            var result = ""
            var dem: Int = 0
            var temp: Int = 0;
            var array = ["student", "evening", "morning", "chicken", "monitor", "article", "success"]
            for item in array{
                if input == item {
                    dem = dem + 1
                }
            }
            if(dem == 1)
            {
                print("Correct!")
                
                score += 1
                
                showHUDWithAnswer(isRight: true)
            }
            else
            {
                print("Incorrect!")
                
                score -= 1
                
                showHUDWithAnswer(isRight: false)
            }
        }
        
        setRandomNumberLabel()
        updateScoreLabel()
        
        if(timer == nil)
        {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector:#selector(onUpdateTimer), userInfo:nil, repeats:true)
        }
    }
    
    func onUpdateTimer()
    {
        if(seconds > 0 && seconds <= 60)
        {
            seconds -= 1
            
            updateTimeLabel()
        }
        else if(seconds == 0)
        {
            if(timer != nil)
            {
                timer!.invalidate()
                timer = nil
                
                let alertController = UIAlertController(title: "Time Up!", message: "Your time is up! You got a score of: \(score) points. Very good!", preferredStyle: .alert)
                let restartAction = UIAlertAction(title: "Restart", style: .default, handler: nil)
                alertController.addAction(restartAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                score = 0
                seconds = 60
                
                updateTimeLabel()
                updateScoreLabel()
                setRandomNumberLabel()
            }   
        }  
    }
    
    func updateTimeLabel()
    {
        if(timeLabel != nil)
        {
            let min:Int = (seconds / 60) % 60
            let sec:Int = seconds % 60
            
            let min_p:String = String(format: "%02d", min)
            let sec_p:String = String(format: "%02d", sec)
            
            timeLabel!.text = "\(min_p):\(sec_p)"
        }
    }
    
    func showHUDWithAnswer(isRight:Bool)
    {
        var imageView:UIImageView?
        
        if isRight
        {
            imageView = UIImageView(image: UIImage(named:"thumbs-up"))
        }
        else
        {
            imageView = UIImageView(image: UIImage(named:"thumbs-down"))
        }
        
        if(imageView != nil)
        {
            hud?.mode = MBProgressHUDMode.customView
            hud?.customView = imageView
            
            hud?.show(animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.hud?.hide(animated: true)
                self.inputField?.text = ""
            }
        }
    }
    
    func updateScoreLabel()
    {
        scoreLabel?.text = "\(score)"
    }
    func generateWord() -> String
    {
                var word: String = ""
                var array = ["student", "evening", "morning", "chicken", "monitor", "article", "success"]
                let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
                word = array[randomIndex]
                return word

    }
    //let str = generateWord()
    func setRandomNumberLabel()
    {
        numbersLabel?.text = generateRandomNumber()
    }
    
    func generateRandomNumber() -> String
    {
        var str: String = ""
        var array = ["student", "evening", "morning", "chicken", "monitor", "article", "success"]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        str = array[randomIndex]
        var chars = str.characters.map{ $0 }
        let c = UInt32(chars.count)
        if c < 2 { return str}
        
        for i in 0..<(c - 1) {
            let j = arc4random_uniform(c)
            if i != j {
                swap(&chars[Int(i)], &chars[Int(j)])
            }
        }
        return chars.reduce("", { (str, c) -> String in
            str + String(c)
        })
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
