/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person
/// obtaining a copy of this software and associated documentation
/// files (the "Software"), to deal in the Software without
/// restriction, including without limitation the rights to use,
/// copy, modify, merge, publish, distribute, sublicense, and/or
/// sell copies of the Software, and to permit persons to whom
/// the Software is furnished to do so, subject to the following
/// conditions:
///
/// The above copyright notice and this permission notice shall be
/// included in all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify,
/// merge, publish, distribute, sublicense, create a derivative work,
/// and/or sell copies of the Software in any work that is designed,
/// intended, or marketed for pedagogical or instructional purposes
/// related to programming, coding, application development, or
/// information technology. Permission for such use, copying,
/// modification, merger, publication, distribution, sublicensing,
/// creation of derivative works, or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks
/// that are released under various Open-Source licenses. Use of
/// those libraries and frameworks are governed by their own
/// individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
/// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
/// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
/// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
/// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
/// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.

import UIKit
class PetExplorerViewController: UICollectionViewController {
  // MARK: - Properties
  lazy var dataSource = makeDataSource()
  var adoptions = Set<Pet>()

  // MARK: - Types
  enum Section: Int, CaseIterable, Hashable {
    case availablePets
    case adoptedPets
  }
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = NSLocalizedString("Pet Explorer", comment: "Navigation Title")
    configureLayout()
    applyInitialSnapshots()
  }

  // MARK: - Functions
  func configureLayout() {
    let provider = {(_: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
      let configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
      return .list(using: configuration, layoutEnvironment: layoutEnv)
    }
    collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: provider)
  }

  func makeDataSource() -> DataSource {
    return DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
      if item.pet != nil {
        guard let section = Section(rawValue: indexPath.section) else {
          return nil
        }
        switch section {
        case .availablePets:
          return collectionView.dequeueConfiguredReusableCell(
            using: self.petCellRegistration(), for: indexPath, item: item)
        case .adoptedPets:
          return collectionView.dequeueConfiguredReusableCell(
            using: self.adoptedPetCellRegistration(), for: indexPath, item: item)
        }
      } else {
        return collectionView.dequeueConfiguredReusableCell(
          using: self.categoryCellregistration(), for: indexPath, item: item)
      }
    }
  }

  func applyInitialSnapshots() {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    snapshot.appendSections(Section.allCases)
    dataSource.apply(snapshot, animatingDifferences: false)
    var categorySnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
    for category in Pet.Category.allCases {
      let categoryItem = Item(title: String(describing: category))
      categorySnapshot.append([categoryItem])
      let petItems = category.pets.map { Item(pet: $0, title: $0.name) }
      categorySnapshot.append(petItems, to: categoryItem)
    }
    dataSource.apply(categorySnapshot, to: .availablePets, animatingDifferences: false)
  }

  func updateDataSource(for pet: Pet) {
    var snapshot = dataSource.snapshot()
    let items = snapshot.itemIdentifiers
    let petItem = items.first { item in
      item.pet == pet
    }
    if let petItem = petItem {
      snapshot.reloadItems([petItem])
      dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
  }
}

// MARK: - CollectionView Cells
extension PetExplorerViewController {
  func categoryCellregistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
    return .init { cell, _, item in
      var configuration = cell.defaultContentConfiguration()
      configuration.text = item.title
      cell.contentConfiguration = configuration
      let options = UICellAccessory.OutlineDisclosureOptions(style: .header)
      let disclosureAccessory = UICellAccessory.outlineDisclosure(options: options)
      cell.accessories = [disclosureAccessory]
      cell.accessibilityIdentifier = item.title
    }
  }

  func petCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
    return .init { cell, _, item in
      guard let pet = item.pet else {
        return
      }
      var configuration = cell.defaultContentConfiguration()
      configuration.text = pet.name
      configuration.secondaryText = "\(pet.age) \(NSLocalizedString("years old", comment: "Age"))"
      configuration.image = UIImage(named: pet.imageName)
      configuration.imageProperties.maximumSize = CGSize(width: 40, height: 40)
      cell.contentConfiguration = configuration
      cell.accessories = [UICellAccessory.disclosureIndicator()]
      if self.adoptions.contains(pet) {
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.backgroundColor = .systemBlue
        backgroundConfig.cornerRadius = 5
        backgroundConfig.backgroundInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        cell.backgroundConfiguration = backgroundConfig
      }
      cell.contentConfiguration = configuration
      cell.accessories = [UICellAccessory.disclosureIndicator()]
      cell.accessibilityIdentifier = pet.name
    }
  }

  func adoptedPetCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
    return .init { cell, _, item in
      guard let pet = item.pet else {
        return
      }
      var configuration = cell.defaultContentConfiguration()
      configuration.text = "\(NSLocalizedString("Your pet:", comment: "name")) \(pet.name)"
      configuration.secondaryText = "\(pet.age) \(NSLocalizedString("years old", comment: "Age"))"
      configuration.image = UIImage(named: pet.imageName)
      configuration.imageProperties.maximumSize = CGSize(width: 40, height: 40)
      cell.contentConfiguration = configuration
      cell.accessories = [.disclosureIndicator()]
      cell.accessibilityIdentifier = "\(NSLocalizedString("Adopt", comment: "")) \(pet.name)"
    }
  }
}

// MARK: - UICollectionViewDelegate
extension PetExplorerViewController {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let item = dataSource.itemIdentifier(for: indexPath) else {
      collectionView.deselectItem(at: indexPath, animated: true)
      return
    }
    guard let pet = item.pet else {
      return
    }
    pushDetailForPet(pet, withAdoptionStatus: adoptions.contains(pet))
  }

  func pushDetailForPet(_ pet: Pet, withAdoptionStatus isAdopted: Bool) {
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    let petDetailViewController =
      storyboard.instantiateViewController(identifier: "PetDetailViewController") { coder in
        return PetDetailViewController(coder: coder, pet: pet)
      }
    petDetailViewController.delegate = self
    petDetailViewController.isAdopted = isAdopted
    navigationController?.pushViewController(petDetailViewController, animated: true)
  }
}

// MARK: - PetDetailViewControllerDelegate
extension PetExplorerViewController: PetDetailViewControllerDelegate {
  func petDetailViewController(_ petDetailViewController: PetDetailViewController, didAdoptPet pet: Pet) {
    adoptions.insert(pet)
    var adoptedPetsSnapshot = dataSource.snapshot(for: .adoptedPets)
    let newItem = Item(pet: pet, title: pet.name)
    adoptedPetsSnapshot.append([newItem])
    dataSource.apply(adoptedPetsSnapshot, to: .adoptedPets, animatingDifferences: true, completion: nil)
    updateDataSource(for: pet)
  }
}
