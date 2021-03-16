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

import Foundation

public let bundle = Bundle.module

public struct Pet: Hashable {
  public enum Category: CaseIterable, CustomStringConvertible {
    case birds, cats, chameleons, cows, dogs, monkeys, penguins, pigs, rats, snakes, squirrels
  }
  public let imageName: String
  public let name: String
  public let birthYear: Int
  public var age: Int {
    let thisYear = Calendar.current.component(.year, from: Date())
    return thisYear - birthYear
  }
  public let category: Category
  private let id = UUID()
}

extension Pet.Category {
  public var description: String {
    switch self {
    case .birds:
      return NSLocalizedString(
        "Birds", bundle: bundle,
        comment: "Birds are warm-blooded, egg-laying animals that have vertebrae, or a backbone. ")
    case .cats:
      return NSLocalizedString(
        "Cats", bundle: bundle,
        comment: "Cats, are small, carnivorous (meat-eating) mammals, of the family Felidae.")
    case .chameleons:
      return NSLocalizedString(
        "Chameleons", bundle: bundle,
        comment: "Chameleons  are a distinctive and highly specialized clade of Old World lizards with 202 species.")
    case .cows:
      return NSLocalizedString(
        "Cows", bundle: bundle,
        comment: "Cows are large grazing animals with two-toed or cloven hooves and a four-chambered stomach.")
    case .dogs:
      return NSLocalizedString(
        "Dogs", bundle: bundle,
        comment: "Dogs are domesticated mammals, not natural wild animals. They were originally bred from wolves.")
    case .monkeys:
      return NSLocalizedString(
        "Monkeys", bundle: bundle,
        comment: "Monkeys are tree-dwelling simians and they are intelligent, social animals.")
    case .penguins:
      return NSLocalizedString(
        "Penguins", bundle: bundle,
        comment: "A penguin has a large head, short neck, and elongated body. The tail is short, and wedge-shaped.")
    case .pigs:
      return NSLocalizedString(
        "Pigs", bundle: bundle,
        comment: "Pigs are stout-bodied, short-legged, with thick skin usually sparsely coated with short bristles.")
    case .rats:
      return NSLocalizedString(
        "Rats", bundle: bundle,
        comment: "The rat is a medium-sized rodent. Rats are omnivores, they eat lots of different types of food.")
    case .snakes:
      return NSLocalizedString(
        "Snakes", bundle: bundle,
        comment: "Snakes are limbless reptiles with long, cylindrical bodies, lidless eyes, and a forked tongue. ")
    case .squirrels:
      return NSLocalizedString(
        "Squirrels", bundle: bundle,
        comment: "Squirrels typically have slender bodies with bushy tails and large eyes.")
    }
  }

  public var pets: [Pet] {
    switch self {
    case .birds:
      return [
        Pet(imageName: "bird1", name: "Happy", birthYear: 2017, category: self),
        Pet(imageName: "bird2", name: "Swifty", birthYear: 2018, category: self),
        Pet(imageName: "bird3", name: "Speedy", birthYear: 2018, category: self)
      ]
    case .cats:
      return [
        Pet(imageName: "cat1", name: "Max", birthYear: 2015, category: self),
        Pet(imageName: "cat2", name: "Jake", birthYear: 2018, category: self),
        Pet(imageName: "cat3", name: "Daisy", birthYear: 2012, category: self),
        Pet(imageName: "cat4", name: "Sunny", birthYear: 2008, category: self),
        Pet(imageName: "cat5", name: "Oscar", birthYear: 2017, category: self)
      ]
    case .chameleons:
      return [
        Pet(imageName: "chameleon1", name: "Zoe", birthYear: 2015, category: self)
      ]
    case .cows:
      return [
        Pet(imageName: "cow1", name: "Betty", birthYear: 2016, category: self),
        Pet(imageName: "cow2", name: "Rosie", birthYear: 2013, category: self)
      ]
    case .dogs:
      return [
        Pet(imageName: "dog1", name: "Buddy", birthYear: 2018, category: self),
        Pet(imageName: "dog2", name: "Molly", birthYear: 2014, category: self),
        Pet(imageName: "dog3", name: "Bella", birthYear: 2009, category: self),
        Pet(imageName: "dog4", name: "Dixie", birthYear: 2018, category: self),
        Pet(imageName: "dog5", name: "Freddy", birthYear: 2012, category: self),
        Pet(imageName: "dog6", name: "Lucky", birthYear: 2016, category: self),
        Pet(imageName: "dog7", name: "Snoopy", birthYear: 2015, category: self),
        Pet(imageName: "dog8", name: "Joker", birthYear: 2018, category: self),
        Pet(imageName: "dog9", name: "Diego", birthYear: 2018, category: self),
        Pet(imageName: "dog10", name: "Bruno", birthYear: 2016, category: self)
      ]
    case .monkeys:
      return [
        Pet(imageName: "monkey1", name: "Turbo", birthYear: 2015, category: self)
      ]
    case .penguins:
      return [
        Pet(imageName: "penguin1", name: "Helen", birthYear: 2017, category: self),
        Pet(imageName: "penguin2", name: "Fred", birthYear: 2014, category: self)
      ]
    case .pigs:
      return [
        Pet(imageName: "pig1", name: "Piggy", birthYear: 2015, category: self)
      ]
    case .rats:
      return [
        Pet(imageName: "rat1", name: "Cutie", birthYear: 2018, category: self)
      ]
    case .snakes:
      return [
        Pet(imageName: "snake1", name: "Worm", birthYear: 2013, category: self),
        Pet(imageName: "snake2", name: "Noodles", birthYear: 2018, category: self),
        Pet(imageName: "snake3", name: "Slider", birthYear: 2017, category: self)
      ]
    case .squirrels:
      return [
        Pet(imageName: "squirrel1", name: "Chippy", birthYear: 2017, category: self)
      ]
    }
  }
}
