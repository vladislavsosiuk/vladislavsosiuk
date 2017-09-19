//
//  GameViewController.swift
//  tetrisByVladOS
//
//  Created by air on 30.09.16.
//  Copyright © 2016 VladOS. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, BrainDelegate, UIGestureRecognizerDelegate{

    var scene: GameScene! // игровая сцена
    var brain:Brain! // логика игры
    var panPointReference:CGPoint?
    
    @IBOutlet weak var scoreLabel: UILabel! //статик текст для очков
    
    @IBOutlet weak var levelLabel: UILabel!// статик текст для уровней
    
    override func viewDidLoad() {
        super.viewDidLoad() //инициализируем супер класс
        
        let skView = view as! SKView //объект вида
        skView.isMultipleTouchEnabled = false //выключаем мультитач
        
        scene = GameScene(size: skView.bounds.size) //инициализируем игровую сцену размером экрана
        scene.scaleMode = .aspectFill // масштабируем ее по размеру экрана
        
        scene.tick = didTick //поле класса gamescene инициализируем методом этого класса
        brain = Brain() // инициализируем поле
        brain.delegate = self
        brain.beginGame()
    
        skView.presentScene(scene) //представляем сцену
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        brain.rotateShape()
    }
  
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        let currentPoint = sender.translation(in: self.view)
        if let originalPoint = panPointReference{
            if abs(currentPoint.x-originalPoint.x)>(blockSize*0.9){
                if sender.velocity(in: self.view).x > CGFloat(0){
                    brain.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    brain.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        } else if sender.state == .began{
            panPointReference=currentPoint
        }
    }
    @IBAction func didSwipe(_ sender: UISwipeGestureRecognizer) {
        brain.dropShape()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            if otherGestureRecognizer is UIPanGestureRecognizer{
                return true
            }
        } else if gestureRecognizer is UIPanGestureRecognizer{
            if otherGestureRecognizer is UITapGestureRecognizer{
                return true
            }
            
        }
        return false
    }
    
    func didTick(){
        brain.letshapeFall()
    }
    
    func nextShape(){
        let newShapes = brain.newShape()
        guard let fallingShape = newShapes.fallingShape else{
            return
        }
        self.scene.addPreviewShapeToScene(shape: newShapes.nextShape!){}
        self.scene.movePreviewShape(shape: fallingShape){
            self.scene.addShadow(shape: self.brain.shadowShape!){}
            self.view.isUserInteractionEnabled = true
            self.scene.startTicking()
        }
        
    }
    func gameDidBegin(brain: Brain) {
        levelLabel.text = "\(brain.level)"
        scoreLabel.text = "\(brain.score)"
        scene.tickLengthMillis = tickLengthLeavelOne
        if brain.nextShape != nil && brain.nextShape!.blocks[0].sprite == nil{
            scene.addPreviewShapeToScene(shape: brain.nextShape!){
                self.nextShape()
            }
        }else{
            nextShape()
        }
    }
    
    func gameDidEnd(brain: Brain) {
        view.isUserInteractionEnabled = false
        scene.stopTicking()
        scene.playSound(sound: "Sounds/gameover.mp3")
        scene.collapsingLines(linesToRemove: brain.removeAllBlocks(), fallenBlocks: brain.removeAllBlocks()){
            brain.beginGame()
        }
    }
    func gameDidLevelUp(brain: Brain) {
        levelLabel.text = "\(brain.level)"
        if scene.tickLengthMillis>=100{
            scene.tickLengthMillis-=100
        } else if scene.tickLengthMillis>50{
            scene.tickLengthMillis-=50
        }
        scene.playSound(sound: "Sounds/levelup.mp3")
    }
    func gameShapeDidDrop(brain: Brain) {
        scene.stopTicking()
        scene.redrawShape(shape: brain.fallingShape!){
            brain.letshapeFall()
        }
        scene.killShadow(shape: brain.shadowShape!){}
        scene.playSound(sound: "Sounds/drop.mp3")
    }
    func gameShapeDidLand(brain: Brain) {
        scene.stopTicking()
        scene.killShadow(shape: brain.fallingShape){}
        self.view.isUserInteractionEnabled = false
        let removedlines = brain.removeCompletedLines()
        if removedlines.linesRemoved.count>0{
            scene.killShadow(shape: brain.shadowShape){}
            self.scoreLabel.text = "\(brain.score)"
            scene.collapsingLines(linesToRemove: removedlines.linesRemoved, fallenBlocks: removedlines.fallenBlocks){
                self.gameShapeDidLand(brain: brain)
            }
            scene.playSound(sound: "Sounds/bomb.mp3")
        }else{
            nextShape()
        }
    }
    func gameShapeDidMove(brain: Brain) {
        scene.redrawShape(shape: brain.fallingShape!){}
        scene.redrawShadow(shape: brain.shadowShape!){}
    }
}
