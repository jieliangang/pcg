import Foundation

enum ColliderType: UInt32 {
    case player =   0b000001
    case obstacle = 0b000010
    case wall =     0b000100
    case powerup =  0b001000
    case coin =     0b010000
    case boundary = 0b100000
}

