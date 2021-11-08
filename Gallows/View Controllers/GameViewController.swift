//
//  GameViewController.swift
//  Gallows
//
//  Created by Андрей on 08.11.2021.
//

import UIKit

class GameViewController: UIViewController {

    // MARK: - Properties
    var listOfWords: [String] = []
    var navigationTitle: String = ""
    
    init?(coder: NSCoder, listOfWords: [String], navigationTitle: String){
        self.listOfWords = listOfWords
        self.navigationTitle = navigationTitle
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIProperties
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = navigationTitle
        navigationItem.hidesBackButton = true
    }
    
    
}
