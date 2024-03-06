//
//  GenericTextfield.swift
//  RoomExpence
//
//  Created by MQF-6 on 28/02/24.
//

import UIKit

class GenericTextfield: UITextField, UITextFieldDelegate {
    
    @IBInspectable fileprivate var RoundedCorner: Bool = false {
        didSet {
            if RoundedCorner {
                CGCDMainThread.async {
                    self.borderStyle = .none
                    self.layer.cornerRadius = self.CViewHeight/2
                }
            }
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var LeftPadding: CGFloat = 0.0 {
        didSet {
            let leftview = UIView(frame: CGRect(x: 0, y: 0, width: Int(LeftPadding), height: Int(frame.size.height)))
            leftView = leftview
            leftViewMode = .always
        }
    }
    
    @IBInspectable var isPasteEnabled: Bool = true
    
    //MARK:- Override -
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    convenience override init(frame: CGRect) {
        self.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    //MARK:- Initialize -
    func initialize() {
        if let font = self.font {
            self.font = UIFont(name: font.fontName , size: round(Float(font.pointSize).aspectRatio))
        }
        
        self.delegate = self
    }
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(UIResponderStandardEditActions.paste(_:)) where !isPasteEnabled :
            return false
        default:
            return super.canPerformAction(action, withSender: sender)
        }
    }
    
    func updateView() {
        if let image = rightImage {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 17, height: 17))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 20))
            view.addSubview(imageView)
            rightView = view
            self.rightViewMode = UITextField.ViewMode.always
            self.rightView?.isUserInteractionEnabled = false
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
        
    }
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return setInset(bounds: bounds)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return setInset(bounds: bounds)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return setInset(bounds: bounds)
    }
    
    private func setInset(bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
