//
//  TFLabelNode.swift
//  TowerForge
//
//  Created by Zheng Ze on 29/3/24.
//

import SpriteKit

enum AlignmentMode {
    case center
    case leading
    case trailing

    init(verticalAlignment: SKLabelVerticalAlignmentMode) {
        switch verticalAlignment {
        case .baseline:
            self = .center
        case .center:
            self = .center
        case .top:
            self = .leading
        case .bottom:
            self = .trailing
        @unknown default:
            self = .center
        }
    }

    init(horizontalAlignment: SKLabelHorizontalAlignmentMode) {
        switch horizontalAlignment {
        case .center:
            self = .center
        case .left:
            self = .leading
        case .right:
            self = .trailing
        @unknown default:
            self = .center
        }
    }

    var verticalALignmentMode: SKLabelVerticalAlignmentMode {
        switch self {
        case .center:
            return .center
        case .leading:
            return .top
        case .trailing:
            return .bottom
        }
    }

    var horizontalAlignmentMode: SKLabelHorizontalAlignmentMode {
        switch self {
        case .center:
            return .center
        case .leading:
            return .left
        case .trailing:
            return .right
        }
    }
}

class TFLabelNode: TFNode {
    init(text: String) {
        super.init()
        node = SKLabelNode(text: text)
    }

    var text: String? {
        get { labelNode.text }
        set(text) { labelNode.text = text }
    }

    var fontColor: UIColor? {
        get { labelNode.fontColor }
        set(fontColor) { labelNode.fontColor = fontColor }
    }

    var fontName: String? {
        get { labelNode.fontName }
        set(fontName) { labelNode.fontName = fontName }
    }

    var fontSize: CGFloat {
        get { labelNode.fontSize }
        set(fontSize) { labelNode.fontSize = fontSize }
    }

    var horizontalAlignementMode: AlignmentMode {
        get { AlignmentMode(horizontalAlignment: labelNode.horizontalAlignmentMode) }
        set(alignmentMode) { labelNode.horizontalAlignmentMode = alignmentMode.horizontalAlignmentMode }
    }

    var verticalAlignementMode: AlignmentMode {
        get { AlignmentMode(verticalAlignment: labelNode.verticalAlignmentMode) }
        set(alignmentMode) { labelNode.verticalAlignmentMode = alignmentMode.verticalALignmentMode }
    }

    private var labelNode: SKLabelNode {
        guard let labelNode = node as? SKLabelNode else {
            fatalError("SKNode in TFNode was not a SKLabelNode")
        }
        return labelNode
    }
}
