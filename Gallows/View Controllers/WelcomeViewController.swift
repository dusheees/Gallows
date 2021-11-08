//
//  ViewController.swift
//  Gallows
//
//  Created by Андрей on 08.11.2021.
//

import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - Properties
    var listOfWords: [String] = []
    var navigationTitle: String = ""
    var wordsForGame = WordsForGame()
    var size: CGSize!
    var factor: CGFloat!
    
    
    // MARK: - UIProperties
    @IBOutlet var listOfSwitches: [UISwitch]!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet var listOfLabels: [UILabel]!
    
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        size = view.bounds.size
        factor = min(size.height, size.width)
        view.backgroundColor = .white
        navigationItem.title = "New game"
        updateState()
        correctSize()
    }
    
    func correctSize() {
        for label in listOfLabels {
            label.font = UIFont.systemFont(ofSize: factor / 12)
        }
        for switchElement in listOfSwitches {
            switchElement.transform = CGAffineTransform(scaleX: factor / 500, y: factor / 500)
        }
        buttonStart.titleLabel?.font = UIFont.systemFont(ofSize: factor / 12)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: factor / 25)]
    }
    
    func updateState() {
        for switchElement in listOfSwitches {
            switchElement.isOn = false
        }
        buttonStart.isEnabled = false
    }

    
    // MARK: - Actions
    @IBAction func switchAction(_ sender: UISwitch) {
        guard sender.isOn else {
            updateState()
            return
        }
        
        buttonStart.isEnabled = true
        switch sender.tag {
        case 0:
            listOfWords = wordsForGame.cities
            navigationTitle = "Cities"
        case 1:
            listOfWords = wordsForGame.movies
            navigationTitle = "Movies"
        default:
            listOfWords = []
        }
        for index in 0 ..< listOfSwitches.count {
            guard listOfSwitches[index].tag == sender.tag else {
                listOfSwitches[index].isOn = false
                return
            }
        }
    }
    
    @IBSegueAction func toGame(_ coder: NSCoder) -> GameViewController? {
        return GameViewController(coder: coder, listOfWords: listOfWords, navigationTitle: navigationTitle, size: size, factor: factor)
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        print(#line, #function)
        updateState()
    }
    
}

