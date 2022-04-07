//
//  ViewController.swift
//  SongLoop
//
//  Created by Diana Princess on 06.04.2022.
//

import UIKit
import MobileCoreServices

class MainViewController: UIViewController, MainViewProtocol {
    let button = UIButton()
    let secondButton = UIButton()
    let playButton = UIButton()
    let slider = UISlider()
    let sliderLabel = UILabel()
    var presenter: MainPresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureButtons()
        // Do any additional setup after loading the view.
    }
    
    func configureButtons(){
        slider.minimumValue = 2
        slider.maximumValue = 10
        slider.isContinuous = true
        slider.tintColor = .systemBlue
        slider.addTarget(self, action: #selector(durationSelected(_:)), for: .valueChanged)
        sliderLabel.textAlignment = .center
        sliderLabel.text = "0 сек"
        button.setTitle("Выбрать трек 1", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(trackSelect), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        secondButton.setTitle("Выбрать трек 2", for: .normal)
        secondButton.backgroundColor = .blue
        secondButton.setTitleColor(.white, for: .normal)
        secondButton.addTarget(self, action: #selector(trackSelect), for: .touchUpInside)
        secondButton.clipsToBounds = true
        secondButton.layer.cornerRadius = 5
        playButton.setTitle("Воспроизведение", for: .normal)
        playButton.setTitleColor(.white, for: .normal)
        playButton.backgroundColor = .lightGray
        playButton.clipsToBounds = true
        playButton.layer.cornerRadius = 5
        let stackView = UIStackView(arrangedSubviews: [slider, sliderLabel, button, secondButton, playButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: stackView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: stackView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    func addConstraints(){
    
    }

    @objc func trackSelect() {
        let docPick = UIDocumentPickerViewController(documentTypes: [kUTTypeAudio as String], in: .import)
        docPick.delegate = presenter
        docPick.allowsMultipleSelection = false
        present(docPick, animated: true, completion: nil)
    }
    
    @objc func startPlaying(){
        presenter?.startPlaying()
    }
    
    @objc func durationSelected(_ sender: UISlider!){
        sliderLabel.text = "\(sender.value) сек"
        presenter?.setDuration(value: Double(sender.value))
    }
    
    func changePlayButton(){
        playButton.backgroundColor = .black
        playButton.addTarget(self, action: #selector(startPlaying), for: .touchUpInside)
    }
}



