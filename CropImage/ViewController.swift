//
//  ViewController.swift
//  CropImage
//
//  Created by Luis Segoviano on 10/02/22.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    var mainView: UIView {
        return self.view
    }
    
    let close: UIButton = {
        let image = UIImage(named: "close")
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(cerrar), for: .touchUpInside)
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }()
    
    var imageDetail: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "wallpaper") // avatar
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: UIScreen.main.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .lightGray
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.isUserInteractionEnabled = true
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.flashScrollIndicators()
        scrollView.clipsToBounds = false
        return scrollView
    }()
    
    let squareFrameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addBorder()
        return view
    }()
    
    let verticalFrameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addBorder()
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .black
        
        scrollView.delegate = self
        
        mainView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
        
        //mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollView)
        //mainView.addConstraintsWithFormat(format: "V:|[v0]|", views: scrollView)
        
        
        //mainView.addSubview(close)
        //mainView.addConstraintsWithFormat(format: "H:[v0(24)]-|", views: close)
        //mainView.addConstraintsWithFormat(format: "V:|-16-[v0(24)]", views: close)
        
        scrollView.addSubview(imageDetail)
        scrollView.addConstraintsWithFormat(format: "H:|[v0(\(ScreenSize.screenWidth))]|", views: imageDetail)
        scrollView.addConstraintsWithFormat(format: "V:|[v0(\(ScreenSize.screenHeight))]|", views: imageDetail)
        
        
        let tapZoom = UITapGestureRecognizer(target: self, action: #selector(zoomImage))
        tapZoom.numberOfTapsRequired = 2
        mainView.addGestureRecognizer(tapZoom)
    }
    
    @objc private func setupSquareFrame() {
        verticalFrameView.removeFromSuperview()
        let sizeFrame: CGFloat = mainView.bounds.width - 32
        scrollView.addSubview(squareFrameView)
        squareFrameView.widthAnchor.constraint(equalToConstant: sizeFrame).isActive = true
        squareFrameView.heightAnchor.constraint(equalToConstant: sizeFrame).isActive = true
        squareFrameView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -16).isActive = true
        squareFrameView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16).isActive = true
        squareFrameView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        squareFrameView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
    }
    
    @objc private func setupVerticalFrame() {
        squareFrameView.removeFromSuperview()
        scrollView.addSubview(verticalFrameView)
        verticalFrameView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 36).isActive = true
        verticalFrameView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -86).isActive = true
        verticalFrameView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -24).isActive = true
        verticalFrameView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 24).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupSquareFrame()
        
        setupBottomBarSizes()
        
    }
    
    private func setupBottomBarSizes() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        mainView.addSubview(view)
        view.widthAnchor.constraint(equalToConstant: mainView.bounds.width).isActive = true
        view.heightAnchor.constraint(equalToConstant: 64).isActive = true
        view.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        
        let sizeOne = UIButton(type: .system)
        sizeOne.setTitle("Vertical", for: .normal)
        sizeOne.addTarget(self, action: #selector(setupVerticalFrame), for: .touchUpInside)
        
        let sizeTwo = UIButton(type: .system)
        sizeTwo.setTitle("Cuadrada", for: .normal)
        sizeTwo.addTarget(self, action: #selector(setupSquareFrame), for: .touchUpInside)
        
        let sizeThree = UIButton(type: .system)
        sizeThree.setTitle("Otra", for: .normal)
        
        view.addSubview(sizeOne)
        view.addSubview(sizeTwo)
        view.addSubview(sizeThree)
        
        view.addConstraintsWithFormat(format: "H:|-[v0(80)]-[v1(80)]-[v2(60)]", views: sizeOne, sizeTwo, sizeThree)
        view.addConstraintsWithFormat(format: "V:|-[v0]", views: sizeOne)
        view.addConstraintsWithFormat(format: "V:|-[v0]", views: sizeTwo)
        view.addConstraintsWithFormat(format: "V:|-[v0]", views: sizeThree)
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageDetail
    }
    
    @objc func cerrar() {
        print("cerrar")
        // self.dismiss(animated: true, completion: nil)
    }
    
    // Oculta status-bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func zoomImage(_ recognizer: UITapGestureRecognizer) {
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
        else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }

}





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

