//
//  Parameters.swift
//  FA-NOC-iOS
//
//  Created by joowon on 13/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import Foundation

enum FaStrRefUrl: String {
    
    case login = "/login/"
    
    case logout = "/logout/"
    
    case browse = "/browse/"
    case search = "/search/"
    
    case notes = "/msg/pms/"
    case submissions = "/msg/submissions/"
    case others = "/msg/others"
}

struct FaUrl {
    
    static private func makeURL(_ ref:FaStrRefUrl) -> URL {
        return makeURL(strRef: ref.rawValue)
    }
    
    static func makeURL(strRef:String) -> URL {
        return URL(string: "https://www.furaffinity.net\(strRef)")!
    }
    
    static let login = makeURL(.login)
    static let logout = makeURL(.logout)
    
    static let browse = makeURL(.browse)
    static let search = makeURL(.search)
    
    static let notes = makeURL(.notes)
    static let submissions = makeURL(.submissions)
    static let others = makeURL(.others) //journals+watches
    
    static func user(_ name:String) -> URL {
        return makeURL(strRef: "/user/\(name)")
    }
}


struct Browse {
    
    enum List {
        case category, type, species, gender, results
        
        var model: SettingModel {
            switch self {
            case .category: return Category.model
            case .type: return BType.model
            case .species: return Species.model
            case .gender: return Gender.model
            case .results: return Results.model
            }
        }
    }
    
    //MARK: - Category -
    
    enum Category: BrowseSetting {
        
        static var allCases: [Category] {
            return [.visualArt(.all), .readableArt(.story), .audioArt(.music), .downloadable(.skins), .otherStuff(.other)]
        }
        
        case visualArt(VisualArt)
        case readableArt(ReadableArt)
        case audioArt(AudioArt)
        case downloadable(Downloadable)
        case otherStuff(OtherStuff)
        
        static var categoryName: String {
            return "Category"
        }
        
        var value: String {
            switch self {
            case .visualArt(let value): return value.rawString
            case .readableArt(let value): return value.rawString
            case .audioArt(let value): return value.rawString
            case .downloadable(let value): return value.rawString
            case .otherStuff(let value): return value.rawString
            }
        }
        
        var name: String {
            switch self {
            case .visualArt: return VisualArt.categoryName
            case .readableArt: return ReadableArt.categoryName
            case .audioArt: return AudioArt.categoryName
            case .downloadable: return Downloadable.categoryName
            case .otherStuff: return OtherStuff.categoryName
            }
        }
        
        static var model: SettingModel {
            return SettingModel(sections: [VisualArt.section, ReadableArt.section, AudioArt.section, Downloadable.section, OtherStuff.section])
        }
    }
    
    enum VisualArt: Int, BrowseSetting {
        
        case all = 1
        case artworkDigital
        case artworkTraditional
        case cellshading
        case crafting
        case designs
        case flash
        case fursuiting
        case icons
        case mosaics
        case photography
        case sculpting
        
        static var categoryName: String {
            return "Visual Art"
        }
        
