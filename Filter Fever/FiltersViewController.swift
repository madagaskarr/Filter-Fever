// Ghazinyan Tigran 2018

import UIKit


class FiltersViewController: UIViewController {

    var selectedPictureImageView: UIImageView!
    var selectedImage: UIImage?
    var collectionView: UICollectionView!
    var myImageArray = [UIImage]()
    var myNameArray = [String]()
    var context: CIContext!
    var filter: CIFilter!
    var filteredImage: CIImage!
    var originalImage: UIImage!
    var beginImage: CIImage!
    var sliderValue: Float!
    var brightnessSlider: UISlider!
    var brightnessLabel: UILabel!
    var brightnessValueLabel: UILabel!
    var contrastSlider: UISlider!
    var contrastLabel: UILabel!
    var contrastValueLabel: UILabel!
    var saturationSlider: UISlider!
    var saturationLabel: UILabel!
    var saturationValueLabel: UILabel!
    var sharpenSlider: UISlider!
    var sharpenLabel: UILabel!
    var sharpenValueLabel: UILabel!
    var scrollView: UIScrollView!
    var activity: UIActivityIndicatorView!
    var nameCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        title = "Filter Fever"
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        
        myNameArray = ["January","February","March","April","May","June","July","August","September","October","November","December"]
        
