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
        
        // Configura Grid
        setupGridOverView()
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
        // imageDetail.addBorder(borderColor: .purple, widthBorder: 2.0)
        
        scrollView.addSubview(imageDetail)
        NSLayoutConstraint.activate([
            
            imageDetail.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageDetail.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            //imageDetail.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            //imageDetail.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
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
            
            self.flowHeightVerticalConstraint?.constant = (self.mainView.bounds.width - 32)
            self.gridView.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    
    @objc private func setupVerticalGrid() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut,
                       animations: {
            
            self.flowHeightVerticalConstraint?.constant = self.imageDetail.bounds.height - 32
            
            self.gridView.layoutIfNeeded()
            
            
        }, completion: nil)
    }
    
    
    @objc private func setupHorizontalGrid() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut,
                       animations: {
            
            self.flowHeightVerticalConstraint?.constant = (self.mainView.bounds.width - 32) / 2
            self.gridView.layoutIfNeeded()
            
            //self?.topAnchorConstraint?
            
        }, completion: nil)
    }
    
    
    var flowHeightVerticalConstraint: NSLayoutConstraint?
    
    var topAnchorConstraint: NSLayoutYAxisAnchor? // NSLayoutXAxisAnchor
    
    let gridView = CustomFrameView()
    
    private func setupGridOverView() {
        let sizeFrame: CGFloat = mainView.bounds.width - 32
        
        scrollView.addSubview(gridView)
        
        flowHeightVerticalConstraint = gridView.heightAnchor.constraint(equalToConstant: sizeFrame)
        flowHeightVerticalConstraint?.isActive = true
        
        //gridView.heightAnchor.constraint(equalToConstant: sizeFrame).isActive = true
        gridView.widthAnchor.constraint(equalToConstant: sizeFrame).isActive = true
        gridView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -16).isActive = true
        gridView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16).isActive = true
        gridView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        
        
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
    
    /*
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideGrid()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            showGrid()
        } else {
            hideGrid()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        showGrid()
    }
    func showGrid() {
        gridView.isHidden = false
    }
    func hideGrid() {
        gridView.isHidden = true
    }
    */
    
}


