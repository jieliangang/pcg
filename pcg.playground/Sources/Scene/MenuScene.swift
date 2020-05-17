import SpriteKit

public class MenuScene: SKScene {
    let controls: [Int: PlayerType] = [
        0: .arrow,
        1: .glide,
        2: .flappy
    ]
    
    var controlsSelectionBoxes: [SKShapeNode] = []
    var currentSelection = 0
    var canChangeSelection = true

    var backgroundNode: BackgroundNode!
    var initialized = false
    
    public override func didMove(to view: SKView) {
        guard !initialized else {
            return
        }
        initialized = true
        initBackground()
        initInstruction()
        createControlsSelectionBox(for: .arrow, order: 0)
        createControlsSelectionBox(for: .glide, order: 1)
        createControlsSelectionBox(for: .flappy, order: 2)

        self.view?.isMultipleTouchEnabled = false
    }
    
    private func initBackground() {
        backgroundNode = BackgroundNode(self.frame, type: .arrow)
        self.addChild(backgroundNode)
    }
    
    private func initInstruction() {
        let instructionLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        instructionLabel.text = "Click on arrows < > to select mode"
        instructionLabel.fontSize = 14
        instructionLabel.zPosition = -1
        instructionLabel.position = CGPoint(x: -instructionLabel.frame.width/2 + 10, y: -220)
        self.addChild(instructionLabel)
    }
    
    private func createControlsSelectionBox(for type: PlayerType, order: Int) {
        let size = CGSize(width: self.frame.width, height: self.frame.height)
        let controlsBox = SKShapeNode(rectOf: size)
        controlsBox.name = "controlsBox"
        controlsBox.strokeColor = SKColor.clear
        if order == currentSelection {
            controlsBox.position = CGPoint(x: CGFloat(0), y: CGFloat(0))
        } else {
            controlsBox.position = CGPoint(x: CGFloat(0), y: 10000)
        }
        self.addChild(controlsBox)

        // controls type label
        let controlsLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")

        switch type {
        case .arrow:
            controlsLabel.text = "A R R O W"
        case .glide:
            controlsLabel.text = "G L I D E"
        case .flappy:
            controlsLabel.text = "F L A P P Y"
        }

        controlsLabel.fontSize = 40
        controlsLabel.position = CGPoint(x: -controlsLabel.frame.width/2, y: 0)
        controlsLabel.zPosition = -1
        controlsBox.addChild(controlsLabel)

        // play label
        let playLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        switch type {
        case .arrow:
            playLabel.text = "Tap to Switch Direction"
        case .glide:
            playLabel.text = "Hold to Glide Up"
        case .flappy:
            playLabel.text = "Tap to Flap Up"
        }
        playLabel.fontSize = 20
        playLabel.position = CGPoint(x: -controlsLabel.frame.width/2, y: -60)
        controlsBox.addChild(playLabel)
        
        // arrows
        let leftArrow = SKSpriteNode(texture: Constants.leftArrow)
        leftArrow.size = CGSize(width: 50, height: 50)
        leftArrow.name = "leftArrow"
        leftArrow.position = CGPoint(x: -controlsBox.frame.width / 2 + 50, y: 0)
        controlsBox.addChild(leftArrow)

        let rightArrow = SKSpriteNode(texture: Constants.rightArrow)
        rightArrow.size = CGSize(width: 50, height: 50)
        rightArrow.name = "rightArrow"
        rightArrow.position = CGPoint(x: controlsBox.frame.width / 2 - 200, y: 0)
        controlsBox.addChild(rightArrow)

        controlsSelectionBoxes.append(controlsBox)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }

        let nodes = self.nodes(at: location)

        switch nodes.first?.name {
        case "leftArrow":
            slideLeft()
        case "rightArrow":
            slideRight()
        case "controlsBox":
            guard let controlsType = controls[currentSelection] else {
                return
            }
            presentGameScene(with: controlsType)
        default:
            return
        }
    }
    
    private func slideLeft() {
        guard canChangeSelection else {
            return
        }
        canChangeSelection = false

        let nextSelection = (currentSelection + 1) % 3

        // position next selection
        controlsSelectionBoxes[nextSelection].position = CGPoint(
            x: self.frame.midX + self.frame.width,
            y: self.frame.midY)

        let slideLeft = SKAction.moveBy(x: -self.frame.width, y: 0, duration: 0.3)
        let delay = SKAction.wait(forDuration: 0.3)

        for box in controlsSelectionBoxes {
            let sequence = SKAction.sequence([slideLeft, delay])
            box.run(sequence, completion: { [weak self] in
                self?.canChangeSelection = true
            })
        }
        currentSelection = nextSelection

        guard let controlsType = controls[currentSelection] else {
            return
        }
        backgroundNode.updateBackground(type: controlsType)
    }

    private func slideRight() {
        guard canChangeSelection else {
            return
        }
        canChangeSelection = false

        let nextSelection = (currentSelection == 0) ? 2 : currentSelection - 1

        // position next selection
        controlsSelectionBoxes[nextSelection].position = CGPoint(
            x: self.frame.midX - self.frame.width,
            y: self.frame.midY)

        let slideRight = SKAction.moveBy(x: self.frame.width, y: 0, duration: 0.3)
        let delay = SKAction.wait(forDuration: 0.3)

        for box in controlsSelectionBoxes {
            let sequence = SKAction.sequence([slideRight, delay])
            box.run(sequence, completion: { [weak self] in
                self?.canChangeSelection = true
            })
        }
        currentSelection = nextSelection

        guard let controlsType = controls[currentSelection] else {
            return
        }
        backgroundNode.updateBackground(type: controlsType)
    }
    
    private func presentGameScene(with playerType: PlayerType) {
        if let gameScene = GameScene(fileNamed: "GameScene") {
            gameScene.playerType = playerType
            self.view?.presentScene(gameScene)
        }
    }
}
