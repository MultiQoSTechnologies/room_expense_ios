//
//  UIView+Extension.swift
//  DeliveryApp
//
//  Created by MQF-6 on 06/02/24.
//

import UIKit

extension UIView {
    func setCorner(radius: CGFloat = 12) {
        self.layer.cornerRadius = radius
    }
     
    func setBorder(color: UIColor = .white, width: CGFloat = 1) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func makeRounded() {
        self.layer.cornerRadius = self.frame.height / 2
    }
    
}

// MARK: - Extension of UIView For giving the round shape to any UIView.
extension UIView {
    
//    @IBInspectable 
    fileprivate var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        } set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
//    @IBInspectable
fileprivate var borderColor: UIColor? {
        get {
            guard let borderColor = self.layer.borderColor else { return nil }
            return UIColor(cgColor: borderColor)
        } set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
//    @IBInspectable
fileprivate var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        } set {
            self.layer.borderWidth = newValue
        }
    }
    
//    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            
            layer.shadowRadius = shadowRadius
        }
    }
//    @IBInspectable
    var shadowOffset : CGSize{
        
        get{
            return layer.shadowOffset
        }set{
            
            layer.shadowOffset = newValue
        }
    }
    
//    @IBInspectable
    var shadowColor : UIColor{
        get{
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
//    @IBInspectable
    var shadowOpacity : Float {
        
        get{
            return layer.shadowOpacity
        }
        set {
            
            layer.shadowOpacity = newValue
            
        }
    }
    
    /// This method is used to giving the round shape to any UIView
    func roundView() {
        
        layer.cornerRadius = CViewHeight > CViewWidth
        ? CViewWidth/2.0
        : CViewHeight/2.0
        
        layer.masksToBounds = true
    }
    
}

// MARK: - Extension of UIView For removing all the subviews of UIView.
extension UIView {
    
    /// This method is used for removing all the subviews of UIView.
    func removeAllSubviews() {
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    /// This method is used for removing all the subviews from InterfaceBuilder for perticular tag.
    /// - Parameter tag: Pass the tag value of UIView , and that UIView and its all subviews will remove from InterfaceBuilder.
    func removeAllSubviewsOfTag(tag: Int) {
        
        for subview in self.subviews where subview.tag == tag {
            subview.removeFromSuperview()
        }
    }
}

// MARK: - Extension of UIView For draw a shadowView of it.
extension UIView {
    
    /// This method is used to draw a shadowView for perticular UIView.
    ///
    /// - Parameters:
    ///   - color: Pass the UIColor that you want to see as shadowColor.
    ///   - shadowOffset: Pass the CGSize value for how much far you want shadowView from parentView.
    ///   - shadowRadius: Pass the CGFloat value for how much length(Blur Spreadness) you want in shadowView.
    func shadow(
        color: UIColor,
        shadowOffset: CGSize,
        shadowRadius: CGFloat
    ) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

// MARK: - Extension of UIView For adding the border to UIView at any position.
extension UIView {
    
    /// A Enum UIPosition Describes the Different Postions.
    ///
    /// - top: Will add border at top of The UIView.
    /// - left: Will add border at left of The UIView.
    /// - bottom: Will add border at bottom of The UIView.
    /// - right: Will add border at right of The UIView.
    enum UIPosition {
        case top
        case left
        case bottom
        case right
    }
    
    /// This method is used to add the border to perticular UIView at any position.
    ///
    /// - Parameters:
    ///   - position: Pass the enum value of UIPosition , according to the enum value it will add the border for that position.
    ///   - color: Pass the UIColor which you want to see in a border.
    ///   - width: CGFloat value - (Optional - if you are passing nil then method will automatically set this value same as Parent's width) OR pass how much width you want for border. For top and bottom UIPosition you can pass nil.
    ///   - height: CGFloat value - (Optional - if you are passing nil then method will automatically set this value same as Parent's height) OR pass how much height you want for border. For left and right UIPosition you can pass nil.
    func addBorder(
        position: UIPosition = .top,
        color: UIColor = .black,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        
        let borderLayer = CALayer()
        borderLayer.backgroundColor = color.cgColor
        
        var xPosition: CGFloat = 0.0
        var yPosition: CGFloat = 0.0
        var layerWidth: CGFloat = width ?? 1.0
        var layerHeight: CGFloat = height ?? 1.0
        
        switch position {
            
        case .top:
            layerWidth = width ?? CViewWidth
            
        case .left:
            layerHeight = height ?? CViewHeight
            
        case .bottom:
            yPosition = CViewHeight - (height ?? 0.0)
            layerWidth = width ?? CViewWidth
            
        case .right:
            xPosition = CViewWidth - (width ?? 0.0)
            layerHeight = height ?? CViewHeight
        }
        
        borderLayer.frame = CGRect(
            origin: CGPoint(
                x: xPosition,
                y: yPosition
            ),
            size: CGSize(
                width: layerWidth,
                height: layerHeight
            )
        )
        
        self.layer.addSublayer(borderLayer)
    }
    
    /// To add the same border on multiple positions.
    /// Pass the positions into array which side wants to show the border.
    /// example:- [.top, .left, .bottom, .right]
    func addBorder(
        positions: [UIPosition] = [.top],
        color: UIColor = .black,
        width: CGFloat? = nil,
        height: CGFloat? = nil) {
            
            for position in positions {
                
                addBorder(
                    position: position,
                    color: color,
                    width: width,
                    height: height
                )
            }
            
        }
}

typealias tapInsideViewHandler = (() -> ())

extension UIView {
    
    private struct AssociatedObjectKey {
        static var tapInsideViewHandler = "tapInsideViewHandler"
    }
    
    func tapInsideViewHandler(tapInsideViewHandler: @escaping tapInsideViewHandler) {
        
        self.isUserInteractionEnabled = true
        
        objc_setAssociatedObject(
            self,
            &AssociatedObjectKey.tapInsideViewHandler,
            tapInsideViewHandler,
            .OBJC_ASSOCIATION_RETAIN
        )
        
        guard let tapGesture = self.gestureRecognizers?.first(where: {$0.isEqual(UITapGestureRecognizer.self)}) as? UITapGestureRecognizer else {
            
            self.addGestureRecognizer(UITapGestureRecognizer(
                target: self,
                action: #selector(handleTapGesture(sender:)))
            )
            
            return
        }
        
        tapGesture.addTarget(
            self,
            action: #selector(handleTapGesture(sender:))
        )
    }
    
    @objc private func handleTapGesture(sender: UITapGestureRecognizer) {
        
        if let tapInsideViewHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.tapInsideViewHandler) as? tapInsideViewHandler {
            tapInsideViewHandler()
        }
    }
}

extension UIView {
    
    var snapshotImage: UIImage? {
        
        var snapShotImage: UIImage?
        
        UIGraphicsBeginImageContext(self.CViewSize)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                snapShotImage = image
            }
        }
        return snapShotImage
    }
}

extension UIView {
    
    var CViewSize: CGSize {
        return self.frame.size
    }
    var CViewOrigin: CGPoint {
        return self.frame.origin
    }
    var CViewWidth: CGFloat {
        return self.CViewSize.width
    }
    var CViewHeight: CGFloat {
        return self.CViewSize.height
    }
    var CViewX: CGFloat {
        return self.CViewOrigin.x
    }
    var CViewY: CGFloat {
        return self.CViewOrigin.y
    }
    var CViewCenter: CGPoint {
        return CGPoint(x: self.CViewWidth/2.0, y: self.CViewHeight/2.0)
    }
    var CViewCenterX: CGFloat {
        return CViewCenter.x
    }
    var CViewCenterY: CGFloat {
        return CViewCenter.y
    }
}

extension UIView {
    
    func CViewSetSize(width: CGFloat, height: CGFloat) {
        CViewSetWidth(width: width)
        CViewSetHeight(height: height)
    }
    
    func CViewSetOrigin(x: CGFloat, y: CGFloat) {
        CViewSetX(x: x)
        CViewSetY(y: y)
    }
    
    func CViewSetWidth(width: CGFloat) {
        self.frame.size.width = width
    }
    
    func CViewSetHeight(height: CGFloat) {
        self.frame.size.height = height
    }
    
    func CViewSetX(x: CGFloat) {
        self.frame.origin.x = x
    }
    
    func CViewSetY(y: CGFloat) {
        self.frame.origin.y = y
    }
    
    func CViewSetCenter(x: CGFloat, y: CGFloat) {
        CViewSetCenterX(x: x)
        CViewSetCenterY(y: y)
    }
    
    func CViewSetCenterX(x: CGFloat) {
        self.center.x = x
    }
    
    func CViewSetCenterY(y: CGFloat) {
        self.center.y = y
    }
}

extension UIView {
    
    func alternateCorners(_ corners: CACornerMask, radius: CGFloat) {
        
        if #available(iOS 11, *) {
            
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = corners
            
        } else {
            
            var cornerMask = UIRectCorner()
            
            if(corners.contains(.layerMinXMinYCorner)){
                cornerMask.insert(.topLeft)
            }
            if(corners.contains(.layerMaxXMinYCorner)){
                cornerMask.insert(.topRight)
            }
            if(corners.contains(.layerMinXMaxYCorner)){
                cornerMask.insert(.bottomLeft)
            }
            if(corners.contains(.layerMaxXMaxYCorner)){
                cornerMask.insert(.bottomRight)
            }
            
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornerMask, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            
            self.layer.mask = mask
        }
    }
} 

