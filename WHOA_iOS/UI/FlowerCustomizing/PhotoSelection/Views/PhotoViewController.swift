//
//  PhotoViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 3/14/24.
//

import UIKit
import Photos

class PhotoViewController: UIViewController {
    private enum Const {
        static let numberOfColumns = 3.0
        static let cellSpace = 1.0
        static let length = (UIScreen.main.bounds.size.width - cellSpace * (numberOfColumns - 1)) / numberOfColumns
        static let cellSize = CGSize(width: length, height: length)
        static let scale = UIScreen.main.scale
    }
    
    // MARK: - Properties
    
    private let albumService: AlbumService = MyAlbumService()
    private let photoService: PhotoService = MyPhotoService()
    private var selectedIndexArray = [Int]() // Index: count
    
    // album 여러개에 대한 예시는 생략 (UIPickerView와 같은 것을 이용하여 currentAlbumIndex를 바꾸어주면 됨)
    private var albums = [PHFetchResult<PHAsset>]()
    private var dataSource = [PhotoCellInfo]()
    private var selectedCellImageArray = [Int: UIImage?]() {
        didSet {
            updateAddButton()
        }
    }
    
    private var currentAlbumIndex = 0 {
        didSet { loadImages() }
    }
    
    var completionHandler: (([Int: UIImage?]) -> ())?
    
    // MARK: - UI
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Xmark"), for: .normal)
        button.tintColor = .systemGray
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("최근 항목", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        flowlayout.minimumLineSpacing = 1
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.itemSize = Const.cellSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.id)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadAlbums(completion: { [weak self] in
            self?.loadImages()
        })
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(exitButton)
        view.addSubview(submitButton)
        view.addSubview(addButton)
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupAutoLayout()
        
    }
    
    private func loadAlbums(completion: @escaping () -> Void) {
        albumService.getAlbums(mediaType: .image) { [weak self] albumInfos in
            self?.albums = albumInfos.map(\.album)
            completion()
        }
    }
    
    private func loadImages() {
        guard currentAlbumIndex < albums.count else { return }
        let album = albums[currentAlbumIndex]
        photoService.convertAlbumToPHAssets(album: album) { [weak self] phAssets in
            self?.dataSource = phAssets.map { .init(phAsset: $0, image: nil, selectedOrder: .none) }
            self?.collectionView.reloadData()
        }
    }
    
    private func loadPHAssetsFromAlbums() {
        let album = albums[currentAlbumIndex]
        photoService.convertAlbumToPHAssets(album: album) { [weak self] phAssets in
            print(phAssets)
        }
    }
    
    private func updateAddButton() {
        let addButtonText = self.selectedCellImageArray.isEmpty ? "" : "\(self.selectedCellImageArray.count)장"
        addButton.attributedTitle(firstPart: addButtonText, secondPart: "추가")
    }
    
    // MARK: - Actions
    
    @objc
    private func exitButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func addButtonTapped() {
        completionHandler?(selectedCellImageArray)
        dismiss(animated: true)
    }
}

extension PhotoViewController {
    private func setupAutoLayout() {
        exitButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(21)
            $0.leading.equalToSuperview().offset(30)
            $0.size.equalTo(14)
        }
        
        submitButton.snp.makeConstraints {
            $0.top.equalTo(exitButton)
            $0.centerX.equalToSuperview()
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(exitButton)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(submitButton.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        dataSource.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.id, for: indexPath) as? PhotoCell
        else { return UICollectionViewCell() }
        let imageInfo = dataSource[indexPath.item]
        let phAsset = imageInfo.phAsset
        let imageSize = CGSize(width: Const.cellSize.width * Const.scale, height: Const.cellSize.height * Const.scale)
        
        photoService.fetchImage(
            phAsset: phAsset,
            size: imageSize,
            contentMode: .aspectFit,
            completion: { [weak cell] image in
                cell?.prepare(info: .init(phAsset: phAsset, image: image, selectedOrder: imageInfo.selectedOrder))
            }
        )
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info = dataSource[indexPath.item]
        let updatingIndexPaths: [IndexPath]
        
        if case .selected = info.selectedOrder {
            dataSource[indexPath.item] = .init(phAsset: info.phAsset, image: info.image, selectedOrder: .none)
            
            if let selectedIndex = selectedIndexArray.firstIndex(of: indexPath.item) {
                selectedIndexArray.remove(at: selectedIndex)
                selectedCellImageArray.removeAll()
                
                selectedIndexArray
                    .enumerated()
                    .forEach { order, index in
                        let order = order + 1
                        let prev = dataSource[index]
                        let selectedCellImage = (collectionView.cellForItem(at: [0, index]) as? PhotoCell)?.getImage()
                        dataSource[index] = .init(phAsset: prev.phAsset, image: prev.image, selectedOrder: .selected(order))
                        selectedCellImageArray.updateValue(selectedCellImage, forKey: order)
                    }
            }
            updatingIndexPaths = [indexPath] + selectedIndexArray
                .map { IndexPath(row: $0, section: 0) }
        } else {
            if selectedIndexArray.count < 3 {
                selectedIndexArray.append(indexPath.item)
                
                selectedIndexArray
                    .enumerated()
                    .forEach { order, selectedIndex in
                        let order = order + 1
                        let prev = dataSource[selectedIndex]
                        let selectedCellImage = (collectionView.cellForItem(at: [0, selectedIndex]) as? PhotoCell)?.getImage()
                        dataSource[selectedIndex] = .init(phAsset: prev.phAsset, image: prev.image, selectedOrder: .selected(order))
                        selectedCellImageArray.updateValue(selectedCellImage, forKey: order)
                    }
                
                updatingIndexPaths = selectedIndexArray.map { IndexPath(row: $0, section: 0) }
            } else {
                return
            }
        }
        
        update(indexPaths: updatingIndexPaths)
    }
    
    private func update(indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            collectionView.reloadItems(at: indexPaths)
        }
    }
}
