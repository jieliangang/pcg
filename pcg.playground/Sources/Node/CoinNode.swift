import Foundation

import UIKit
import SpriteKit

class CoinNode: SKSpriteNode, Observer {

    convenience init(coin: Coin) {
        let texture = Constants.greenGem
        self.init(texture: texture,
                  size: CGSize(width: coin.width, height: coin.height))

        self.position = CGPoint(x: coin.xPos + coin.width / 2,
                                y: coin.yPos + coin.height / 2)

        self.name = "coin"
        self.physicsBody = SKPhysicsBody(texture: texture,
                                         size: CGSize(width: coin.width,
                                                      height: coin.height))
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.coin.rawValue
        self.physicsBody?.contactTestBitMask = ColliderType.coin.rawValue
        self.physicsBody?.collisionBitMask = 0

//        self.addGlow()

        coin.addObserver(self)
    }

    func onValueChanged(name: String, object: Any?) {
        guard let coin = object as? Coin else {
            return
        }

        DispatchQueue.main.async {
            switch name {
            case "xPos":
                self.position = CGPoint(x: coin.xPos + coin.width / 2,
                                        y: coin.yPos + coin.height / 2)
            default:
                return
            }
        }
    }
}
