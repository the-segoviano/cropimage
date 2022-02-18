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
    
    var horizontallStickTop, verticalStickLeft, verticalStickRight, horizontallStickBottom: UIView!
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addBorder(borderColor: .white, widthBorder: 1)
        setupSticksViews()
        setupCornersViews()
        
    } // setupView
    
    
    private func setupSticksViews() {
        horizontallStickTop = customCornerView()
        horizontallStickTop.backgroundColor = UIColor.white
        verticalStickLeft = customCornerView()
        verticalStickLeft.backgroundColor = UIColor.white
        verticalStickRight = customCornerView()
        verticalStickRight.backgroundColor = UIColor.white
        horizontallStickBottom = customCornerView()
        horizontallStickBottom.backgroundColor = UIColor.white
        
        addSubview(verticalStickLeft)
        addSubview(verticalStickRight)
        addSubview(horizontallStickTop)
        addSubview(horizontallStickBottom)
        
        let whStick: CGFloat = 1
        let htStick: CGFloat = 1
        
        let xAnchor = (UIScreen.main.bounds.size.width/3) - 16
        
        NSLayoutConstraint.activate([
            verticalStickLeft.widthAnchor.constraint(equalToConstant: whStick),
            verticalStickLeft.topAnchor.constraint(equalTo: topAnchor),
            verticalStickLeft.bottomAnchor.constraint(equalTo: bottomAnchor),
            verticalStickLeft.leftAnchor.constraint(equalTo: leftAnchor, constant: xAnchor),
            
            verticalStickRight.widthAnchor.constraint(equalToConstant: whStick),
            verticalStickRight.topAnchor.constraint(equalTo: topAnchor),
            verticalStickRight.bottomAnchor.constraint(equalTo: bottomAnchor),
            verticalStickRight.rightAnchor.constraint(equalTo: rightAnchor, constant: -xAnchor),
            
            horizontallStickTop.heightAnchor.constraint(equalToConstant: htStick),
            horizontallStickTop.leftAnchor.constraint(equalTo: leftAnchor),
            horizontallStickTop.rightAnchor.constraint(equalTo: rightAnchor),
            horizontallStickTop.topAnchor.constraint(equalTo: topAnchor, constant: xAnchor),
            
            horizontallStickBottom.heightAnchor.constraint(equalToConstant: htStick),
            horizontallStickBottom.leftAnchor.constraint(equalTo: leftAnchor),
            horizontallStickBottom.rightAnchor.constraint(equalTo: rightAnchor),
            horizontallStickBottom.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -xAnchor),
        ])
    }
    
    
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
    
    let backgroundMarginColor: CGColor = UIColor.white.cgColor
    
    let thickness: CGFloat = 2.0
    
    private func addTopAndLeftBorders() {
        
        
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
        return view
    }
    
    
    
} // CustomFrameView





class ScaledHeightImageView: UIImageView {

    override var intrinsicContentSize: CGSize {

        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
 
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth, height: scaledHeight)
        }

        return CGSize(width: -1.0, height: -1.0)
    }

}


