//
//  EnumPropertyWrappers.swift
//  GoD Tool
//
//  Created by Stars Momodu on 04/02/2021.
//

import Foundation

@propertyWrapper
struct AbilityID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGAbilities {
		return .index(validate(value))
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value < kNumberOfAbilities else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct BagSlotID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGBagSlots {
		return XGBagSlots(rawValue: validate(value)) ?? .none
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGBagSlots.battleCDs.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct BattleStyleID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGBattleStyles {
		return XGBattleStyles(rawValue: validate(value)) ?? .none
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGBattleStyles.other.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct BattleTypeID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGBattleTypes {
		return XGBattleTypes(rawValue: validate(value)) ?? .none
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGBattleTypes.battle_mode_mt_battle_colo.rawValue else { return 0 }
		return max(0, value)
	}
}

#if GAME_XD
@propertyWrapper
struct BattleBingoItemID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGBattleBingoItem {
		return XGBattleBingoItem(rawValue: validate(value)) ?? .none
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGBattleBingoItem.ePx2.rawValue else { return 0 }
		return max(0, value)
	}
}
#endif

@propertyWrapper
struct ColosseumRoundID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGColosseumRounds {
		return XGColosseumRounds(rawValue: validate(value)) ?? .none
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGColosseumRounds.final.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct ContestCategoryID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGContestCategories {
		return XGContestCategories(rawValue: validate(value)) ?? .cool
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGContestCategories.tough.rawValue else { return 0 }
		return max(0, value)
	}
}

#if GAME_XD
@propertyWrapper
struct DeckID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGDecks {
		return XGDecks.deckWithID(validate(value)) ?? .DeckStory
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGDecks.DeckSample.id else { return 0 }
		return max(0, value)
	}
}
#endif

@propertyWrapper
struct EvolutionMethodsID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGEvolutionMethods {
		return XGEvolutionMethods(rawValue: validate(value)) ?? .none
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		#if GAME_PBR
		guard value <= XGEvolutionMethods.levelUpAtIceRock.rawValue else { return 0 }
		#else
		guard value <= XGEvolutionMethods.Gen4.rawValue else { return 0 }
		#endif
		return max(0, value)
	}
}

@propertyWrapper
struct ExpRateID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGExpRate {
		return XGExpRate(rawValue: validate(value)) ?? .standard
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGExpRate.verySlow.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct FileTypeID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGFileTypes {
		return XGFileTypes(rawValue: validate(value)) ?? .none
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value < XGFileTypes.fsys.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct GenderRatioID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGGenderRatios {
		return XGGenderRatios(rawValue: validate(value)) ?? .maleOnly
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGGenderRatios.genderless.rawValue else { return XGGenderRatios.genderless.rawValue }
		return max(0, value)
	}
}

@propertyWrapper
struct GenderID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGGenders {
		return XGGenders(rawValue: validate(value)) ?? .male
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGGenders.genderless.rawValue else { return XGGenders.genderless.rawValue }
		return max(0, value)
	}
}

@propertyWrapper
struct ItemID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGItems {
		return .index(validate(value))
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value < kNumberOfItems else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct MoveID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGMoves {
		return .index(validate(value))
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value < kNumberOfMoves else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct MoveCategoryID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGMoveCategories {
		return XGMoveCategories(rawValue: validate(value)) ?? .none
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGMoveCategories.special.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct MoveEffectivenessID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGEffectivenessValues {
		return XGEffectivenessValues(rawValue: validate(value)) ?? .ineffective
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		#if GAME_PBR
		guard value <= XGEffectivenessValues.unknown2.rawValue else { return 0 }
		#else
		guard value <= XGEffectivenessValues.neutral.rawValue else { return 0 }
		#endif
		return max(0, value)
	}
}

@propertyWrapper
struct MoveEffectTypeID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGMoveEffectTypes {
		return XGMoveEffectTypes(rawValue: validate(value)) ?? .none
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGMoveEffectTypes.unknown.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct MoveTargetID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGMoveTargets {
		return XGMoveTargets(rawValue: validate(value)) ?? .selectedTarget
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGMoveTargets.opponentField.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct NatureID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGNatures {
		return XGNatures(rawValue: validate(value)) ?? .hardy
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGNatures.quirky.rawValue || value == XGNatures.random.rawValue else { return XGNatures.random.rawValue }
		return max(0, value)
	}
}

@propertyWrapper
struct PokemonID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGPokemon {
		return .index(validate(value))
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value < kNumberOfPokemon else { return 0 }
		return max(0, value)
	}
}

#if GAME_XD
@propertyWrapper
struct PokespotID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGPokeSpots {
		return XGPokeSpots(rawValue: validate(value)) ?? .rock
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGPokeSpots.all.rawValue else { return XGPokeSpots.all.rawValue }
		return max(0, value)
	}
}
#endif

@propertyWrapper
struct ShinyLockTypeID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGMoveEffectTypes {
		return XGMoveEffectTypes(rawValue: validate(value)) ?? .none
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard let lockValue = XGShinyValues(rawValue: value) else { return XGShinyValues.random.rawValue }
		return lockValue.rawValue
	}
}

@propertyWrapper
struct TMID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGTMs {
		return .tm(validate(value))
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= kNumberOfTMsAndHMs else { return 0 }
		return max(1, value)
	}
}

@propertyWrapper
struct TrainerClassID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGTrainerClasses {
		return XGTrainerClasses(rawValue: validate(value)) ?? .none
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		#if GAME_XD
		let maxVal = XGTrainerClasses.simTrainer2.rawValue
		#else
		let maxVal = XGTrainerClasses.none6.rawValue
		#endif
		guard value <= maxVal else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct TrainerModelID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGTrainerModels {
		return XGTrainerModels(rawValue: validate(value)) ?? .none
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		#if GAME_XD
		let maxVal = XGTrainerModels.michael3WithoutSnagMachine.rawValue
		#else
		let maxVal = XGTrainerModels.chaserF2.rawValue
		#endif
		guard value <= maxVal else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct TutorMoveID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGTMs {
		return .tutor(validate(value))
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= kNumberOfTutorMoves else { return 0 }
		return max(1, value)
	}
}

@propertyWrapper
struct TypeID: Codable {
	var value = 0

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: XGMoveTypes {
		return .index(validate(value))
	}

	init(wrappedValue value: Int) {
		self.value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value < kNumberOfTypes else { return 0 }
		return max(0, value)
	}
}
