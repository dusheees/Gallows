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
    var buttontag: Int = 0
    // for correct item size
    var size: CGSize!
    var factor: CGFloat!
    
    
    // MARK: - UIProperties
    @IBOutlet var listOfLabels: [UILabel]!
    @IBOutlet var listOfSwitches: [UISwitch]!
    @IBOutlet weak var singleButton: UIButton!
    @IBOutlet weak var multiButton: UIButton!
    
    
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
    
    // function for correct item size
    func correctSize() {
        for label in listOfLabels {
            label.font = UIFont.systemFont(ofSize: factor / 12)
        }
        for switchElement in listOfSwitches {
            switchElement.transform = CGAffineTransform(scaleX: factor / 500, y: factor / 500)
        }
        singleButton.titleLabel?.font = UIFont.systemFont(ofSize: factor / 12)
        multiButton.titleLabel?.font = UIFont.systemFont(ofSize: factor / 12)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: factor / 25)]
    }
    
    // update initial state
    func updateState() {
        for switchElement in listOfSwitches {
            switchElement.isOn = false
        }
        singleButton.isEnabled = false
        multiButton.isEnabled = false
    }

    
    // MARK: - Actions
    @IBAction func switchAction(_ sender: UISwitch) {
        guard sender.isOn else {
            updateState()
            return
        }
        
        singleButton.isEnabled = true
        multiButton.isEnabled = true
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
    
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        buttontag = sender.tag
        performSegue(withIdentifier: "GameViewController", sender: nil)
    }
    
    @IBSegueAction func toGame(_ coder: NSCoder) -> GameViewController? {
        return GameViewController(coder: coder, listOfWords: listOfWords, navigationTitle: navigationTitle, size: size, factor: factor, buttontag: buttontag)
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        print(#line, #function)
        updateState()
    }
    
}

