//
//  GenericButton.swift
//
//  Created by Parth Thakker
//

import Foundation
import UIKit


class GenericButton: UIButton {
    
    @IBInspectable fileprivate var RoundedCorner: Bool = false {
        didSet {
            if RoundedCorner {
                self.layer.cornerRadius = self.CViewHeight/2
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let font = self.titleLabel?.font {
            self.titleLabel?.font = UIFont(name: font.fontName , size: round(Float(font.pointSize).aspectRatio))
        }
    }
    
    //MARK: - initialize -
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if RoundedCorner {
            self.layer.cornerRadius = self.CViewHeight/2
        }
    }
}


@IBDesignable
public class GradientButton: UIButton {
    public override class var layerClass: AnyClass         { CAGradientLayer.self }
    private var gradientLayer: CAGradientLayer             { layer as! CAGradientLayer }
    
    @IBInspectable public var startColor: UIColor = .white { didSet { updateColors() } }
    @IBInspectable public var endColor: UIColor = .red     { didSet { updateColors() } }
    
    // init methods
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updateColors()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateColors()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        if let font = self.titleLabel?.font {
            self.titleLabel?.font = UIFont(name: font.fontName , size: round(Float(font.pointSize).aspectRatio))
        }
    }
}

private extension GradientButton {
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    }
}
