//
//  KernedLabel.swift
//  Hangman
//
//  Created by Kevin Olive on 3/15/19.
//  Copyright © 2019 Kevin Olive. All rights reserved.
//

import UIKit

@IBDesignable
class KernedLabel: UILabel {
    
    @IBInspectable public var spacing: CGFloat = 0.0 {
        didSet {
            applyKerning()
        }
    }
    
    override var text: String? {
        didSet {
            applyKerning()
        }
    }
    
    private func applyKerning() {
        let stringValue = self.text ?? ""
        let attrString = NSMutableAttributedString(string: stringValue)
        attrString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}
