//
//  Helpers.swift
//  CropImage
//
//  Created by Luis Enrique Segoviano Bonifacio on 17/02/22.
//

import UIKit


extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints( NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewDictionary) )
    }
    
    /**
     * Agrega borde a una vista
     *
     */
    func addBorder(borderColor: UIColor = UIColor.red, widthBorder: CGFloat = 1.0) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = widthBorder
    }
    
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    
} // UIView

struct ScreenSize {
    static let screenSize   = UIScreen.main.bounds
    static let screenWidth  = screenSize.width
    static let screenHeight = screenSize.height
    
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
    static let maxWH = max(ScreenSize.width, ScreenSize.height)
    
}




class CustomFrameView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var topCornerLeft, topCornerRight, bottomCornerLeft, bottomCornerRight: UIView!
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        setupCornersViews()
        
    } // setupView
    
    private func setupCornersViews() {
        topCornerLeft = customCornerView()
        topCornerRight = customCornerView()
        bottomCornerLeft = customCornerView()
        bottomCornerRight = customCornerView()
        
        addSubview(topCornerLeft)
        addSubview(topCornerRight)
        addSubview(bottomCornerLeft)
        addSubview(bottomCornerRight)
        
        let whCorner: CGFloat = 35
        let htCorner: CGFloat = 35
        
        NSLayoutConstraint.activate([
            
            topCornerLeft.heightAnchor.constraint(equalToConstant: htCorner),
            topCornerLeft.widthAnchor.constraint(equalToConstant: whCorner),
            topCornerLeft.leftAnchor.constraint(equalTo: leftAnchor),
            topCornerLeft.topAnchor.constraint(equalTo: topAnchor),
            
            topCornerRight.heightAnchor.constraint(equalToConstant: htCorner),
            topCornerRight.widthAnchor.constraint(equalToConstant: whCorner),
            topCornerRight.topAnchor.constraint(equalTo: topAnchor),
            topCornerRight.rightAnchor.constraint(equalTo: rightAnchor),
            
            bottomCornerLeft.heightAnchor.constraint(equalToConstant: htCorner),
            bottomCornerLeft.widthAnchor.constraint(equalToConstant: whCorner),
            bottomCornerLeft.leftAnchor.constraint(equalTo: leftAnchor),
            bottomCornerLeft.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            bottomCornerRight.heightAnchor.constraint(equalToConstant: htCorner),
            bottomCornerRight.widthAnchor.constraint(equalToConstant: whCorner),
            bottomCornerRight.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomCornerRight.rightAnchor.constraint(equalTo: rightAnchor),
        ])
        
        addTopAndLeftBorders()
        addTopAndRightBorders()
        addBottomAndLeftBorders()
        addBottomAndRightBorders()
        
    }
    
    let backgroundMarginColor: CGColor = UIColor.darkGray.cgColor
    
    private func addTopAndLeftBorders() {
        let thickness: CGFloat = 1.0
        
        let topBorder = CALayer()
        let leftBorder = CALayer()
        
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: 48, height: thickness)
        topBorder.backgroundColor = backgroundMarginColor
        
        leftBorder.frame = CGRect(x:0, y: 0, width: thickness, height: 48)
        leftBorder.backgroundColor = backgroundMarginColor
        
        topCornerLeft.layer.addSublayer(topBorder)
        topCornerLeft.layer.addSublayer(leftBorder)
    }
    
    
    private func addTopAndRightBorders() {
        let thickness: CGFloat = 1.0
        
        let topBorder = CALayer()
        let rightBorder = CALayer()
        
        topBorder.frame = CGRect(x: -13.0, y: 0.0, width: 48, height: thickness)
        topBorder.backgroundColor = backgroundMarginColor
        
        rightBorder.frame = CGRect(x: 34, y: 0, width: thickness, height: 48)
        rightBorder.backgroundColor = backgroundMarginColor
        
        topCornerRight.layer.addSublayer(topBorder)
        topCornerRight.layer.addSublayer(rightBorder)
    }
    
    
    private func addBottomAndLeftBorders() {
        let thickness: CGFloat = 1.0
        let bottomBorder = CALayer()
        let leftBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: 34.0, width: 48, height: thickness)
        bottomBorder.backgroundColor = backgroundMarginColor
        
        leftBorder.frame = CGRect(x:0, y: -13, width: thickness, height: 48)
        leftBorder.backgroundColor = backgroundMarginColor
        
        bottomCornerLeft.layer.addSublayer(bottomBorder)
        bottomCornerLeft.layer.addSublayer(leftBorder)
    }
    
    
    private func addBottomAndRightBorders() {
        let thickness: CGFloat = 1.0
        let bottomBorder = CALayer()
        let rightBorder = CALayer()
        
        bottomBorder.frame = CGRect(x: -13.0, y: 34.0, width: 48, height: thickness)
        bottomBorder.backgroundColor = backgroundMarginColor
        
        rightBorder.frame = CGRect(x: 34, y: -13, width: thickness, height: 48)
        rightBorder.backgroundColor = backgroundMarginColor
        
        bottomCornerRight.layer.addSublayer(bottomBorder)
        bottomCornerRight.layer.addSublayer(rightBorder)
        
    }
    
    
    
    private func customCornerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.addBorder(borderColor: .red, widthBorder: 1)
        return view
    }
    
    
    
} // CustomFrameView


