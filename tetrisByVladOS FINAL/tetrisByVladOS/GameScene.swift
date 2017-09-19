//
//  GameScene.swift
//  tetrisByVladOS
//
//  Created by air on 30.09.16.
//  Copyright © 2016 VladOS. All rights reserved.
//

import SpriteKit
import GameplayKit
let tickLengthLeavelOne = TimeInterval(600)//скорость при которой фигуры перемещаются
let blockSize:CGFloat = 20.0

class GameScene: SKScene {
    
    let gameLayer = SKNode() // игровой слой
    let shapeLayer = SKNode() //слой на котором отображаются фигуры
    let LayerPosition = CGPoint(x:6, y: -5) //позиция слоя
    
    var tick:(()->())? //замыкание
    var tickLengthMillis = tickLengthLeavelOne// длинна тика в милисекундах
    var lastTick:NSDate? // последний тик
    
    var textureCache = Dictionary<String, SKTexture>()
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize)
    {
        super.init(size: size) //инициализируем супер класс
        anchorPoint = CGPoint(x:0,y:1.0) //точка относительно которой строятся узлы
        let background = SKSpriteNode(imageNamed: "background") // игровой фон
        background.anchorPoint = CGPoint(x:0,y:1) //фон будет начинаться от верхнего левого угла экрана
        background.position = CGPoint(x:0,y:0) // позиция идет относительно anchorPoint
        background.scale(to: size) //растягиваем фон для больших диагоналей
        addChild(background) // добавляем дочерний узел
        
        addChild(gameLayer)// добавляем игровой слой
        let gameBoardTexture = SKTexture(imageNamed: "gameboard") // константа текстуры игрового поля
        let gameBoard = SKSpriteNode(texture: gameBoardTexture, size: CGSize(width:blockSize*CGFloat(NumColumns),height:blockSize*CGFloat(NumRows-1))) // константа игрового поля в виде узла
        gameBoard.anchorPoint = CGPoint(x: 0, y: 1.0)//начальная точка узла игрового поля
        gameBoard.position = LayerPosition // позиция узла игрового поля относительно начальной точки
        shapeLayer.position = LayerPosition //позиция слоя на котором отображаются фигуры
        shapeLayer.addChild(gameBoard) //добавляем на слой который отображает фигуры игровое поле
        gameLayer.addChild(shapeLayer) //и сохраняем слой фигур в игровой слой
        run(SKAction.repeatForever(SKAction.playSoundFileNamed("Sounds/OST.mp3", waitForCompletion: true)))
    }
    
    func playSound(sound: String){
        run(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
    }
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    func collapsingLines(linesToRemove: Array<Array<Block>>,fallenBlocks: Array<Array<Block>>, completion: @escaping ()->()){
        var longestDuration:TimeInterval = 0
        for (columnIdx, column) in fallenBlocks.enumerated(){
            for (blockIdx, block) in column.enumerated(){
                let newPosition = pointForColumn(column: block.column, row: block.row)
                let sprite = block.sprite!
                let delay = (TimeInterval(columnIdx)*0.05)+(TimeInterval(blockIdx)*0.05)
                let duration = TimeInterval(((sprite.position.y-newPosition.y)/blockSize)*0.1)
                let moveAction = SKAction.move(to: newPosition,duration: duration)
                moveAction.timingMode = .easeOut
                sprite.run(SKAction.sequence([SKAction.wait(forDuration: delay),moveAction]))
                longestDuration = max(longestDuration,duration+delay)
            }
        }
        for rowToRemove in linesToRemove{
            for block in rowToRemove{
                let sprite = block.sprite!
                let moveAction = SKAction.removeFromParent()
                moveAction.timingMode = .easeOut
                sprite.run(moveAction)
            }
        }
        run(SKAction.wait(forDuration: longestDuration), completion: completion)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
  
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        guard let lastTick = lastTick else // проверяем хранит ли lastTick  значение
        {
            return
        }
        let timePassed = lastTick.timeIntervalSinceNow * -1000 // сколько времени прошло от последнего тика
        
        if timePassed > tickLengthMillis
        {
            self.lastTick = NSDate()//изменяем последний тик на текущее время
            tick?() // вызываем замыкание которое инициализировано функцией
        }
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    func startTicking ()
    {
        lastTick=NSDate()//при начале таймера инициализируем его текущим временем
    }
    func stopTicking()
    {
        lastTick=nil // при остановке таймера обнуляем
    }
    func pointForColumn(column: Int,row: Int)->CGPoint{
        let x = LayerPosition.x + (CGFloat(column)*blockSize)+(blockSize/2)
        let y = LayerPosition.y - (CGFloat(row)*blockSize)+(blockSize/2)
        return CGPoint(x: x, y: y)
    }
    func addPreviewShapeToScene(shape: Shape, completion: @escaping ()->()){
        for block in shape.blocks{
            var texture = textureCache[block.spriteName]
            if texture == nil{
                texture = SKTexture(imageNamed: block.spriteName)
                textureCache[block.spriteName]=texture
            }
            let sprite = SKSpriteNode(texture: texture)
            sprite.position = pointForColumn(column: block.column, row: block.row-2)
            shapeLayer.addChild(sprite)
            block.sprite = sprite
            sprite.alpha = 0
            
            let moveAction = SKAction.move(to: pointForColumn(column: block.column, row: block.row), duration: TimeInterval(0.2))
            moveAction.timingMode = .easeOut
            let fadeInAction = SKAction.fadeAlpha(to: 0.7, duration: 0.4)
            fadeInAction.timingMode = .easeOut
            sprite.run(SKAction.group([moveAction,fadeInAction]))
        }
        run(SKAction.wait(forDuration: 0.4),completion: completion)
    }
    func addShadow(shape: Shape, completion: @escaping ()->()){
        for block in shape.blocks{
            var texture = textureCache[block.spriteName]
            if texture==nil{
                texture = SKTexture(imageNamed: block.spriteName)
                textureCache[block.spriteName]=texture
            }
            let sprite = SKSpriteNode(texture: texture)
            
            sprite.position = pointForColumn(column: block.column, row: block.row)
            shapeLayer.addChild(sprite)
            block.sprite=sprite
            sprite.alpha = 0.2
        }
        run(SKAction.wait(forDuration: 0.4), completion: completion)
    }
    func movePreviewShape(shape:Shape, completion: @escaping ()->()){
        for block in shape.blocks{
            let sprite = block.sprite!
            let moveTo = pointForColumn(column: block.column, row: block.row)
            let moveToAction:SKAction = SKAction.move(to: moveTo, duration: 0.2)
            moveToAction.timingMode = .easeOut
            //------------
            sprite.run(SKAction.group([moveToAction,SKAction.fadeAlpha(to: 1.0, duration: 0.2)]), completion:{})
        }
        run(SKAction.wait(forDuration: 0.2),completion: completion)
    }
    func redrawShape(shape:Shape,completion: @escaping ()->()){
        for block in shape.blocks{
            let sprite = block.sprite!
            let moveTo = pointForColumn(column: block.column, row: block.row)
            let moveToAction:SKAction = SKAction.move(to: moveTo, duration: 0.05)
            moveToAction.timingMode = .easeOut
            if block == shape.blocks.last{
                sprite.run(moveToAction, completion: completion)
            }
            else{
                sprite.run(moveToAction)
            }
        }
    }
    func redrawShadow(shape:Shape, completion: @escaping ()->()){
        for block in shape.blocks{
            let sprite = block.sprite!
            let moveTo = pointForColumn(column: block.column, row: block.row)
            let moveToAction:SKAction = SKAction.move(to: moveTo, duration: 0.05)
            moveToAction.timingMode = .easeOut
            if block == shape.blocks.last{
                sprite.run(moveToAction, completion: completion)
            }else{
                sprite.run(moveToAction)
            }
        }
    }
    func killShadow(shape:Shape?, completion: @escaping ()->()){
        guard let shadow = shape else{
            return
        }
        for block in shadow.blocks{
            let sprite = block.sprite!
            let action = SKAction.removeFromParent()
            sprite.run(action)
        }
    }
}
