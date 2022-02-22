//
//  ViewController.swift
//  CropImage
//
//  Created by Luis Segoviano on 10/02/22.
//

import UIKit

class CropImageViewController: UIViewController, UIScrollViewDelegate {

    var mainView: UIView {
        return self.view
    }
    
    var imageDetail: UIImageView = {
        let imageView = ScaledHeightImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "vertical") // avatar, vertical, square, horizontal
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true // True para que la imagen respete los limites del Contenedor
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
        scrollView.alwaysBounceHorizontal = true
        scrollView.flashScrollIndicators()
        scrollView.clipsToBounds = true // <!-- ¡IMPORTANT! -->
        return scrollView
    }()
    
    //
    // Lifecycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        setupScrollView()
        setupImageViewContainer()
        setupBottomBarSizes()
        
        // let orientation: Orientation = ImageOrientation.shared.validate(forImage: imageDetail.image!)
        // print(" orientation ", orientation)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addZoomTapGesture()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Configura Grid
        // setupGridOverView()
        setupVerticalGridView()
    }
    
    
    //
    // MARK: Setup views
    //
    
    let topMargin: CGFloat = 32
    let bottomMargin: CGFloat = -64
    
    private func setupScrollView(){
        scrollView.delegate = self
        mainView.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topMargin),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: bottomMargin),
            scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
    
    private func setupImageViewContainer() {
        scrollView.addSubview(imageDetail)
        NSLayoutConstraint.activate([
            imageDetail.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageDetail.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageDetail.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            imageDetail.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8),
            imageDetail.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 8),
            imageDetail.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -8)
        ])
    }
    
    //
    // MARK: - Funciones para ajustar Grid
    //
    @objc private func setupSquareGrid() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut,
                       animations: {
            
            self.verticalGridView.removeFromSuperview()
            self.horizontalGridView.removeFromSuperview()
            self.setupGridOverView()
            
        }, completion: nil)
    }
    
    
    @objc private func setupVerticalGrid() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut,
                       animations: {
            
            self.squareGridView.removeFromSuperview()
            self.horizontalGridView.removeFromSuperview()
            self.setupVerticalGridView()
            
        }, completion: nil)
    }
    
    
    @objc private func setupHorizontalGrid() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut,
                       animations: {
            
            self.squareGridView.removeFromSuperview()
            self.verticalGridView.removeFromSuperview()
            self.setupHorizontalGridView()
            
        }, completion: nil)
    }
    
    let squareGridView = CustomGridView()
    
    let verticalGridView = CustomGridView()
    
    let horizontalGridView = CustomGridView()
    
    
    private func setupGridOverView() {
        let sizeFrame: CGFloat = mainView.bounds.width - 32
        scrollView.addSubview(squareGridView)
        squareGridView.heightAnchor.constraint(equalToConstant: sizeFrame).isActive = true
        squareGridView.widthAnchor.constraint(equalToConstant: sizeFrame).isActive = true
        squareGridView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -16).isActive = true
        squareGridView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16).isActive = true
        squareGridView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        squareGridView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
    }
    
    private func setupVerticalGridView() {
        scrollView.addSubview(verticalGridView)
        
        let sizeFrame: CGFloat = mainView.bounds.width - 32
        
        verticalGridView.widthAnchor.constraint(equalToConstant: sizeFrame).isActive = true
        
        verticalGridView.centerXAnchor.constraint(equalTo: self.mainView.centerXAnchor).isActive = true
        verticalGridView.centerYAnchor.constraint(equalTo: self.mainView.centerYAnchor).isActive = true
        verticalGridView.topAnchor.constraint(equalTo: self.mainView.topAnchor, constant: self.topMargin + 16).isActive = true
        verticalGridView.bottomAnchor.constraint(equalTo: self.mainView.bottomAnchor, constant: -72).isActive = true
    }
    
    
    private func setupHorizontalGridView() {
        
        scrollView.addSubview(horizontalGridView)
        
        let sizeFrame: CGFloat = mainView.bounds.width - 32
        let sizeHeight: CGFloat = (mainView.bounds.width - 32) / 2
        
        
        horizontalGridView.heightAnchor.constraint(equalToConstant: sizeHeight).isActive = true
        horizontalGridView.widthAnchor.constraint(equalToConstant: sizeFrame).isActive = true
        
        horizontalGridView.centerXAnchor.constraint(equalTo: self.mainView.centerXAnchor).isActive = true
        horizontalGridView.centerYAnchor.constraint(equalTo: self.mainView.centerYAnchor).isActive = true
    }
    
    
    
    
    private func addZoomTapGesture() {
        let tapZoom = UITapGestureRecognizer(target: self, action: #selector(zoomImage))
        tapZoom.numberOfTapsRequired = 2
        mainView.addGestureRecognizer(tapZoom)
    }
    
    @objc func zoomImage(_ recognizer: UITapGestureRecognizer) {
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
        else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
    //
    // MARK: - Bottom Bar
    //
    
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
        sizeOne.addTarget(self, action: #selector(setupVerticalGrid), for: .touchUpInside)
        
        let sizeTwo = UIButton(type: .system)
        sizeTwo.setTitle("Cuadrada", for: .normal)
        sizeTwo.addTarget(self, action: #selector(setupSquareGrid), for: .touchUpInside)
        
        let sizeThree = UIButton(type: .system)
        sizeThree.setTitle("Horizontal", for: .normal)
        sizeThree.addTarget(self, action: #selector(setupHorizontalGrid), for: .touchUpInside)
        
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
    
    
    //
    // MARK: - Delegate Scrollview
    //
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageDetail
    }
    
    
}


