import Foundation
import UIKit
import SpriteKit

enum Direction {
    case goUp, goDown
}

public class PlayerNode: SKSpriteNode, Observer {
    var isHolding = false
    var direction = Direction.goUp
    
    convenience init(_ player: Player) {
        let size = CGSize(width: 55, height: 55)
        self.init(texture: Constants.arrow,color: SKColor.black, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    public func onValueChanged(name: String, object: Any?) {
        
    }
}
