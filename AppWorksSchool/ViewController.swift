//
//  ViewController.swift
//  AppWorksSchool
//
//  Created by iOS_Mark on 2020/2/10.
//  Copyright © 2020 IPK. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SelectionViewDataSource, SelectionViewDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        let selectView = SelectionView()
        selectView.dataSource = self
        selectView.delegate = self
        selectView.backgroundColor = .brown
        view.addSubview(selectView)
        
        let safeArea = view.safeAreaLayoutGuide
        selectView.translatesAutoresizingMaskIntoConstraints = false
        selectView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100).isActive = true
        selectView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
        selectView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
        selectView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func numberOfButtons(in selectionView: SelectionView) -> Int
    {
        return 10
    }
    
    func selectionView(_ selectionView: SelectionView, shouldSelectAt index: Int) -> Bool
    {
//        return index == 0
        return true
    }
}

