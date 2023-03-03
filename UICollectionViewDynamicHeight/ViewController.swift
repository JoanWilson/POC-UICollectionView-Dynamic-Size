//
//  ViewController.swift
//  UICollectionViewDynamicHeight
//
//  Created by Joan Wilson Oliveira on 01/03/23.
//

import UIKit

class ViewController: UIViewController {

    private lazy var commentCollectionView: UICollectionView = {
        let commentFlowLayout = CommentFlowLayout()
        commentFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        commentFlowLayout.minimumInteritemSpacing = 10
        commentFlowLayout.minimumLineSpacing = 10

        let commentCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: commentFlowLayout)
        commentCollectionView.register(DynamicCell.self, forCellWithReuseIdentifier: "cell")

        commentCollectionView.collectionViewLayout = commentFlowLayout
        commentCollectionView.contentInsetAdjustmentBehavior = .always
        commentCollectionView.dataSource = self
        return commentCollectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUI()
        commentCollectionView.reloadData()
    }

    private func setUI() {
        view.addSubview(commentCollectionView)
        setConstraints()
    }

    private func setConstraints() {

    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DynamicCell else {
            print("deu ruim na cell")
            return UICollectionViewCell()
        }

        cell.backgroundColor = .red

        return cell
    }
}




final class CommentFlowLayout : UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
            layoutAttributesObjects?.forEach({ layoutAttributes in
                if layoutAttributes.representedElementCategory == .cell {
                    if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                        layoutAttributes.frame = newFrame
                    }
                }
            })
            return layoutAttributesObjects
        }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { fatalError() }
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }

        layoutAttributes.frame.origin.x = sectionInset.left
        layoutAttributes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right
        return layoutAttributes
    }
}











class DynamicCell: UICollectionViewCell {

    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "cake")
        image.contentMode = .scaleAspectFill

        return image
    }()

    private lazy var text: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "I Love cakes Too much! I Love cakes Too much! I Love cakes Too much! I Love cakes Too much! I Love cakes Too much! I Love cakes Too much! I Love cakes Too much! I Love cakes Too much! I Love cakes Too much! I Love cakes Too much! I Love cakes Too much! I Love cakes Too much! "
        text.numberOfLines = 0
        text.font = UIFont.preferredFont(forTextStyle: .body)
        text.adjustsFontForContentSizeCategory = true

        return text
    }()


    private lazy var subtext: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Esse aqui é o debaixo Esse aqui é o debaixo Esse aqui é o debaixo Esse aqui é o debaixo Esse aqui é o debaixo Esse aqui é o debaixo Esse aqui é o debaixo Esse aqui é o debaixo Esse aqui é o debaixo Esse aqui é o debaixo Esse aqui é o debaixo Esse aqui é o debaixo "
        text.numberOfLines = 0
        text.textColor = .blue
        text.font = UIFont.preferredFont(forTextStyle: .body)
        text.adjustsFontForContentSizeCategory = true

        return text
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return layoutAttributes
    }

    private func setUI() {
        contentView.addSubview(image)
        contentView.addSubview(text)
        contentView.addSubview(subtext)
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.heightAnchor.constraint(equalToConstant: 250),

            text.topAnchor.constraint(equalTo: image.bottomAnchor),
            text.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            text.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            subtext.topAnchor.constraint(equalTo: text.bottomAnchor),
            subtext.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subtext.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subtext.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
