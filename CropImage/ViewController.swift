//
//  ViewController.swift
//  CropImage
//
//  Created by Luis Segoviano on 10/02/22.
//

import UIKit

class CropImageViewController: UIViewController, UIScrollViewDelegate {

    //
    // Scope
    //
    var mainView: UIView {
        return self.view
    }
    
    static let imageDetailTag: Int = 1357911
    static let squareGridTag: Int = 1357901
    static let verticalGridTag: Int = 1357902
    static let horizontalGridTag: Int = 1357903
    
    var imageDetail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "vertical_2") // avatar, vertical, square, horizontal
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true // True para que la imagen respete los limites del Contenedor
        imageView.isUserInteractionEnabled = true
        imageView.tag = CropImageViewController.imageDetailTag
        return imageView
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect.zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .lightGray
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
    
    var constraintHeight: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        
        let widthScreen = self.view.frame.width
        let heightScreen = self.view.frame.height
        let halfWidth: CGFloat = widthScreen/2
        mainView.addSubview(imageDetail); imageDetail.addBorder(borderColor: .red, widthBorder: 2)
        
        
        NSLayoutConstraint.activate([
            imageDetail.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            imageDetail.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            imageDetail.widthAnchor.constraint(equalToConstant: widthScreen)
        ])
        constraintHeight? = imageDetail.heightAnchor.constraint(equalToConstant: widthScreen + halfWidth)
        constraintHeight?.isActive = true
        
        
    }
    
    // Sol. 3
    private func setupImageViewFromDidLoad_Sol3(){
        var aspectR: CGFloat = 0.0
        aspectR = imageDetail.image!.size.width/imageDetail.image!.size.height
        imageDetail.translatesAutoresizingMaskIntoConstraints = false
        imageDetail.image = imageDetail.image!
        imageDetail.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageDetail.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageDetail.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageDetail.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor),
            imageDetail.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
            imageDetail.heightAnchor.constraint(equalTo: imageDetail.widthAnchor, multiplier: 1/aspectR)
        ])
    }
    
    private func setupByScrollView(){
        let widthScreen = self.view.frame.width
        let heightScreen = self.view.frame.height
        let halfWidth: CGFloat = widthScreen/2
        mainView.addSubview(scrollView); scrollView.addBorder(borderColor: .red, widthBorder: 2)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            scrollView.widthAnchor.constraint(equalToConstant: widthScreen - 32),
            scrollView.heightAnchor.constraint(equalToConstant: widthScreen + halfWidth)
        ])
        scrollView.delegate = self
        let widthInPointsImage = imageDetail.image!.size.width
        let heightInPointsImage = imageDetail.image!.size.height
        
        if widthScreen > widthInPointsImage && heightScreen > heightInPointsImage {
            let orientation: Orientation = ImageOrientation.shared.validate(forImage: imageDetail.image!)
            scrollView.addSubview(imageDetail); imageDetail.addBorder(borderColor: .green, widthBorder: 2)
            if orientation == .Portrait {
                imageDetail.contentMode = .scaleAspectFill
                scrollView.alwaysBounceHorizontal = false
                NSLayoutConstraint.activate([
                    imageDetail.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
                    imageDetail.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                    imageDetail.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
                    imageDetail.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0),
                    imageDetail.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0),
                    imageDetail.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
                ])
            }
            if orientation == .Landscape {
                imageDetail.contentMode = .scaleToFill
                scrollView.alwaysBounceHorizontal = true
                scrollView.alwaysBounceVertical = false
                NSLayoutConstraint.activate([
                    imageDetail.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                    imageDetail.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
                    imageDetail.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0),
                    imageDetail.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0),
                ])
            }
        }
        else{
            imageDetail.contentMode = .center
            scrollView.alwaysBounceHorizontal = true
            scrollView.alwaysBounceVertical = true
            scrollView.addSubview(imageDetail); imageDetail.addBorder(borderColor: .blue, widthBorder: 2)
            NSLayoutConstraint.activate([
                imageDetail.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
                imageDetail.widthAnchor.constraint(equalToConstant: widthInPointsImage),
                imageDetail.heightAnchor.constraint(equalToConstant: heightInPointsImage)
            ])
            self.scrollView.contentSize.height = heightInPointsImage
            self.scrollView.contentSize.width = widthInPointsImage
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Configura Grid
        // setupGridOverView()
        // setupVerticalGridView()
        
        
        
        /*
        DispatchQueue.main.async {
            //self.heightAnchorConstraintImage?.constant = heightInPointsImage
            //self.heightAnchorConstraintScroll?.constant = heightInPointsImage
            self.scrollView.layoutIfNeeded()
        }
        */
    }
    
    private func updateImageView_Sol1(){
        let height = imageDetail.image!.size.height
        let wisth = imageDetail.image!.size.width
        let ratio = wisth / height
        let newHeight = imageDetail.frame.width / ratio
        constraintHeight?.constant = newHeight
        view.layoutIfNeeded()
    }
    
    private func updateImageView_Sol2(){
        if let image = imageDetail.image {
            let ratio = image.size.width / image.size.height
            if self.view.frame.width > self.view.frame.height {
                let newHeight = self.view.frame.width / ratio
                imageDetail.frame.size = CGSize(width: self.view.frame.width, height: newHeight)
            }
            else{
                let newWidth = self.view.frame.height * ratio
                imageDetail.frame.size = CGSize(width: newWidth, height: self.view.frame.height)
            }
        }
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
        squareGridView.tag = CropImageViewController.squareGridTag
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
        verticalGridView.tag = CropImageViewController.verticalGridTag
        scrollView.addSubview(verticalGridView)
        let sizeFrame: CGFloat = mainView.bounds.width - 32
        verticalGridView.widthAnchor.constraint(equalToConstant: sizeFrame).isActive = true
        verticalGridView.centerXAnchor.constraint(equalTo: self.mainView.centerXAnchor).isActive = true
        verticalGridView.centerYAnchor.constraint(equalTo: self.mainView.centerYAnchor).isActive = true
        verticalGridView.topAnchor.constraint(equalTo: self.mainView.topAnchor, constant: self.topMargin + 16).isActive = true
        verticalGridView.bottomAnchor.constraint(equalTo: self.mainView.bottomAnchor, constant: -72).isActive = true
    }
    
    
    private func setupHorizontalGridView() {
        horizontalGridView.tag = CropImageViewController.horizontalGridTag
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
        cropButton.addTarget(self, action: #selector(cropImage), for: .touchUpInside)
        
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
    
    
    @objc private func cropImage() {
        
        if let imageView: UIImageView = mainView.viewWithTag(CropImageViewController.imageDetailTag) as? UIImageView {
            print(" imageView ", imageView.frame, imageView.bounds, "\n")
        }
        
        if let squareGridView: UIView = mainView.viewWithTag(CropImageViewController.squareGridTag) {
            print(" squareGridView ", squareGridView.frame, squareGridView.bounds, "\n")
        }
        
        if let verticalGridView: UIView = mainView.viewWithTag(CropImageViewController.verticalGridTag) {
            print(" verticalGridView ", verticalGridView.frame, verticalGridView.bounds, "\n")
        }
        
        if let horizontalGridView: UIView = mainView.viewWithTag(CropImageViewController.horizontalGridTag) {
            print(" verticalGridView ", horizontalGridView.frame, horizontalGridView.bounds, "\n")
        }
        
    }
    
    
    //
    // MARK: - Delegate Scrollview
    //
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageDetail
    }
    
    
}