        var name: String {
            switch self {
            case .artworkDigital:
                return "Artwork (Digital)"
            case .artworkTraditional:
                return "Artwork (Traditional)"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum ReadableArt: Int, BrowseSetting {
        case story = 13
        case poetry
        case prose
        
        static var categoryName: String {
            return "Readable Art"
        }
        
        var name: String {
            return String(describing: self).capitalized
        }
    }
    
    enum AudioArt: Int, BrowseSetting {
        case music = 16
        case podcasts
        
        static var categoryName: String {
            return "Audio Art"
        }
        
        var name: String {
            return String(describing: self).capitalized
        }
    }
    
    enum Downloadable: Int, BrowseSetting {
        case skins = 18
        case handhelds
        case resources
        
        static var categoryName: String {
            return "Downloadable"
        }
        
        var name: String {
            return String(describing: self).capitalized
        }
    }
    
    enum OtherStuff: Int, BrowseSetting {
        case adoptables = 21
        case auctions
        case contests
        case currentEvents
        case desktops
        case stockart
        case screenshots
        case scraps
        case wallpaper
        case ychOrSale
        case other          //init
        
        static var categoryName: String {
            return "Other Stuff"
        }
        
        var name: String {
            switch self {
            case .currentEvents:
                return "Current Events"
            case .ychOrSale:
                return "YCH / Sale"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    //MARK: - (B)Type -
    
    public enum BType {
        
        static var allCases: [BType] {
            return [.generalThings(.all), .fetishOrFurrySpecialty(.generalFurryArt), .music(.otherMusic)]
        }
        
        case generalThings(GeneralThings)
        case fetishOrFurrySpecialty(FetishOrFurrySpecialty)
        case music(Music)
        
        static var categoryName: String {
            return "Type"
        }
        
        var value: String {
            switch self {
            case .generalThings(let value): return value.rawString
            case .fetishOrFurrySpecialty(let value): return value.rawString
            case .music(let value): return value.rawString
            }
        }
        
        var name: String {
            switch self {
            case .generalThings: return GeneralThings.categoryName
            case .fetishOrFurrySpecialty: return FetishOrFurrySpecialty.categoryName
            case .music: return Music.categoryName
            }
        }
        
        static var model: SettingModel {
            return SettingModel(sections: [GeneralThings.section, FetishOrFurrySpecialty.section, Music.section])
        }
    }
    
    enum GeneralThings: Int, BrowseSetting {
        case all = 1
        case abstract
        case animalRelated
        case anime
        case comics
        case doodle
        case fanart
        case fantasy
        case human
        case portraits
        case scenery
        case stillLife
        case tutorials
        case miscellaneous
        
        static var categoryName: String {
            return "General Things"
        }
        
        var name: String {
            switch self {
            case .animalRelated:
                return "Animal related (non-anthro)"
            case .stillLife:
                return "Still Life"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum FetishOrFurrySpecialty: Int, BrowseSetting {
        case babyFur = 101
        case bondage
        case digimon
        case fatFurs
        case fetishOther
        case fursuit
        case goreOrMacabreArt
        case hyper
        case inflation
        case macroOrMicro
        case muscle
        case myLittlePonyOrBrony
        case paw
        case pokemon
        case pregnancy
        case sonic
        case transformation
        case vore
        case waterSports
        case generalFurryArt = 100
        
        static var categoryName: String {
            return "Fetish / Furry specialty"
        }
        
        var name: String {
            switch self {
            case .babyFur:
                return "Baby Fur"
            case .fatFurs:
                return "Fat Furs"
            case .fetishOther:
                return "Fetish Other"
            case .goreOrMacabreArt:
                return "Gore / Macabre Art"
            case .macroOrMicro:
                return "Macro / Micro"
            case .myLittlePonyOrBrony:
                return "My Little Pony / Brony"
            case .waterSports:
                return "Water Sports"
            case .generalFurryArt:
                return "General Furry Art"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum Music: Int, BrowseSetting {
        case techno = 201
        case trance
        case house
        case ninetys
        case eightys
        case seventys
        case sixtys
        case preSixtys
        case classical
        case gameMusic
        case rock
        case pop
        case rap
        case industrial
        case otherMusic = 200
        
        static var categoryName: String {
            return "Music"
        }
        
        var name: String {
            switch self {
            case .ninetys:
                return "90s"
            case .eightys:
                return "80s"
            case .seventys:
                return "70s"
            case .sixtys:
                return "60s"
            case .preSixtys:
                return "Pre-60s"
            case .gameMusic:
                return "Game Music"
            case .otherMusic:
                return "Other Music"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    //MARK: - Species -
    
    enum Species {
        
        static var allCases: [Species] {
            return [.unspecifiedOrAny, .amphibian(.amphibianOther), .aquatic(.aquaticOther), .avian(.avianOther), .bearsAndUrsines(.bear), .camelids(.camel), .caninesAndLupines(.canineOther), .cervines(.cervineOther), .cowsAndBovines(.bovinesGeneral), .dragons(.dragonOther), .equestrians(.horse), .exoticAndMythicals(.exoticOther), .felines(.felineOther), .insects(.insectOther), .mammalsOther(.mammalsOther), .marsupials(.marsupialOther), .mustelids(.mustelidOther), .primates(.primateOther), .reptillian(.reptilianOther), .rodents(.rodentOther), .vulpines(.vulpineOther), .other(.dinosaur)]
        }
        
        case unspecifiedOrAny
        case amphibian(Amphibian)
        case aquatic(Aquatic)
        case avian(Avian)
        case bearsAndUrsines(BearsAndUrsines)
        case camelids(Camelids)
        case caninesAndLupines(CaninesAndLupines)
        case cervines(Cervines)
        case cowsAndBovines(CowsAndBovines)
        case dragons(Dragons)
        case equestrians(Equestrians)
        case exoticAndMythicals(ExoticAndMythicals)
        case felines(Felines)
        case insects(Insects)
        case mammalsOther(MammalsOther)
        case marsupials(Marsupials)
        case mustelids(Mustelids)
        case primates(Primates)
        case reptillian(Reptillian)
        case rodents(Rodents)
        case vulpines(Vulpines)
        case other(Other)
        
        static var categoryName: String {
            return "Species"
        }
        
        var value: String {
            switch self {
            case .unspecifiedOrAny: return "1"
            case .amphibian(let value): return value.rawString
            case .aquatic(let value): return value.rawString
            case .avian(let value): return value.rawString
            case .bearsAndUrsines(let value): return value.rawString
            case .camelids(let value): return value.rawString
            case .caninesAndLupines(let value): return value.rawString
            case .cervines(let value): return value.rawString
            case .cowsAndBovines(let value): return value.rawString
            case .dragons(let value): return value.rawString
            case .equestrians(let value): return value.rawString
            case .exoticAndMythicals(let value): return value.rawString
            case .felines(let value): return value.rawString
            case .insects(let value): return value.rawString
            case .mammalsOther(let value): return value.rawString
            case .marsupials(let value): return value.rawString
            case .mustelids(let value): return value.rawString
            case .primates(let value): return value.rawString
            case .reptillian(let value): return value.rawString
            case .rodents(let value): return value.rawString
            case .vulpines(let value): return value.rawString
            case .other(let value): return value.rawString
            }
        }
        
        var name: String {
            switch self {
            case .unspecifiedOrAny: return "Unspecified / Any"
            case .amphibian: return Amphibian.categoryName
            case .aquatic: return Aquatic.categoryName
            case .avian: return Avian.categoryName
            case .bearsAndUrsines: return BearsAndUrsines.categoryName
            case .camelids: return Camelids.categoryName
            case .caninesAndLupines: return CaninesAndLupines.categoryName
            case .cervines: return Cervines.categoryName
            case .cowsAndBovines: return CowsAndBovines.categoryName
            case .dragons: return Dragons.categoryName
            case .equestrians: return Equestrians.categoryName
            case .exoticAndMythicals: return ExoticAndMythicals.categoryName
            case .felines: return Felines.categoryName
            case .insects: return Insects.categoryName
            case .mammalsOther: return MammalsOther.categoryName
            case .marsupials: return Marsupials.categoryName
            case .mustelids: return Mustelids.categoryName
            case .primates: return Primates.categoryName
            case .reptillian: return Reptillian.categoryName
            case .rodents: return Rodents.categoryName
            case .vulpines: return Vulpines.categoryName
            case .other: return Other.categoryName
            }
        }
        
        static var model: SettingModel {
            return SettingModel(sections: [SettingSection(category: "Unspecified / Any", items: []) , Amphibian.section, Aquatic.section, Avian.section, BearsAndUrsines.section, Camelids.section, CaninesAndLupines.section, Cervines.section, CowsAndBovines.section, Dragons.section, Equestrians.section, ExoticAndMythicals.section, Felines.section, Insects.section, MammalsOther.section, Marsupials.section, Mustelids.section, Primates.section, Reptillian.section, Rodents.section, Vulpines.section, Other.section])
        }
    }
    
    enum Amphibian: Int, BrowseSetting {
        case frog = 1001
        case newt
        case salamander
        case amphibianOther = 1000
        
        static var categoryName: String {
            return "Amphibian"
        }
        
        var name: String {
            switch self {
            case .amphibianOther:
                return "Amphibian (Other)"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum Aquatic: Int, BrowseSetting {
        case cephalopod = 2001
        case dolphin
        case fish
        case porpoise
        case seal
        case shark
        case whale
        case aquaticOther = 2000
        
        static var categoryName: String {
            return "Aquatic"
        }
        
        var name: String {
            switch self {
            case .aquaticOther:
                return "Aquatic (Other)"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum Avian: Int, BrowseSetting {
        case corvid = 3001
        case crow
        case duck
        case eagle
        case falcon
        case goose
        case gryphon
        case hawk
        case owl
        case phoenix
        case swan
        case avianOther = 3000
        
        static var categoryName: String {
            return "Avian"
        }
        
        var name: String {
            switch self {
            case .avianOther:
                return "Avian (Other)"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum BearsAndUrsines: Int, BrowseSetting {
        case bear = 6002
        
        static var categoryName: String {
            return "Bears & Ursines"
        }
        
        var name: String {
            return String(describing: self).capitalized
        }
    }
    
    enum Camelids: Int, BrowseSetting {
        case camel = 6074
        case lama = 6036
        
        static var categoryName: String {
            return "Camelids"
        }
        
        var name: String {
            return String(describing: self).capitalized
        }
    }
    
    enum CaninesAndLupines: Int, BrowseSetting {
        case coyote = 6008
        case doberman
        case dog
        case dingo
        case germanShepherd
        case jackal
        case husky
        case wolf = 6016
        case canineOther
        
        static var categoryName: String {
            return "Canines & Lupines"
        }
        
        var name: String {
            switch self {
            case .germanShepherd:
                return "German Shepherd"
            case .canineOther:
                return "Canine (Other)"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum Cervines: Int, BrowseSetting {
        case cervineOther = 6018
        
        static var categoryName: String {
            return "Cervines"
        }
        
        var name: String {
            switch self {
            case .cervineOther:
                return "Cervine (Other)"
            }
        }
    }
    
    enum CowsAndBovines: Int, BrowseSetting {
        case antelope = 6004
        case cows = 6003
        case gazelle = 6005
        case goat
        case bovinesGeneral
        
        static var categoryName: String {
            return "Cows & Bovines"
        }
        
        var name: String {
            switch self {
            case .bovinesGeneral:
                return "Bovines (General)"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum Dragons: Int, BrowseSetting {
        case easternDragon = 4001
        case hydra
        case serpent
        case westernDragon
        case wyvern
        case dragonOther = 4000
        
        static var categoryName: String {
            return "Dragons"
        }
        
        var name: String {
            switch self {
            case .easternDragon:
                return "Eastern Dragon"
            case .westernDragon:
                return "Western Dragon"
            case .dragonOther:
                return "Dragon (Other)"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum Equestrians: Int, BrowseSetting {
        case donkey = 6019
        case horse = 6034
        case pony = 6073
        case zebra = 6071
        
        static var categoryName: String {
            return "Equestrians"
        }
        
        var name: String {
            return String(describing: self).capitalized
        }
    }
    
    enum ExoticAndMythicals: Int, BrowseSetting {
        case argonian = 5002
        case chakat
        case chocobo
        case citra
        case crux
        case daemon
        case digimon
        case dracat
        case draenei
        case elf
        case gargoyle
        case iksar
        case kaijuOrMonster = 5015
        case langurhali = 5014
        case moogle = 5017
        case naga = 5016
        case orc = 5018
        case pokemon
        case satyr
        case sergal
        case tanuki
        case unicorn
        case xenomorph
        case alienOther = 5001
        case exoticOther = 5000
        
        static var categoryName: String {
            return "Exotic & Mythicals"
        }
        
        var name: String {
            switch self {
            case .kaijuOrMonster:
                return "Kaiju/Monster"
            case .alienOther:
                return "Alien (Other)"
            case .exoticOther:
                return "Exotic (Other)"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum Felines: Int, BrowseSetting {
        case domesticCat = 6020
        case cheetah
        case cougar
        case jaguar
        case leopard
        case lion
        case lynx
        case ocelot
        case panther
        case tiger
        case felineOther
        
        static var categoryName: String {
            return "Felines"
        }
        
        var name: String {
            switch self {
            case .domesticCat:
                return "Domestic Cat"
            case .felineOther:
                return "Feline (Other)"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum Insects: Int, BrowseSetting {
        case arachnid = 8000
        case mantid = 8004
        case scorpion
        case insectOther = 8003
        
        static var categoryName: String {
            return "Insects"
        }
        
        var name: String {
            switch self {
            case .insectOther:
                return "Insect (Other)"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum MammalsOther: Int, BrowseSetting {
        case bat = 6001
        case giraffe = 6031
        case hedgehog
        case hippopotamus
        case hyena = 6035
        case panda = 6052
        case pigOrSwine
        case rabbitOrHare = 6059
        case raccoon
        case redPanda = 6062
        case meerKat = 6043
        case mongoose = 6044
        case rhinoceros = 6063
        case mammalsOther = 6000
        
        static var categoryName: String {
            return "Mammals (Other)"
        }
        
        var name: String {
            switch self {
            case .pigOrSwine:
                return "Pig/Swine"
            case .rabbitOrHare:
                return "Rabbit/Hare"
            case .redPanda:
                return "Red Panda"
            case .mammalsOther:
                return "Mammals (Other)"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum Marsupials: Int, BrowseSetting {
        case opossum = 6037
        case kangaroo
        case koala
        case quoll
        case wallaby
        case marsupialOther
        
        static var categoryName: String {
            return "Marsupials"
        }
        
        var name: String {
            switch self {
            case .marsupialOther:
                return "Marsupial (Other)"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum Mustelids: Int, BrowseSetting {
        case badger = 6045
        case ferret
        case mink = 6048
        case otter = 6047
        case skunk = 6069
        case weasel = 6049
        case mustelidOther = 6051
        
        static var categoryName: String {
            return "Mustelids"
        }
        
        var name: String {
            switch self {
            case .mustelidOther:
                return "Mustelid (Other)"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum Primates: Int, BrowseSetting {
        case gorilla = 6054
        case human
        case lemur
        case monkey
        case primateOther
        
        static var categoryName: String {
            return "Primates"
        }
        
        var name: String {
            switch self {
            case .primateOther:
                return "Primate (Other)"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum Reptillian: Int, BrowseSetting {
        case alligatorAndCrocodile = 7001
        case gecko = 7003
        case iguana
        case lizard
        case snakesAndSerpents
        case reptilianOther = 7000
        
        static var categoryName: String {
            return "Reptillian"
        }
        
        var name: String {
            switch self {
            case .alligatorAndCrocodile:
                return "Alligator & Crocodile"
            case .snakesAndSerpents:
                return "Snakes & Serpents"
            case .reptilianOther:
                return "Reptilian (Other)"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum Rodents: Int, BrowseSetting {
        case beaver = 6064
        case mouse
        case rat = 6061
        case squirrel = 6070
        case rodentOther = 6067
        
        static var categoryName: String {
            return "Rodents"
        }
        
        var name: String {
            switch self {
            case .rodentOther:
                return "Rodent (Other)"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum Vulpines: Int, BrowseSetting {
        case fennec = 6072
        case fox = 6075
        case vulpineOther = 6015
        
        static var categoryName: String {
            return "Vulpines"
        }
        
        var name: String {
            switch self {
            case .vulpineOther:
                return "Vulpine (Other)"
            default:
                return String(describing: self).capitalized
            }
        }
    }
    
    enum Other: Int, BrowseSetting {
        case dinosaur = 8001
        case wolverine = 6050
        
        static var categoryName: String {
            return "Other"
        }
        
        var name: String {
            return String(describing: self).capitalized
        }
    }
    
    //MARK: - Gender -
    
    enum Gender: Int, BrowseSetting {
        
        static var allCases: [Gender] {
            return [.any, .male, .female, .herm, .transgender, .multipleCharacters, .otherOrNotSpecified]
        }
        
        case any
        case male = 2
        case female
        case herm
        case transgender
        case multipleCharacters
        case otherOrNotSpecified
        
        static var categoryName: String {
            return "Gender"
        }
        
        var name: String {
            switch self {
            case .multipleCharacters:
                return "Multiple characters"
            case .otherOrNotSpecified:
                return "Other / Not Specified"
            default:
                return String(describing: self).capitalized
            }
        }
        
        static var model: SettingModel {
            return SettingModel(sections: [Gender.section])
        }
    }
    
    //MARK: - Results -
    
    enum Results: Int, BrowseSetting {
        
        static var allCases: [Results] {
            return [.tf, .fe, .st]
        }
        
        case tf = 24
        case fe = 48
        case st = 72
        
        static var categoryName: String {
            return "Results"
        }
        
        var name: String {
            return rawValue.description
        }
        
        static var model: SettingModel {
            return SettingModel(sections: [Results.section])
        }
    }
}

//MARK: - Protocols -

protocol BrowseSetting: CaseIterable {
    static var categoryName: String {get}
    var name: String {get}
}

extension BrowseSetting where Self: RawRepresentable {

    var rawString: String {
        return String(describing: rawValue)
    }
    
    static var section: SettingSection {
        return SettingSection(category: categoryName, items: allCases.map{SettingItem(text: $0.name, value: $0.rawString)})
    }
}
