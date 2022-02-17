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
    
    var imageDetail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "square") // avatar
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
        scrollView.maximumZoomScale = 3.0
        scrollView.isUserInteractionEnabled = true
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.flashScrollIndicators()
        scrollView.clipsToBounds = false
        return scrollView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .black
        setupScrollView()
        setupImageViewContainer()
        setupBottomBarSizes()
    }
    
    private func setupScrollView(){
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
    }
    
    private func setupImageViewContainer() {
        scrollView.addSubview(imageDetail)
        NSLayoutConstraint.activate([
            imageDetail.widthAnchor.constraint(equalToConstant: ScreenSize.screenWidth),
            imageDetail.heightAnchor.constraint(equalToConstant: ScreenSize.screenHeight),
            imageDetail.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageDetail.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
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
        
        /*
        verticalFrameView.removeFromSuperview()
        let sizeFrame: CGFloat = mainView.bounds.width - 32
        scrollView.addSubview(squareFrameView)
        squareFrameView.widthAnchor.constraint(equalToConstant: sizeFrame).isActive = true
        squareFrameView.heightAnchor.constraint(equalToConstant: sizeFrame).isActive = true
        squareFrameView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -16).isActive = true
        squareFrameView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16).isActive = true
        squareFrameView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        squareFrameView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        */
    }
    
    @objc private func setupVerticalFrame() {
        /*
        squareFrameView.removeFromSuperview()
        scrollView.addSubview(verticalFrameView)
        verticalFrameView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 36).isActive = true
        verticalFrameView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -86).isActive = true
        verticalFrameView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -24).isActive = true
        verticalFrameView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 24).isActive = true
        */
        
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
    
    
    var flowHeightVerticalConstraint: NSLayoutConstraint?
    var flowHeightSquareConstraint: NSLayoutConstraint?
    
    let customFrameView = CustomFrameView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addZoomTapGesture()
        
        // setupSquareFrame()
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
        view.widthAnchor.constraint(equalToConstant: mainView.bounds.width).isActive = true
        view.heightAnchor.constraint(equalToConstant: 45).isActive = true
        view.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        
        let sizeOne = UIButton(type: .system)
        sizeOne.setTitle("Vertical", for: .normal)
        sizeOne.addTarget(self, action: #selector(setupVerticalFrame), for: .touchUpInside)
        
        let sizeTwo = UIButton(type: .system)
        sizeTwo.setTitle("Cuadrada", for: .normal)
        sizeTwo.addTarget(self, action: #selector(setupSquareFrame), for: .touchUpInside)
        
        let sizeThree = UIButton(type: .system)
        sizeThree.setTitle("Otra", for: .normal)
        
        let cropButton = UIButton(type: .system)
        cropButton.setTitle("Crop", for: .normal)
        
        
        view.addSubview(sizeOne)
        view.addSubview(sizeTwo)
        view.addSubview(sizeThree)
        view.addSubview(cropButton)
        
        view.addConstraintsWithFormat(format: "H:|-[v0(80)]-[v1(80)]-[v2(60)]-(<=8)-[v3]-|", views: sizeOne, sizeTwo, sizeThree, cropButton)
        view.addConstraintsWithFormat(format: "V:|-[v0]", views: sizeOne)
        view.addConstraintsWithFormat(format: "V:|-[v0]", views: sizeTwo)
        view.addConstraintsWithFormat(format: "V:|-[v0]", views: sizeThree)
        view.addConstraintsWithFormat(format: "V:|-[v0]", views: cropButton)
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