        // MARK: Cancel Bar Button Item
        let cancelIconImage = UIImage(named: "cancel")
        let leftBarButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(goBackToHomeScreen))
        leftBarButton.tintColor = .black
        leftBarButton.image = cancelIconImage
        navigationItem.leftBarButtonItem = leftBarButton
        
        // MARK: Save Bar Button Item
        let saveIconImage = UIImage(named: "checkmark")
        let rightBarButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(saveImageToGallery))
        rightBarButton.tintColor = .black
        rightBarButton.image = saveIconImage
        navigationItem.rightBarButtonItem = rightBarButton
        
        // MARK: Main Image View
        selectedPictureImageView = UIImageView()
        selectedPictureImageView.contentMode = .scaleAspectFit
        selectedPictureImageView.image = selectedImage
        beginImage = CIImage(image: selectedPictureImageView.image!)
        originalImage = selectedPictureImageView.image
        selectedPictureImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectedPictureImageView)
        selectedPictureImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationController?.navigationBar.frame.height ?? 0).isActive = true
        selectedPictureImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        selectedPictureImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        selectedPictureImageView.heightAnchor.constraint(equalToConstant: view.bounds.size.width).isActive = true
        selectedPictureImageView.widthAnchor.constraint(equalToConstant: view.bounds.size.width).isActive = true
        
        //MARK: Collection View Layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 95)
        
        //MARK: Collection View
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        self.view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.topAnchor.constraint(equalTo: selectedPictureImageView.bottomAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 95).isActive = true

        
        //MARK: Activity Indicator
        activity = UIActivityIndicatorView(style: .gray)
        activity.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activity)
        activity.topAnchor.constraint(equalTo: selectedPictureImageView.bottomAnchor, constant: 20).isActive = true
        activity.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        activity.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        activity.heightAnchor.constraint(equalToConstant: 20).isActive = true
        activity.isHidden = false
        activity.startAnimating()
        
        DispatchQueue.main.async {
            
            self.configureFilters()
        }
        

        
        //MARK: Scroll View
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 812))
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.isDirectionalLockEnabled = true
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        //MARK: Brightness Label
        brightnessLabel = UILabel()
        brightnessLabel.text = "Brightness"
        brightnessLabel.font = UIFont(name: "Avenir", size: 14)
        brightnessLabel.textColor = .black
        brightnessLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(brightnessLabel)
        brightnessLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        brightnessLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: view.bounds.width / -2).isActive = true
        brightnessLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        brightnessLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        //MARK: Brightness Slider
        brightnessSlider = UISlider()
        brightnessSlider.setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        brightnessSlider.tintColor = .black
        brightnessSlider.minimumValue = -1.0
        brightnessSlider.value = 0
        brightnessSlider.maximumValue = 1.0
        brightnessSlider.tag = 0
        brightnessSlider.translatesAutoresizingMaskIntoConstraints = false
        brightnessSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        brightnessSlider.addTarget(self, action: #selector(sliderValueDidEnd(_:)), for: [.touchUpInside, .touchUpOutside])
        scrollView.addSubview(brightnessSlider)
        brightnessSlider.topAnchor.constraint(equalTo: brightnessLabel.bottomAnchor, constant: 5).isActive = true
        brightnessSlider.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10).isActive = true
        brightnessSlider.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        brightnessSlider.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        //MArk: Brightness Value Label
        brightnessValueLabel = UILabel()
        brightnessValueLabel.text = "50"
        brightnessValueLabel.font = UIFont(name: "Avenir", size: 14)
        brightnessValueLabel.textColor = .black
        brightnessValueLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(brightnessValueLabel)
        brightnessValueLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        brightnessValueLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10).isActive = true
        brightnessValueLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant:  view.bounds.width - 30).isActive = true
        brightnessValueLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        //MARK: Contrast Label
        contrastLabel = UILabel()
        contrastLabel.text = "Contrast"
        contrastLabel.font = UIFont(name: "Avenir", size: 14)
        contrastLabel.textColor = .black
        contrastLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contrastLabel)
        contrastLabel.topAnchor.constraint(equalTo: brightnessSlider.bottomAnchor, constant: 10).isActive = true
        contrastLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: view.bounds.width / -2).isActive = true
        contrastLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        contrastLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        //MARK: Contrast Slider
        contrastSlider = UISlider()
        contrastSlider.setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        contrastSlider.tintColor = .black
        contrastSlider.minimumValue = 0
        contrastSlider.maximumValue = 2
        contrastSlider.value = 1
        contrastSlider.tag = 1
        contrastSlider.translatesAutoresizingMaskIntoConstraints = false
        contrastSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        contrastSlider.addTarget(self, action: #selector(sliderValueDidEnd(_:)), for: [.touchUpInside, .touchUpOutside])
        scrollView.addSubview(contrastSlider)
        contrastSlider.topAnchor.constraint(equalTo: contrastLabel.bottomAnchor, constant: 5).isActive = true
        contrastSlider.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10).isActive = true
        contrastSlider.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        contrastSlider.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        //MArk: Contrast Value Label
        contrastValueLabel = UILabel()
        contrastValueLabel.text = "50"
        contrastValueLabel.font = UIFont(name: "Avenir", size: 14)
        contrastValueLabel.translatesAutoresizingMaskIntoConstraints = false
        contrastValueLabel.textColor = .black
        scrollView.addSubview(contrastValueLabel)
        contrastValueLabel.topAnchor.constraint(equalTo: brightnessSlider.bottomAnchor, constant: 10).isActive = true
        contrastValueLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10).isActive = true
        contrastValueLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant:  view.bounds.width - 30).isActive = true
        contrastValueLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        //MARK: Saturation Label
        saturationLabel = UILabel()
        saturationLabel.text = "Saturation"
        saturationLabel.font = UIFont(name: "Avenir", size: 14)
        saturationLabel.translatesAutoresizingMaskIntoConstraints = false
        saturationLabel.textColor = .black
        scrollView.addSubview(saturationLabel)
        saturationLabel.topAnchor.constraint(equalTo: contrastSlider.bottomAnchor, constant: 10).isActive = true
        saturationLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: view.bounds.width / -2).isActive = true
        saturationLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        saturationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        //MARK: Saturation Slider
        saturationSlider = UISlider()
        saturationSlider.setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        saturationSlider.tintColor = .black
        saturationSlider.minimumValue = 0
        saturationSlider.maximumValue = 2
        saturationSlider.value = 1
        saturationSlider.tag = 2
        saturationSlider.translatesAutoresizingMaskIntoConstraints = false
        saturationSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        saturationSlider.addTarget(self, action: #selector(sliderValueDidEnd(_:)), for: [.touchUpInside, .touchUpOutside])
        scrollView.addSubview(saturationSlider)
        saturationSlider.topAnchor.constraint(equalTo: saturationLabel.bottomAnchor, constant: 5).isActive = true
        saturationSlider.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10).isActive = true
        saturationSlider.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        saturationSlider.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        //MArk: Saturation Value Label
        saturationValueLabel = UILabel()
        saturationValueLabel.text = "50"
        saturationValueLabel.font = UIFont(name: "Avenir", size: 14)
        saturationValueLabel.textColor = .black
        saturationValueLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(saturationValueLabel)
        saturationValueLabel.topAnchor.constraint(equalTo: contrastSlider.bottomAnchor, constant: 10).isActive = true
        saturationValueLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10).isActive = true
        saturationValueLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant:  view.bounds.width - 30).isActive = true
        saturationValueLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        //MARK: Noise Label
        sharpenLabel = UILabel()
        sharpenLabel.text = "Sharpen"
        sharpenLabel.font = UIFont(name: "Avenir", size: 14)
        sharpenLabel.textColor = .black
        sharpenLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(sharpenLabel)
        sharpenLabel.topAnchor.constraint(equalTo: saturationSlider.bottomAnchor, constant: 10).isActive = true
        sharpenLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: view.bounds.width / -2).isActive = true
        sharpenLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        sharpenLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        //MARK: Noise Slider
        sharpenSlider = UISlider()
        sharpenSlider.setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        sharpenSlider.tintColor = .black
        sharpenSlider.minimumValue = 0
        sharpenSlider.maximumValue = 1
        sharpenSlider.value = 0.5
        sharpenSlider.tag = 3
        sharpenSlider.translatesAutoresizingMaskIntoConstraints = false
        sharpenSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        sharpenSlider.addTarget(self, action: #selector(sliderValueDidEnd(_:)), for: [.touchUpInside, .touchUpOutside])


        scrollView.addSubview(sharpenSlider)
        sharpenSlider.topAnchor.constraint(equalTo: sharpenLabel.bottomAnchor, constant: 5).isActive = true
        sharpenSlider.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10).isActive = true
        sharpenSlider.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        sharpenSlider.heightAnchor.constraint(equalToConstant: 25).isActive = true
        sharpenSlider.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        
        //MArk: Noise Value Label
        sharpenValueLabel = UILabel()
        sharpenValueLabel.text = "50"
        sharpenValueLabel.font = UIFont(name: "Avenir", size: 14)
        sharpenValueLabel.textColor = .black
        sharpenValueLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(sharpenValueLabel)
        sharpenValueLabel.topAnchor.constraint(equalTo: saturationSlider.bottomAnchor, constant: 10).isActive = true
        sharpenValueLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10).isActive = true
        sharpenValueLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant:  view.bounds.width - 30).isActive = true
        sharpenValueLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        

        
    }
    
    @objc func goBackToHomeScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func saveImageToGallery() {
        
        guard let imageToSave = selectedPictureImageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)

        let alert = UIAlertController(title: "Saved!", message: "Your picture has been sucessfully saved!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }

    
    func configureFilters() {
        
        context = CIContext()

        filter = CIFilter(name: "CIPhotoEffectInstant")
        filter?.setValue(beginImage, forKey: kCIInputImageKey)
        filteredImage = filter?.outputImage
        var newImageFromContext = UIImage(cgImage: context.createCGImage(filteredImage!, from: (filteredImage?.extent)!)!)
        myImageArray.append(newImageFromContext)
        let newImage6 = mergeTwoImages(imageOne: selectedPictureImageView.image!, imageTwo: newImageFromContext, blendingMode: .overlay, alpha: 0.9)
        myImageArray.append(newImage6)
        
        
        
        filter = CIFilter(name: "CIPhotoEffectTransfer")
        filter?.setValue(beginImage, forKey: kCIInputImageKey)
        filteredImage = filter?.outputImage
        newImageFromContext = UIImage(cgImage: context.createCGImage(filteredImage!, from: (filteredImage?.extent)!)!)
        myImageArray.append(newImageFromContext)
        let newImage10 = mergeTwoImages(imageOne: newImage6, imageTwo: newImageFromContext, blendingMode: .overlay, alpha: 0.8)
        myImageArray.append(newImage10)
        
        
        filter = CIFilter(name: "CIPhotoEffectNoir")
        filter?.setValue(beginImage, forKey: kCIInputImageKey)
        filteredImage = filter?.outputImage
        newImageFromContext = UIImage(cgImage: context.createCGImage(filteredImage!, from: (filteredImage?.extent)!)!)
        myImageArray.append(newImageFromContext)
        
        
        filter = CIFilter(name: "CIColorCrossPolynomial")
        filter?.setValue(beginImage, forKey: kCIInputImageKey)
        var randomVectorRed: [CGFloat] = [0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3]
        var randomVectorGreen: [CGFloat] = [0.0,0,0.4,0,0.1,0,0,0,0.7]
        var randomVectorBlue: [CGFloat] = [0.1,0,0,0,0,0,0,0,0]
        var redArray: [CGFloat] = randomVectorRed
        var redVector = CIVector(values: redArray, count: redArray.count)
        filter?.setValue(redVector, forKey: "inputRedCoefficients")
        var greenArray: [CGFloat] = randomVectorGreen
        var greenVector = CIVector(values: greenArray, count: greenArray.count)
        filter?.setValue(greenVector, forKey: "inputGreenCoefficients")
        var blueArray: [CGFloat] = randomVectorBlue
        var blueVector = CIVector(values: blueArray, count: blueArray.count)
        filter?.setValue(blueVector, forKey: "inputBlueCoefficients")
        filteredImage = filter?.outputImage
        let newImage102 = mergeTwoImages(imageOne: newImage10, imageTwo: newImageFromContext, blendingMode: .overlay, alpha: 0.8)
        myImageArray.append(newImage102)
        newImageFromContext = UIImage(cgImage: context.createCGImage(filteredImage!, from: (filteredImage?.extent)!)!)
        let newImage142 = mergeTwoImages(imageOne: newImage6, imageTwo: newImageFromContext, blendingMode: .overlay, alpha: 0.5)
        myImageArray.append(newImage142)
        
        filter = CIFilter(name: "CIColorCrossPolynomial")
        filter?.setValue(beginImage, forKey: kCIInputImageKey)
        randomVectorRed = [0.3,0.3,0.3,2.3,0.3,3.3,0.3,3.3,2.3]
        randomVectorGreen = [0.0,0,4.4,0,0.1,0,0,0,0.7]
        randomVectorBlue = [0.1,0,0,0,0,43,0,0,32]
        redArray = randomVectorRed
        redVector = CIVector(values: redArray, count: redArray.count)
        filter?.setValue(redVector, forKey: "inputRedCoefficients")
        greenArray = randomVectorGreen
        greenVector = CIVector(values: greenArray, count: greenArray.count)
        filter?.setValue(greenVector, forKey: "inputGreenCoefficients")
        blueArray = randomVectorBlue
        blueVector = CIVector(values: blueArray, count: blueArray.count)
        filter?.setValue(blueVector, forKey: "inputBlueCoefficients")
        filteredImage = filter?.outputImage
        newImageFromContext = UIImage(cgImage: context.createCGImage(filteredImage!, from: (filteredImage?.extent)!)!)
        let newImage1042 = mergeTwoImages(imageOne: newImage6, imageTwo: newImageFromContext, blendingMode: .overlay, alpha: 0.5)
        myImageArray.append(newImage1042)
        
        filter = CIFilter(name: "CIColorCrossPolynomial")
        filter?.setValue(beginImage, forKey: kCIInputImageKey)
        randomVectorRed = [0.9, 0.9, 0.1, 0.9, 0.9, 0.1, 0.3, 0.3, 0.3]
        randomVectorGreen = [0.13, 0.67, 0.8, 0.7, 0.1, 0.3, 0.9, 0.2, 0.3]
        randomVectorBlue = [0.9, 0.2, 0.1, 0.3, 0.1, 0.1, 0.9, 0.3, 0.3]
        redArray = randomVectorRed
        redVector = CIVector(values: redArray, count: redArray.count)
        filter?.setValue(redVector, forKey: "inputRedCoefficients")
        greenArray = randomVectorGreen
        greenVector = CIVector(values: greenArray, count: greenArray.count)
        filter?.setValue(greenVector, forKey: "inputGreenCoefficients")
        blueArray = randomVectorBlue
        blueVector = CIVector(values: blueArray, count: blueArray.count)
        filter?.setValue(blueVector, forKey: "inputBlueCoefficients")
        filteredImage = filter?.outputImage
        newImageFromContext = UIImage(cgImage: context.createCGImage(filteredImage!, from: (filteredImage?.extent)!)!)
        let newImage1142 = mergeTwoImages(imageOne: newImage6, imageTwo: newImageFromContext, blendingMode: .overlay, alpha: 0.5)
        myImageArray.append(newImage1142)
        
        filter = CIFilter(name: "CIColorCrossPolynomial")
        filter?.setValue(beginImage, forKey: kCIInputImageKey)
        randomVectorRed = [0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3]
        randomVectorGreen = [0.0, 0.0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, 0.0]
        randomVectorBlue = [0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        redArray = randomVectorRed
        redVector = CIVector(values: redArray, count: redArray.count)
        filter?.setValue(redVector, forKey: "inputRedCoefficients")
        greenArray = randomVectorGreen
        greenVector = CIVector(values: greenArray, count: greenArray.count)
        filter?.setValue(greenVector, forKey: "inputGreenCoefficients")
        blueArray = randomVectorBlue
        blueVector = CIVector(values: blueArray, count: blueArray.count)
        filter?.setValue(blueVector, forKey: "inputBlueCoefficients")
        filteredImage = filter?.outputImage
        newImageFromContext = UIImage(cgImage: context.createCGImage(filteredImage!, from: (filteredImage?.extent)!)!)
        let newImage122 = mergeTwoImages(imageOne: newImage6, imageTwo: newImageFromContext, blendingMode: .overlay, alpha: 0.2)
        myImageArray.append(newImage122)
        let newImage1232 = mergeTwoImages(imageOne: newImage1042, imageTwo: newImageFromContext, blendingMode: .overlay, alpha: 0.5)
        myImageArray.append(newImage1232)
        
        filter = CIFilter(name: "CIColorCrossPolynomial")
        filter?.setValue(beginImage, forKey: kCIInputImageKey)
        randomVectorRed = [0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3]
        randomVectorGreen = [1, 5, 4, 2, 0.9, 0.0, 0.0, 0.0, 0.0]
        randomVectorBlue = [20, 0.4, 24, 0.7, 0.8, 0.9, 0.0, 0.0, 0.0]
        redArray = randomVectorRed
        redVector = CIVector(values: redArray, count: redArray.count)
        filter?.setValue(redVector, forKey: "inputRedCoefficients")
        greenArray = randomVectorGreen
        greenVector = CIVector(values: greenArray, count: greenArray.count)
        filter?.setValue(greenVector, forKey: "inputGreenCoefficients")
        blueArray = randomVectorBlue
        blueVector = CIVector(values: blueArray, count: blueArray.count)
        filter?.setValue(blueVector, forKey: "inputBlueCoefficients")
        filteredImage = filter?.outputImage
        newImageFromContext = UIImage(cgImage: context.createCGImage(filteredImage!, from: (filteredImage?.extent)!)!)
        let newImage122f = mergeTwoImages(imageOne: newImage10, imageTwo: newImageFromContext, blendingMode: .overlay, alpha: 0.4)
        myImageArray.append(newImage122f)
        
        collectionView.reloadData()
        activity.isHidden = true
        activity.stopAnimating()
    }
    
    @objc func sliderValueDidEnd(_ sender: UISlider!) {
        
        if sender.tag == 0 {
            originalImage = selectedPictureImageView.image
            sliderValue = sender.value
        } else if sender.tag == 1 {
            originalImage = selectedPictureImageView.image
            sender.value = sliderValue
        } else if sender.tag == 2 {
            originalImage = selectedPictureImageView.image
            sender.value = sliderValue
        } else if sender.tag == 3 {
            originalImage = selectedPictureImageView.image
            sender.value = sliderValue
        }
    }
    
    
    
    @objc func sliderValueDidChange(_ sender: UISlider!) {
        
        if sender.tag == 0 {
            
            let displayinPercentage: Int = Int((sender.value/200) * 10000)
            brightnessValueLabel.text = ("\(displayinPercentage)")
            selectedPictureImageView.image = originalImage
            let beginImage = CIImage(image: selectedPictureImageView.image!)
            self.filter = CIFilter(name: "CIColorControls")
            self.filter?.setValue(beginImage, forKey: kCIInputImageKey)
            self.filter.setValue(sender.value, forKey: kCIInputBrightnessKey)
            self.filteredImage = self.filter?.outputImage
            selectedPictureImageView.image = UIImage(cgImage: self.context.createCGImage(self.filteredImage!, from: (self.filteredImage?.extent)!)!)
            sliderValue = sender.value
            
            
        } else if sender.tag == 1 {
            
            let displayinPercentage: Int = Int((sender.value/200) * 10000)
            contrastValueLabel.text = ("\(displayinPercentage)")
            self.selectedPictureImageView.image = originalImage
            let beginImage = CIImage(image: self.selectedPictureImageView.image!)
            self.filter = CIFilter(name: "CIColorControls")
            self.filter?.setValue(beginImage, forKey: kCIInputImageKey)
            self.filter.setValue(sender.value, forKey: kCIInputContrastKey)
            self.filteredImage = self.filter?.outputImage
            self.selectedPictureImageView.image = UIImage(cgImage: self.context.createCGImage(self.filteredImage!, from: (self.filteredImage?.extent)!)!)
            sliderValue = sender.value

            
            
        } else if sender.tag == 2 {
            
            let displayinPercentage: Int = Int((sender.value/200) * 10000)
            saturationValueLabel.text = ("\(displayinPercentage)")
            self.selectedPictureImageView.image = originalImage
            let beginImage = CIImage(image: self.selectedPictureImageView.image!)
            self.filter = CIFilter(name: "CIColorControls")
            self.filter?.setValue(beginImage, forKey: kCIInputImageKey)
            self.filter.setValue(sender.value, forKey: kCIInputSaturationKey)
            self.filteredImage = self.filter?.outputImage
            self.selectedPictureImageView.image = UIImage(cgImage: self.context.createCGImage(self.filteredImage!, from: (self.filteredImage?.extent)!)!)
            sliderValue = sender.value

            
        } else if sender.tag == 3 {
           
            
            let displayinPercentage: Int = Int((sender.value/200) * 10000)
            sharpenValueLabel.text = ("\(displayinPercentage)")
            self.selectedPictureImageView.image = originalImage
            let beginImage = CIImage(image: self.selectedPictureImageView.image!)
            self.filter = CIFilter(name: "CIUnsharpMask")
            self.filter?.setValue(beginImage, forKey: kCIInputImageKey)
            self.filter.setValue(7, forKey: kCIInputRadiusKey)
            self.filter.setValue(sender.value, forKey: kCIInputIntensityKey)
            self.filteredImage = self.filter?.outputImage
            self.selectedPictureImageView.image = UIImage(cgImage: self.context.createCGImage(self.filteredImage!, from: (self.filteredImage?.extent)!)!)
            sliderValue = sender.value

            
        }
    }
    
    func mergeTwoImages(imageOne: UIImage, imageTwo: UIImage, blendingMode: CGBlendMode, alpha: CGFloat) -> UIImage {
        
        let size = selectedPictureImageView.image?.size
        UIGraphicsBeginImageContextWithOptions(size!, true, 0.0)
        imageOne.draw(in: CGRect(x: 0, y: 0, width: size!.width, height: size!.height))
        imageTwo.draw(in: CGRect(x: 0, y: 0, width: size!.width, height: size!.height), blendMode: blendingMode, alpha: alpha)
        let blendedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return blendedImage!
    }
    
    func mergeThreeImages(imageOne: UIImage, imageTwo: UIImage, imageThree: UIImage, blendingModeOne: CGBlendMode, alphaOne: CGFloat, blendingModeTwo: CGBlendMode, alphaTwo: CGFloat) -> UIImage {
        
        let size = selectedPictureImageView.image?.size
        UIGraphicsBeginImageContextWithOptions(size!, true, 0.0)
        imageOne.draw(in: CGRect(x: 0, y: 0, width: size!.width, height: size!.height))
        imageTwo.draw(in: CGRect(x: 0, y: 0, width: size!.width, height: size!.height), blendMode: blendingModeOne, alpha: alphaOne)
        imageThree.draw(in: CGRect(x: 0, y: 0, width: size!.width, height: size!.height), blendMode: blendingModeTwo, alpha: alphaTwo)
        let blendedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return blendedImage!
    }


}

extension FiltersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myImageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.myLabel.textColor = .white
        cell.showCaseImageView.image = myImageArray[indexPath.row]
        cell.myLabel.text = myNameArray[indexPath.row]
        cell.myLabel.textColor = .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPictureImageView.image = myImageArray[indexPath.row]
        originalImage = selectedPictureImageView.image
        brightnessSlider.value = 0
        brightnessValueLabel.text = "50"
        contrastSlider.value = 1
        contrastValueLabel.text = "50"
        saturationSlider.value = 1
        saturationValueLabel.text = "50"
        sharpenSlider.value = 0.5
        sharpenValueLabel.text = "50"

    } 
}