extension UIView {

    /// Creates an image from the view's contents, using its layer.
    ///
    /// - Returns: An image, or nil if an image couldn't be created.
    func image() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.saveGState()
        layer.render(in: context)
        context.restoreGState()
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }

}

extension UIView {
    func setConstraintConstant(constant: CGFloat, forAttribute attribute: NSLayoutConstraint.Attribute) -> Bool {
        let constraint = self.constraintForAttribute(attribute: attribute)
        if constraint  != nil {
            constraint?.constant = constant
            return true
        } else {
            self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: CGFloat(1.0), constant: constant))
            return false
        }
    }
    
    func constraintConstantforAttribute(attribute: NSLayoutConstraint.Attribute) -> CGFloat? {
        let constraint = self.constraintForAttribute(attribute: attribute)
        if constraint != nil {
            return constraint?.constant
        } else {
            return nil
        }
    }
    
    func constraintForAttribute(attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        
       let predicate = NSPredicate(format: "firstAttribute = %d && firstItem = %@", argumentArray: [attribute, self])

        
         let fillteredArray =  NSArray(array: (self.superview?.constraints)!).filtered(using: predicate)
        
        
        //    var fillteredArray = self.superview?.constraints.filteredArrayUsingPredicate(predicate)
        
       // self.superview?.constraints
        if fillteredArray.count == 0 {
            return nil
        } else {
            return fillteredArray.first as? NSLayoutConstraint
        }
    }
    
    func hideView(hidden: Bool, byAttribute attribute: NSLayoutConstraint.Attribute) {
        if self.isHidden != hidden {
            let constraintConstant = self.constraintConstantforAttribute(attribute: attribute)
            if hidden {
                if constraintConstant != nil {
                    self.alpha = constraintConstant!
                } else {
                   // let size = self.getSize()
                   // self.alpha =  size.height // (attribute == NSLayoutAttribute) ? size.height : size.width
                }
                self.setConstraintConstant(constant: 0, forAttribute: attribute)
                self.isHidden = true
            } else {
                if constraintConstant != nil  {
                    self.isHidden = false
                   // self.setConstraintConstant(constant: self.alpha, forAttribute: attribute)
                    self.alpha = 1
                }
            }
        }
    }
    
    func hideByHeight(hidden: Bool) {
        self.hideView(hidden: hidden, byAttribute: .height)
    }
    
    func hideByWidth(hidden: Bool) {
        self.hideView(hidden: hidden, byAttribute: .width)
    }
    
    func getSize() -> CGSize {
        self.updateSizes()
        return CGSize(width:self.bounds.size.width,height: self.bounds.size.height)
    }
    
    func sizeToSubviews() {
        self.updateSizes()
        let fittingSize = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.frame = CGRect(x:0,y: 0,width: 320,height: fittingSize.height)
    }
    
    func updateSizes() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
