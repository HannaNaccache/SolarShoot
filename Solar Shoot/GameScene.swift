//
//  GameScene.swift
//  Solar Shoot V1
//
//  Created by Projet L2R1 on 19/02/2019.
//  Copyright © 2019 Projet L2R1. All rights reserved.
//
import SpriteKit
import GameplayKit
extension Formatter {
    static let WithSeparatorGameScene: NumberFormatter = {
        let spaceScore = NumberFormatter()
        spaceScore.groupingSeparator = " "
        spaceScore.numberStyle = .decimal
        return spaceScore
    } ()
}
extension BinaryInteger {
    var formattedWithSeparatorGameScene: String {
        return Formatter.WithSeparatorGameScene.string(for: self) ?? ""
    }
}

//Cette variable est publique à toutes les scene
var gameScore = 0


//Cette variable est publique à toutes les scene
var lvlNumber : Int = 1
//let defaults1 = UserDefaults()
//set(_ value: lvlNumber1,forKey defaultName: "lvlNumber1")
//var lvlNumber = defaults1.integer(forKey: "lvlNumber1")
var lvlRequired : Int = 1
let gameScoreString = gameScore.formattedWithSeparatorGameScene
let musique = Music(musiqueActivee: musiqueActivee)
let sons = Sons(sonsActivee: sonsActivee)



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //déclaration de variables
    public var background1 = Background()
    public var background2 = Background()
    public var background3 = Background()
    public var background4 = Background()
    public var background5 = Background()
    public var background6 = Background()
    public var background7 = Background()
    public var background8 = Background()
    public var backgroundCarte = Background()
    
    private var play : Bool
    
    //On déclare toutes les planètes en fonctions des niveaux
    public var planet = Planet(imageName: "Planet")
    public var planetIcon = PlanetLife(image: "Planet")
    
    private var planetLvlI = PlanetLife(image: "Mercure")
    private var planetLvl1 = Planet(imageName: "Mercure")
    
    private var planetLvlII = PlanetLife(image: "Venus")
    private var planetLvl2 = Planet(imageName: "Venus")
    
    private var planetLvlIII = PlanetLife(image: "Terre")
    private var planetLvl3 = Planet(imageName: "Terre")
    
    private var planetLvlIV = PlanetLife(image: "Mars")
    private var planetLvl4 = Planet(imageName: "Mars")
    
    private var planetLvlV = PlanetLife(image: "Jupiter")
    private var planetLvl5 = Planet(imageName: "Jupiter")
    
    private var planetLvlVI = PlanetLife(image: "Saturne")
    private var planetLvl6 = Planet(imageName: "Saturne")
    
    private var planetLvlVII = PlanetLife(image: "Uranus")
    private var planetLvl7 = Planet(imageName: "Uranus")
    
    private var planetLvlVIII = PlanetLife(image: "Neptune")
    private var planetLvl8 = Planet(imageName: "Neptune")
    
    
    private var bullet = Bullet()
    private var asteroide = Asteroide()
    
    private var label = Label()
    
    var stopLabel = SKSpriteNode(imageNamed:"Pause")
    let exitLabel = SKSpriteNode(imageNamed:"exit")
    
    enum gameState { // Permet de dire dans quel état est le jeu
        case preGame // avant le début du niveau
        case inGame // pendant le niveau
        case StopedGame // si le joueur fait pause
        case afterGame // après le niveau ––> gagné ou perdu
    }
    var currentGameState = gameState.preGame //Ici on indique on fixe la valeur à inGame ; int = confusion
    
    struct physicsCategories {
        static let none : UInt32 = 0
        static let planet : UInt32 = 0b1 // 1 en binaire
        static let bullet : UInt32 = 0b10 // 2 en binaire
        static let asteroid: UInt32 = 0b100 // 4 en binaire
    }
    
    var pointLife = 3
    private var fireBool = false
    private var fireInterval: Double = 0.2
    private var updateTime: Double = 0
    var lastUpdateTime : TimeInterval = 0
    var deltaFrameTime : TimeInterval = 0
    var amountToMovePerSecond : CGFloat = 800.0
    
    public let gameArea : CGRect
    override init (size : CGSize) {
        let maxRatioAspect: CGFloat =  16.0 / 9.0
        let widthPlayable = size.height / maxRatioAspect
        let widthMargin =  (size.width - widthPlayable) / 2
        let heightPlayable = size.width / maxRatioAspect
        let heightMargin = (size.height - heightPlayable) / 1000
        gameArea = CGRect(x: widthMargin, y: heightMargin, width: widthPlayable, height: heightPlayable)
        play.self = true
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Appel de la fonction addAsteroid de la classe astéroïde pour afficher les astéroïdes
    func asteroids (){
        asteroide.addAsteroid(imageName:"Asteroid" , parent: self)
    }
    
    func Level(x:Int,eparpillement:Double) {
        let spawn = SKAction.run(asteroids)//Crée une action qui exécute un bloc, ici les asteroides
        let waitSpawn = SKAction.wait(forDuration: eparpillement)//Chaque seconde un nouvel asteroides tombe
        let sequence = SKAction.sequence([waitSpawn,spawn])//sequence:asteroides+attendre 0.8 sec
        let spawnForever = SKAction.repeat(sequence, count: x)//Pour repeter la sequence
        self.run(spawnForever, completion: {() -> Void in self.transition(newScene: WinScene(size: self.size))})
        
    }
    
    func transition(newScene: SKScene){
        let scene = newScene
        scene.scaleMode = self.scaleMode
        let Transition = SKTransition.reveal(with: .down, duration: 1.5)
        self.view!.presentScene(scene, transition:Transition)
    }
    
    //caractéristiques de chaque niveau
    func LevelCaracteristic(){
        switch lvlSelected {
        case 1 :
            Level(x:100, eparpillement: 0.6)
            break
        case 2 :
            Level(x:150, eparpillement: 0.55)
            break
        case 3 :
            Level(x:200, eparpillement: 0.50)
            break
        case 4 :
            Level(x:250, eparpillement: 0.45)
            break
        case 5 :
            Level(x:300, eparpillement: 0.40)
            break
        case 6 :
            Level(x:350, eparpillement: 0.35)
            break
        case 7 :
            Level(x:400, eparpillement: 0.30)
            break
        case 8 :
            Level(x:450, eparpillement: 0.20)
            break
        default :
            planet.addPlanet(parent: self)
            planet.phys()
            planetIcon.addPlanet(parent: self)
            break
        }
    }
    
    
    override func didMove(to view: SKView) {
        
        //Permet de mettre la musique en fonction de si on l'a activer ou non
        if(musique.getMusiqueActivee()){
            musique.playMusique(NameMusique: "MusiqueGameScene")
        }
        else {
            musique.stopMusique(NameMusique: "MusiqueGameScene")
        }
        gameScore = 0 //On réinitialise le gameScore à 0, sinon "garderait" le score d'avant
        self.physicsWorld.contactDelegate = self
        
        for i in 0...1 {
            //Affichage de background différents pour chaque niveau
            switch lvlSelected {
            case 1 :
                label.afficherBackground(imageName: "Fond_Mercure", parent: self, background: background1, j: i)
                break
            case 2 :
                label.afficherBackground(imageName: "Fond_Venus", parent: self, background: background2, j: i)
                break
            case 3 :
                label.afficherBackground(imageName: "Fond_Terre", parent: self, background: background3, j: i)
                break
            case 4 :
                label.afficherBackground(imageName: "Fond_Mars", parent: self, background: background4, j: i)
                break
            case 5 :
                label.afficherBackground(imageName: "Fond_Jupiter", parent: self, background: background5, j: i)
                break
            case 6 :
                label.afficherBackground(imageName: "Fond_Saturne", parent: self, background: background6, j: i)
                break
            case 7 :
                label.afficherBackground(imageName: "Fond_Uranus", parent: self, background: background7, j: i)
                break
            case 8 :
                label.afficherBackground(imageName: "Fond_Neptune", parent: self, background: background8, j: i)
                break
            default:
                label.afficherBackground(imageName: "Carte", parent: self, background: backgroundCarte, j: i)
                break
                
            }
        }
        //Affichage de planètes différentes pour chaque niveau
        switch lvlSelected {
        case 1 :
            label.afficherPlanet(parent:self,planet:planetLvl1,planetIcon:planetLvlI)
            break
        case 2 :
            label.afficherPlanet(parent:self,planet:planetLvl2,planetIcon:planetLvlII)
            break
        case 3 :
            label.afficherPlanet(parent:self,planet:planetLvl3,planetIcon:planetLvlIII)
            break
        case 4 :
            label.afficherPlanet(parent:self,planet:planetLvl4,planetIcon:planetLvlIV)
            break
        case 5 :
            label.afficherPlanet(parent:self,planet:planetLvl5,planetIcon:planetLvlV)
            break
        case 6 :
            label.afficherPlanet(parent:self,planet:planetLvl6,planetIcon:planetLvlVI)
            break
        case 7 :
            label.afficherPlanet(parent:self,planet:planetLvl7,planetIcon:planetLvlVII)
            break
        case 8 :
            label.afficherPlanet(parent:self,planet:planetLvl8,planetIcon:planetLvlVIII)
            break
        default :
            planet.addPlanet(parent: self)
            planet.phys()
            planetIcon.addPlanet(parent: self)
            break
        }
        
        
        
        //Affichage vies
        label.AffichageLabel(label: label.gameScoreLabel, text: "0", fontS: 50, horAlign: SKLabelHorizontalAlignmentMode.left, xW: 0.20,parent: self)
        label.AffichageLabel(label: label.xPointLifeLabel, text: "x", fontS: 30, horAlign: SKLabelHorizontalAlignmentMode.right, xW: 0.73,parent: self)
        label.AffichageLabel(label: label.pointLifeLabel, text: "3", fontS: 50, horAlign: SKLabelHorizontalAlignmentMode.right, xW: 0.75,parent: self)
        
        
        let moveToScreen = SKAction.moveTo(y: self.size.height*0.9, duration: 1.5)
        label.gameScoreLabel.run(moveToScreen)
        label.xPointLifeLabel.run(moveToScreen)
        label.pointLifeLabel.run(moveToScreen)
        planetIcon.run(moveToScreen)
        
        label.phrasePreGame(parent:self,label : label.tapToBeginLabel)
        
        let scrollRightToLeft = SKAction.moveTo(x: -self.size.width*0.5, duration: 8)
        let resetScroll = SKAction.moveTo(x: label.tapToBeginLabel.position.x, duration: 0)
        let scrollSequence = SKAction.sequence([scrollRightToLeft, resetScroll])
        let scrollSequenceRepeat = SKAction.repeatForever(scrollSequence)
        label.tapToBeginLabel.run(scrollSequenceRepeat)
        
        stopLabel.setScale(0.20)
        stopLabel.position = CGPoint(x: self.size.width/1.3 , y: self.size.height/18)
        stopLabel.zPosition = 100
        stopLabel.name="boutonPause"
        self.addChild(stopLabel)
        
        exitLabel.setScale(0.05)
        exitLabel.position = CGPoint(x: self.size.width/4 , y: self.size.height/18)
        exitLabel.zPosition = 100
        exitLabel.name="boutonExit"
        self.addChild(exitLabel)
        
        
    }
    
    //On utilise la classe Bullet pour utlisé les missiles
    func fireBullet () {
        bullet.addBullet(imageName: "Bullet", parent: self, player: planet)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == gameState.preGame {
            gameStart()
        }
        else if currentGameState == gameState.inGame {
            fireBool = true
        }
        for touch: AnyObject in touches{
            let toucher = touch.location(in:self)
            let nodeTapped = atPoint (_:toucher)
            
            //si on clique sur le bouton play/pause
            if (nodeTapped.name  == "boutonPause"){
                
                //et que le jeu est en mode play le jeu se met en mode pause
                if(play){
                    play = false
                    let pauseAction = SKAction.run{
                        self.view?.isPaused = true
                    }
                    self.run(pauseAction)
                    
                }
                    //et que le jeu est en mode pause le jeu se met en mode play
                else{
                    play=true
                    self.view?.isPaused = false
                    
                }
                
                //caractéristiques du bonton pause
                stopLabel = SKSpriteNode(imageNamed:"Pause")
                stopLabel.setScale(0.20)
                stopLabel.position = CGPoint(x: self.size.width/1.3, y: self.size.height/18)
                stopLabel.zPosition = 100
                stopLabel.name="boutonPause"
                self.addChild(stopLabel)
            }
            
            if (nodeTapped.name  == "boutonExit"){
                let scene = ExitScene(size: self.size)
                scene.scaleMode = self.scaleMode
                let Transition = SKTransition.reveal(with: .down, duration: 1.5)
                self.view!.presentScene(scene, transition:Transition)
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBool = false
    }
    
    //Pour bouger la planète dans la limite de l'écran
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDraggedX = pointOfTouch.x - previousPointOfTouch.x
            let amountDraggedY = pointOfTouch.y - previousPointOfTouch.y
            
            if currentGameState == gameState.inGame {
                planet.position.x += amountDraggedX
                planet.position.y += amountDraggedY
            }
            
            
            if planet.position.x > gameArea.maxX - planet.size.width / 2 {
                planet.position.x = gameArea.maxX - planet.size.width / 2
            }
            if planet.position.x < gameArea.minX + planet.size.width / 2 {
                planet.position.x = gameArea.minX + planet.size.width / 2
            }
            if planet.position.y > gameArea.maxY - planet.size.height / 2  {
                planet.position.y = gameArea.maxY - planet.size.height / 2
            }
            if planet.position.y < gameArea.minY + planet.size.height / 2 {
                planet.position.y = gameArea.minY + planet.size.height / 2
            }
        }
    }
    
    //déclaration de collision & crash
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if body1.categoryBitMask == physicsCategories.planet && body2.categoryBitMask == physicsCategories.asteroid {
            //Si la planète touche un astéroïde
            lifePoint()
            if body1.node != nil && pointLife == 0 { // nil comme NULL ; On créer l'explosion de la planète uniquement si pointLife = 0
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            if body2.node != nil {
                spawnExplosion(spawnPosition : body2.node!.position)
            }
            if pointLife == 0 {
                body1.node?.removeFromParent()
                gameOver() // On appelle la fonction gameOver afin de mettre la gameScene en "pause"
            }
            body2.node?.removeFromParent()
            
        }
        if body1.categoryBitMask == physicsCategories.bullet && body2.categoryBitMask == physicsCategories.asteroid {
            //Si le missile touche un astéroïde
            addScore()
            if body2.node != nil{
                if body2.node!.position.y > self.size.height{
                    return
                }
                else{
                    spawnExplosion(spawnPosition: body2.node!.position)
                }
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
        
        
    }
    
    func spawnExplosion (spawnPosition : CGPoint) {
        let explosion = SKSpriteNode(imageNamed: "Explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0.2)
        self.addChild(explosion)
        let scaleIn = SKAction.scale(to: 0.9, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let deleteExplosion = SKAction.removeFromParent()
        if(sons.getSonsActivee()){
            let explosionSequence = SKAction.sequence([sons.getExplosionSound(), scaleIn, fadeOut, deleteExplosion])
            explosion.run(explosionSequence)
        }
        else{
            let explosionSequence = SKAction.sequence([scaleIn, fadeOut, deleteExplosion])
            explosion.run(explosionSequence)
        }
        
    }
    
    
    //fonction pour le score
    func addScore () {
        gameScore += 1
        label.gameScoreLabel.text = "\(gameScore.formattedWithSeparatorGameScene)"
    }
    
    //Les points de vies
    func lifePoint () {
        pointLife -= 1
        if pointLife <= 1 {
            label.pointLifeLabel.text = "\(pointLife)"
        }
        else if pointLife > 1 {
            label.pointLifeLabel.text = "\(pointLife)"
        }
        label.LifeMultip()
    }
    
    func gameStart () {
        currentGameState = gameState.inGame
        let deleteTapToBeginLabel = SKAction.removeFromParent()
        label.tapToBeginLabel.run(deleteTapToBeginLabel)
        let moveShipToRightPosition = SKAction.moveTo(y: self.size.height/7, duration: 1.5)
        let startLevelAction = SKAction.run(LevelCaracteristic)
        let startLevelSequence = SKAction.sequence([moveShipToRightPosition, startLevelAction])
        planet.run(startLevelSequence)
    }
    
    
    //fonction Game Over quand le joueur perd une partie
    func gameOver () {
        currentGameState = gameState.afterGame // le joueur a perdu on passe en afterGame
        self.removeAllActions()
        self.enumerateChildNodes(withName: "Bullet") {
            (bullet, stop) in
            bullet.removeAllActions()
        }
        self.enumerateChildNodes(withName : "Asteroid") {
            (asteroid, stop) in
            asteroid.removeAllActions()
        }
        let changeSceneToGameOverScene = SKAction.run(goToGameOverScene)
        let waitToChangeSceneToGameOverScene = SKAction.wait(forDuration: 0.5)
        let changeSceneToGameOverSceneSequence = SKAction.sequence([waitToChangeSceneToGameOverScene, changeSceneToGameOverScene])
        self.run(changeSceneToGameOverSceneSequence)
    }
    
    //Transition pour aller dans la Game Over Scene
    func goToGameOverScene () {
        let sceneToMove_GameOver = GameOverScene(size: self.size)
        sceneToMove_GameOver.scaleMode = self.scaleMode
        let transitionScene = SKTransition.fade(withDuration: 1)
        self.view!.presentScene(sceneToMove_GameOver, transition: transitionScene)
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        guard fireBool else { return }
        
        
        if currentTime - updateTime > fireInterval {
            self.fireBullet()
            updateTime = currentTime
        }
        
        if currentGameState == gameState.inGame {
            if lastUpdateTime == 0 {
                lastUpdateTime = currentTime
                updateTime = currentTime
                
            }
            else {
                deltaFrameTime = currentTime - lastUpdateTime
                lastUpdateTime =  currentTime
            }
            
            let amounToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
            self.enumerateChildNodes(withName: "Background") {
                (background, stop) in
                background.position.y -= amounToMoveBackground
                if background.position.y < -self.size.height {
                    background.position.y += self.size.height*2
                }
            }
        }
        
    }
}






