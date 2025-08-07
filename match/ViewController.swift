//
//  ViewController.swift
//  match
//
//  Created by Yerman Ibragimuly on 07.08.2025.
//

import UIKit

class ViewController: UIViewController {
    
    var images = ["1", "2", "3", "4", "5", "6", "7", "8", "1", "2", "3", "4", "5", "6", "7", "8"]
    
    var state = [Int](repeating: 0, count: 16)
    
    var isActive = false
    
    var countSteps = 0
    
    var gameTimer: Timer?
    
    var secondsElapsed = 0
    
    @IBOutlet var labelMoves: UILabel!
    
    @IBOutlet var labelTimer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images.shuffle()
        startGameTimer()
        labelMoves.text = "Ходы: \(countSteps)"
        
    }
    
    @IBAction func game(_ sender: UIButton) {
        print(sender.tag)
        
        if state[sender.tag - 1] != 0 || isActive {
            return
        }
        
        sender.setBackgroundImage(UIImage(named: images[sender.tag - 1]), for: .normal)
        
        sender.backgroundColor = UIColor.white
        
        state[sender.tag - 1] = 1
        
        var count = 0
        
        for item in state {
            if item == 1 {
                count += 1
            }
        }
        
        if count == 2 {
            isActive = true
            
            var openedIndexes: [Int] = []
            for (index, value) in state.enumerated() {
                if value == 1 {
                    openedIndexes.append(index)
                }
            }
            
            let firstIndex = openedIndexes[0]
            let secondIndex = openedIndexes[1]
            
            if images[firstIndex] == images[secondIndex] {
                
                state[firstIndex] = 2
                state[secondIndex] = 2
                isActive = false
            } else {
                
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(clear), userInfo: nil, repeats: false)
            }
        }
        countSteps += 1
        labelMoves.text = "Ходы: \(countSteps)"
        checkWin()
    }
    
    @objc func clear() {
        for i in 0...15 {
            if state[i] == 1 {
                state[i] = 0
                let button = view.viewWithTag(i + 1) as! UIButton
                button.setBackgroundImage(nil, for: .normal)
                button.backgroundColor = UIColor.systemMint
            }
        }
        isActive = false
    }
    
    func checkWin() {
        if state.allSatisfy({ $0 == 2 }) {
            let alert = UIAlertController(title: "Поздравляем, вы закончили игру за \(secondsElapsed) секунд и \(countSteps) ходов", message: "Ты открыл все пары!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Сыграть снова", style: .default, handler: { _ in
                self.resetGame()
            }))
            present(alert, animated: true)
        }
    }
    
    func resetGame() {
        state = [Int](repeating: 0, count: 16)
        images.shuffle()
        for i in 1...16 {
            if let button = view.viewWithTag(i) as? UIButton {
                button.setBackgroundImage(nil, for: .normal)
                button.backgroundColor = UIColor.systemMint
            }
        }
        isActive = false
        countSteps = 0
        labelMoves.text = "Ходы: 0"
        startGameTimer()
    }
    
    func startGameTimer() {
        gameTimer?.invalidate()
        secondsElapsed = 0
        labelTimer.text = "Время: 0 c"
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(updateGameTimer),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    @objc func updateGameTimer() {
        secondsElapsed += 1
        labelTimer.text = "Время: \(secondsElapsed) c"
    }
}

