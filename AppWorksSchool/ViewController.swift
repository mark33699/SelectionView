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
    struct ColorModel
    {
        let color: UIColor
        let buttonModel: SelectionView.ButtonModel
    }
    
    private var shouldTapBottomSelectView: Bool = true
    
    //MARK: subview
    private let colorViewTop: UIView = .init()
    private let colorViewBottom: UIView = .init()
    private let selectViewTop: SelectionView = .init()
    private let selectViewBottom: SelectionView = .init()
    
    private let defaultButtonColor: UIColor = .white
    private let defaultButtonFont: UIFont = .systemFont(ofSize: 18)
    
    //MARK: dataModel
    private var redModel: ColorModel
    {
        return .init(color: .red,
                     buttonModel: .init(title: "Red",
                                        titleColor: defaultButtonColor,
                                        titleFont: defaultButtonFont))
    }
    private var yellowModel: ColorModel
    {
        return .init(color: .yellow,
                     buttonModel: .init(title: "Yellow",
                                        titleColor: defaultButtonColor,
                                        titleFont: defaultButtonFont))
    }
    private var blueModel: ColorModel
    {
        return .init(color: .blue,
                     buttonModel: .init(title: "Blue",
                                        titleColor: defaultButtonColor,
                                        titleFont: defaultButtonFont))
    }
    
    private var colorModelsTop: Array<ColorModel>
    {
        return [redModel, yellowModel]
    }
    private var colorModelsBottom: Array<ColorModel>
    {
        return [redModel, yellowModel, blueModel]
    }
    
    //MARK: UI
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        selectViewTop.dataSource = self
        selectViewTop.delegate = self
        selectViewBottom.dataSource = self
        selectViewBottom.delegate = self
        
        layoutUI()
    }
    
    private func layoutUI()
    {
        colorViewTop.backgroundColor = colorModelsTop.first?.color
        colorViewBottom.backgroundColor = colorModelsBottom.first?.color
        
        let stackView = UIStackView.init(arrangedSubviews: [selectViewTop, colorViewTop, selectViewBottom, colorViewBottom])
        view.addSubview(stackView)
        let safeArea = view.safeAreaLayoutGuide
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100).isActive = true
        stackView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
    }
    
    //MARK: SelectionViewDataSource
    func numberOfButtons(in selectionView: SelectionView) -> Int
    {
        switch selectionView
        {
        case selectViewTop:
            return colorModelsTop.count
        case selectViewBottom:
            return colorModelsBottom.count
        default:
            print("numberOfButtons exception")
            return 0
        }
    }
    
    func selectionView(_ selectionView: SelectionView, buttonAt index: Int) -> SelectionView.ButtonModel
    {
        switch selectionView
        {
        case selectViewTop:
            return colorModelsTop[index].buttonModel
        case selectViewBottom:
            return colorModelsBottom[index].buttonModel
        default:
            print("selectionViewButton exception")
            return .init(title: "", titleColor: .white, titleFont: .systemFont(ofSize: 18))
        }
    }
    
    func indicatorColor(in selectionView: SelectionView) -> UIColor
    {
        return .white
    }
    
    //MARK: SelectionViewDelegate
    func selectionView(_ selectionView: SelectionView, shouldSelectAt index: Int) -> Bool
    {
        switch selectionView
        {
        case selectViewTop:
            return true
        case selectViewBottom:
            return shouldTapBottomSelectView
        default:
            print("selectionViewShouldSelect exception")
            return true
        }
    }
    
    func selectionView(_ selectionView: SelectionView, didSelectAt index: Int)
    {
        switch selectionView
        {
        case selectViewTop:
            colorViewTop.backgroundColor = colorModelsTop[index].color
            //如果上方的 SelectionView 目前選取的 button 是最後一個，那下方的 SelectionView 則不可以被使用者控制。
            shouldTapBottomSelectView = index == colorModelsTop.count - 1 ? false : true
        case selectViewBottom:
            colorViewBottom.backgroundColor = colorModelsBottom[index].color
        default:
            print("selectionViewDidSelect exception")
        }
    }
}
