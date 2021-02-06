//
//  EnumPropertyWrappers.swift
//  GoD Tool
//
//  Created by Stars Momodu on 04/02/2021.
//

import Foundation

@propertyWrapper
struct AbilityID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGAbilities {
		return .index(validate(_value))
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value < kNumberOfAbilities else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct BagSlotID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGBagSlots {
		return XGBagSlots(rawValue: validate(_value)) ?? .none
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGBagSlots.battleCDs.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct BattleStyleID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGBattleStyles {
		return XGBattleStyles(rawValue: validate(_value)) ?? .none
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGBattleStyles.other.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct BattleTypeID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGBattleTypes {
		return XGBattleTypes(rawValue: validate(_value)) ?? .none
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGBattleTypes.battle_mode_mt_battle_colo.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct BattleBingoItemID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGBattleBingoItem {
		return XGBattleBingoItem(rawValue: validate(_value)) ?? .none
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGBattleBingoItem.ePx2.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct ColosseumRoundID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGColosseumRounds {
		return XGColosseumRounds(rawValue: validate(_value)) ?? .none
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGColosseumRounds.final.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct ContestCategoryID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGContestCategories {
		return XGContestCategories(rawValue: validate(_value)) ?? .cool
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGContestCategories.tough.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct DeckID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGDecks {
		return XGDecks.deckWithID(validate(_value)) ?? .DeckStory
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGDecks.DeckSample.id else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct EvolutionMethodsID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGEvolutionMethods {
		return XGEvolutionMethods(rawValue: validate(_value)) ?? .none
	}

	init(wrappedValue value: Int) {
		_value = value
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
struct ExpRateID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGExpRate {
		return XGExpRate(rawValue: validate(_value)) ?? .standard
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGExpRate.verySlow.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct FileTypeID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGFileTypes {
		return XGFileTypes(rawValue: validate(_value)) ?? .none
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value < XGFileTypes.fsys.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct GenderRatioID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGGenderRatios {
		return XGGenderRatios(rawValue: validate(_value)) ?? .maleOnly
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGGenderRatios.genderless.rawValue else { return XGGenderRatios.genderless.rawValue }
		return max(0, value)
	}
}

@propertyWrapper
struct GenderID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGGenders {
		return XGGenders(rawValue: validate(_value)) ?? .male
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGGenders.genderless.rawValue else { return XGGenders.genderless.rawValue }
		return max(0, value)
	}
}

@propertyWrapper
struct ItemID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGItems {
		return .index(validate(_value))
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value < kNumberOfItems else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct MoveID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGMoves {
		return .index(validate(_value))
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value < kNumberOfMoves else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct MoveCategoryID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGMoveCategories {
		return XGMoveCategories(rawValue: validate(_value)) ?? .none
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGMoveCategories.special.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct MoveEffectivenessID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGEffectivenessValues {
		return XGEffectivenessValues(rawValue: validate(_value)) ?? .ineffective
	}

	init(wrappedValue value: Int) {
		_value = value
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
struct MoveEffectTypeID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGMoveEffectTypes {
		return XGMoveEffectTypes(rawValue: validate(_value)) ?? .none
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGMoveEffectTypes.unknown.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct MoveTargetID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGMoveTargets {
		return XGMoveTargets(rawValue: validate(_value)) ?? .selectedTarget
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGMoveTargets.opponentField.rawValue else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct NatureID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGNatures {
		return XGNatures(rawValue: validate(_value)) ?? .hardy
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGNatures.quirky.rawValue || value == XGNatures.random.rawValue else { return XGNatures.random.rawValue }
		return max(0, value)
	}
}

@propertyWrapper
struct PokemonID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGPokemon {
		return .index(validate(_value))
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value < kNumberOfPokemon else { return 0 }
		return max(0, value)
	}
}

@propertyWrapper
struct PokespotID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGPokeSpots {
		return XGPokeSpots(rawValue: validate(_value)) ?? .rock
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= XGPokeSpots.all.rawValue else { return XGPokeSpots.all.rawValue }
		return max(0, value)
	}
}

@propertyWrapper
struct ShinyLockTypeID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGMoveEffectTypes {
		return XGMoveEffectTypes(rawValue: validate(_value)) ?? .none
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard let lockValue = XGShinyValues(rawValue: value) else { return XGShinyValues.random.rawValue }
		return lockValue.rawValue
	}
}

@propertyWrapper
struct TMID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGTMs {
		return .tm(validate(_value))
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= kNumberOfTMsAndHMs else { return 0 }
		return max(1, value)
	}
}

@propertyWrapper
struct TrainerClassID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGTrainerClasses {
		return XGTrainerClasses(rawValue: validate(_value)) ?? .none
	}

	init(wrappedValue value: Int) {
		_value = value
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
struct TrainerModelID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGTrainerModels {
		return XGTrainerModels(rawValue: validate(_value)) ?? .none
	}

	init(wrappedValue value: Int) {
		_value = value
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
struct TutorMoveID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGTMs {
		return .tutor(validate(_value))
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value <= kNumberOfTutorMoves else { return 0 }
		return max(1, value)
	}
}

@propertyWrapper
struct TypeID {
	var _value = 0

	var wrappedValue: Int {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: XGMoveTypes {
		return .index(validate(_value))
	}

	init(wrappedValue value: Int) {
		_value = value
	}

	private func validate(_ value: Int) -> Int {
		guard value < kNumberOfTypes else { return 0 }
		return max(0, value)
	}
}
