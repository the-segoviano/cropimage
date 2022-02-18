//
//  ViewController.swift
//  CropImage
//
//  Created by Luis Segoviano on 10/02/22.
//

import UIKit

enum ImageOrientation {
    case Portrait, Landscape, Square, unknown
}

class ViewController: UIViewController, UIScrollViewDelegate {

    var mainView: UIView {
        return self.view
    }
    
    var imageDetail: UIImageView = {
        let imageView = UIImageView() //
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "banner") // avatar, vertical, square, horizontal
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect.zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .black
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.isUserInteractionEnabled = true
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.flashScrollIndicators()
        scrollView.clipsToBounds = true // <!-- ¡IMPORTANT! -->
        return scrollView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        setupScrollView()
        setupImageViewContainer()
        setupBottomBarSizes()
        
        let orientation: ImageOrientation = validateImageOrientation(forImage: imageDetail.image!)
        print(" orientation ", orientation)
    }
    
    
    private func validateImageOrientation(forImage image: UIImage) -> ImageOrientation {
        if image.size.width > image.size.height {
            return .Landscape
        }
        if image.size.height > image.size.width {
            return .Portrait
        }
        if image.size.height == image.size.width {
            return .Square
        }
        return .unknown
    }
    
    
    private func setupScrollView(){
        scrollView.delegate = self
        mainView.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -64),
            scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
    
    private func setupImageViewContainer() {
        scrollView.addSubview(imageDetail)
        NSLayoutConstraint.activate([
            //imageDetail.widthAnchor.constraint(equalToConstant: ScreenSize.screenWidth),
            //imageDetail.heightAnchor.constraint(equalToConstant: ScreenSize.screenHeight),
            imageDetail.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageDetail.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageDetail.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageDetail.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            imageDetail.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageDetail.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    
    @objc private func setupSquareFrame() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut,
                       animations: {
            
            self.flowHeightVerticalConstraint?.constant = (self.mainView.bounds.width - 32)
            self.customFrameView.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    
    @objc private func setupVerticalFrame() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut,
                       animations: {
            
            self.flowHeightVerticalConstraint?.constant = 520
            
            self.customFrameView.layoutIfNeeded()
            
            
        }, completion: nil)
    }
    
    
    @objc private func setupHorizontalFrame() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut,
                       animations: {
            
            self.flowHeightVerticalConstraint?.constant = (self.mainView.bounds.width - 32) / 2
            self.customFrameView.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addZoomTapGesture()
        
        initialImageViewSetup()
    }
    
    
    var flowHeightVerticalConstraint: NSLayoutConstraint?
    
    let customFrameView = CustomFrameView()
    
    private func initialImageViewSetup() {
        let sizeFrame: CGFloat = mainView.bounds.width - 32
        
        scrollView.addSubview(customFrameView)
        
        customFrameView.widthAnchor.constraint(equalToConstant: sizeFrame).isActive = true
        flowHeightVerticalConstraint = customFrameView.heightAnchor.constraint(equalToConstant: sizeFrame)
        flowHeightVerticalConstraint?.isActive = true
        
        customFrameView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -16).isActive = true
        customFrameView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16).isActive = true
        customFrameView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        customFrameView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
    }
    
    
    private func addZoomTapGesture() {
        let tapZoom = UITapGestureRecognizer(target: self, action: #selector(zoomImage))
        tapZoom.numberOfTapsRequired = 2
        mainView.addGestureRecognizer(tapZoom)
    }
    
    private func setupBottomBarSizes() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        mainView.addSubview(view)
        
        view.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8).isActive = true
        view.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -8).isActive = true
        view.heightAnchor.constraint(equalToConstant: 45).isActive = true
        view.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -8).isActive = true
        
        let sizeOne = UIButton(type: .system)
        sizeOne.setTitle("Vertical", for: .normal)
        sizeOne.addTarget(self, action: #selector(setupVerticalFrame), for: .touchUpInside)
        
        let sizeTwo = UIButton(type: .system)
        sizeTwo.setTitle("Cuadrada", for: .normal)
        sizeTwo.addTarget(self, action: #selector(setupSquareFrame), for: .touchUpInside)
        
        let sizeThree = UIButton(type: .system)
        sizeThree.setTitle("Horizontal", for: .normal)
        sizeThree.addTarget(self, action: #selector(setupHorizontalFrame), for: .touchUpInside)
        
        let cropButton = UIButton(type: .system)
        cropButton.setTitle("Crop", for: .normal)
        
        
        view.addSubview(sizeOne)
        view.addSubview(sizeTwo)
        view.addSubview(sizeThree)
        view.addSubview(cropButton)
        
        view.addConstraintsWithFormat(format: "H:|-[v0(80)]-[v1(80)]-[v2(80)]-[v3]-|", views: sizeOne, sizeTwo, sizeThree, cropButton)
        view.addConstraintsWithFormat(format: "V:|-[v0]", views: sizeOne)
        view.addConstraintsWithFormat(format: "V:|-[v0]", views: sizeTwo)
        view.addConstraintsWithFormat(format: "V:|-[v0]", views: sizeThree)
        view.addConstraintsWithFormat(format: "V:|-[v0]", views: cropButton)
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageDetail
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


