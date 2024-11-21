rm -rf spm/virt/GoD-CLI/Sources
mkdir -p spm/virt/GoD-CLI/Sources

rm -rf spm/virt/Colosseum-CLI/Sources
mkdir -p spm/virt/Colosseum-CLI/Sources

rm -rf spm/virt/PBR-CLI/Sources
mkdir -p spm/virt/PBR-CLI/Sources


# GoD Sources
ln -s "$PWD/Objects/textures/GoDTextureImporter.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/extensions/XGGeneralExtensions.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGEvolutionMethods.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGTrainerClass.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/helper data types/GoDDataTableEntry.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XDSFlags.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/textures/XGTextureBlock.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XDSMacroTypes.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/WZXModel.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/textures/XGColour.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/MovesTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/GoDToolOSX/Objects/GoDKeyCodes.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/XGBattleBingoPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/TypesTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/GoDTexturesContaining.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGNatures.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/textures/XGPNGBlock.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGDayCareStatus.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGStatusEffects.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/GoDShellManager.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/TexturesTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGContestCategories.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/helper data types/XGStack.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/DeckTables.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGBattleBingoPanel.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XGScriptOps.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGResources.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGRoom.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/TreasureTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGBattleCD.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/textures/GoDTexture.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGDoor.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGLZSS.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGTrainerModels.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGTHP.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/extensions/XGFoundationExtensions.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/GoDTextureFormats.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGExpRate.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGPokeSpotPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGAssemblyCode.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/Battles.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/GoDGameInit.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGDecks.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGBagSlots.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGItems.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGMapRel.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGInteractionPoint.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/StructTablesList.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XDSExpr.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/textures/XGTexturePalette.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGSpecialStringCharacters.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/XGRandomiser.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/XGSaveManager.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/XGPatcher.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGAssemblyCodeExtensions.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/GamesAndLangauages.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGGenders.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGColosseumRounds.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGBattleBingoCard.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/GoDToolCL/CommandLineArgs.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGStringTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/XGGiftPokemonManager.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGMaps.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGShinyValues.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct parsing/CommonStructTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGMoveTargets.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGCollisionData.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/StatusEffectsTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/protocols/EnumerableDocumentable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/XGStringManager.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGDemoStarterPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGTreasure.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/GoDFiltersManager.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/XGCharacter.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGMtBattlePokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGTrainerContoller.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XDSConstant.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/PokespotsTables.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/DummyThreadManager.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/BattleBingoTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XGScript.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/AbilitiesTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/SmallStructTables.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/XGString.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/XGSettings.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGGenderRatios.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/SaveFileTables.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XGStoryProgress.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/DATNodes.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGType.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGDeckPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/GoDLogManager.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct parsing/GoDStruct.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGTradePokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/XDRelIndexes.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGMoveEffectTypes.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/RoomsTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct parsing/GoDStructTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGMoves.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/extensions/GoDImageExtensions.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGGSWTextures.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGBattleModeRulesets.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGTradeShadowPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGMove.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/XGLevelUpMove.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGFontColours.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGISO.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/textures/XGImage.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGDeoxysFormes.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGNature.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XGScriptClassFunctionsData.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGPokemart.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/GoDToolOSX/Objects/GoDOpenGL.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGMusic.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct parsing/EncodableTableTypes.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/helper data types/XGMutableData.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGASM.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/textures/XGTextureMetaData.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGFileTypes.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGFiles.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGCharacterModel.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGWeather.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGBattleField.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGUnicodeCharacters.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/PKXWZXTables.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGEffectivenessValues.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/extensions/XDExtensions.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/PKXModel.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/XGUtility.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGEvolutionConditionType.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGEggGroups.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/GSFsys.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGBattleTypes.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGTrainerPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/PokemonTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGStarterPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGPokemonStats.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XDSExtensions.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/InteractionPointTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGAbilities.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/helper data types/GoDDataTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGRelocationTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGGiftPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/GoD-CLI/main.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/CharacterModelTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGMoveTypes.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/XGEvolution.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/MirorBDataTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XGScriptInstruction.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/CMGiftPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGFsys.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/DATModel.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGBattleStyles.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XGScriptClass.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/GoDToolOSX/Objects/XGVertex.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/ItemsTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGBattle.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XDSScriptCompiler.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct parsing/GoDStructData.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGItem.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGPokeSpots.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGTMs.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/struct tables/NatureTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGMoveCategory.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGTrainer.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGStatBoosts.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGTrainerClasses.swift" spm/virt/GoD-CLI/Sources/

# Colo Sources
ln -s "$PWD/Objects/data types/XGEvolution.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGMoveTargets.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGEvolutionConditionType.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGEffectivenessValues.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGBagSlots.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGMoveCategory.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGTHP.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/scripts/Colosseum/CMSMacroTypes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/StructTablesList.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/CMTrainersTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGDayCareStatus.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/scripts/Colosseum/CMSExpr.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/InteractionPointTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct parsing/GoDStructData.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/textures/GoDTexture.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGAbilities.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/XGLevelUpMove.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGUnicodeCharacters.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/XGSaveManager.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/XGCharacter.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct parsing/GoDStructTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/AbilitiesTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGResources.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/DummyThreadManager.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct parsing/GoDStruct.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGColosseumRounds.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/TreasureTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGContestCategories.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/scripts/Colosseum/CMScriptBuiltInFunctions.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/StatusEffectsTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/scripts/Colosseum/CMScript.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/textures/XGTexturePalette.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/CMGiftPokemon.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/helper data types/XGStack.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGTreasure.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGStatusEffects.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGStatBoosts.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/CMTrainerPokemon.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGMoveTypes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGCollisionData.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/DATNodes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/SaveFileTables.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/XGStringManager.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/CMType.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/CMPokemonStats.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGGenderRatios.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGTrainerClass.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/XGPatcher.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGFontColours.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGBattleTypes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGRelocationTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/TexturesTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGStringTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGMapRel.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/MovesTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGMoveEffectTypes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/scripts/Colosseum/CMScriptValueTypes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGBattleStyles.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/CMItem.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/extensions/ColosseumExtensions.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGDoor.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/textures/GoDTextureImporter.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGEggGroups.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/RoomsTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/CMDecks.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct parsing/CommonStructTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/PokemonTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGStarterPokemon.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGLZSS.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/TypesTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGFsys.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct parsing/EncodableTableTypes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/CMBattle.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/GoDToolCL/CommandLineArgs.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGNatures.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/helper data types/XGMutableData.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/GoDToolOSX/Objects/GoDKeyCodes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/textures/XGPNGBlock.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/CharacterModelTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/EreaderTables.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/GoDToolOSX/Objects/XGVertex.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGTrainerContoller.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/CMTrainerModels.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/CMGiftPokemonManager.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/GoDTexturesContaining.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/textures/XGTextureBlock.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/extensions/GoDImageExtensions.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGWeather.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/CMItems.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/GoDGameInit.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/WZXModel.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGMoves.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGNature.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/GamesAndLangauages.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGRoom.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/CMTrainer.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/helper data types/GoDDataTableEntry.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/GoDShellManager.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/ItemsTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGExpRate.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGISO.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/CMTMs.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/scripts/Colosseum/CMSFlags.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/scripts/Colosseum/CMScriptOps.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGGenders.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/SmallStructTables.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/extensions/XGGeneralExtensions.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/XGRandomiser.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/CMRelIndexes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/XGString.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/scripts/Colosseum/CMScriptCompiler.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/GoDLogManager.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGPokemon.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGDemoStarterPokemon.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGBattleModeRulesets.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGAssemblyCodeExtensions.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGShinyValues.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGGSWTextures.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGInteractionPoint.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGFileTypes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGBattleField.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/extensions/XGFoundationExtensions.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/helper data types/GoDDataTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/XGSettings.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/GSFsys.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGEvolutionMethods.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/NatureTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/scripts/Colosseum/CMSExtensions.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/textures/XGImage.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/GoDTextureFormats.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/XGUtility.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGCharacterModel.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGASM.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/GoDFiltersManager.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGDeoxysFormes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGMaps.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/DATModel.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGSpecialStringCharacters.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/PKXWZXTables.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/textures/XGColour.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGAssemblyCode.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGGiftPokemon.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/CMTrainerClasses.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/struct tables/Battles.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/GoD-CLI/main.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGMove.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGFiles.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/GoDToolOSX/Objects/GoDOpenGL.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/protocols/EnumerableDocumentable.swift" spm/virt/Colosseum-CLI/Sources/

# PBR Sources
ln -s "$PWD/GoD-CLI/main.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/GamesAndLangauages.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRAbilitiesManager.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/structs/PokemonModelsTable.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/structs/TypeMatchupsTable.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGResources.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGFsys.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/GoDToolOSX/Objects/GoDKeyCodes.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRType.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/GoDLogManager.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/GoDToolOSX/Objects/XGVertex.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRTMs.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRMoveTypes.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/structs/SmallStructTables.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/data types/XGEvolution.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/GoDToolCL/CommandLineArgs.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/helper data types/GoDDataTableEntry.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRMove.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGWormadamForms.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/file formats/GSFsys.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/managers/XGUtility.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRMoveCategory.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGNatures.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGFiles.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRPokemonStats.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRUnicodeCharacters.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRTrainerModels.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/structs/ItemStatsTable.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGTHP.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRTypeManager.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRScriptInstruction.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/managers/XGStringManager.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGGenders.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRPokemonSprite.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/managers/XGRandomiser.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/struct parsing/PBRCommonStructTable.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRTrainer.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/GoDGameInit.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/extensions/XGFoundationExtensions.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/struct parsing/EncodableTableTypes.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/GoDToolOSX/Objects/GoDOpenGL.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/extensions/PBRExtensions.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/struct parsing/GoDStructData.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRScriptClass.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBREffectivenessValues.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRFileTypes.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/data types/XGString.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRAbilities.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGExpRate.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/structs/PBRStringManager.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRExpr.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGASM.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/textures/XGTextureBlock.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/managers/GoDShellManager.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRPatcher.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/GoDTextureFormats.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/managers/GoDFiltersManager.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRPokemon.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/struct parsing/GoDStruct.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGAssemblyCodeExtensions.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/extensions/XGGeneralExtensions.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/managers/DummyThreadManager.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGGSWTextures.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGEggGroups.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRSpecialStringCharacters.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRMoves.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGShinyValues.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGWeather.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRScriptCompiler.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGEvolutionConditionType.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/structs/DeckStructTable.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGLZSS.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBREvolutionMethods.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/structs/MoveStatsTable.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGBattleStyles.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/data types/XGLevelUpMove.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/textures/GoDTextureImporter.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/structs/PokemonStatsTable.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/textures/XGTexturePalette.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XDSConstant.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGContestCategories.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/protocols/EnumerableDocumentable.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/managers/XGSettings.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGISO.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/extensions/GoDImageExtensions.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRMoveTargets.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRItem.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGGenderRatios.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRStringTable.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRTextureContainingFormats.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRTrainerPokemon.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/textures/GoDTexture.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/structs/StructTablesList.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGAssemblyCode.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRScriptClassData.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRItems.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGDeoxysFormes.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/file formats/GoDTexturesContaining.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/textures/XGImage.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/struct parsing/GoDStructTable.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/textures/XGColour.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/helper data types/XGStack.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XGScriptOps.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRMoveEffectTypes.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/helper data types/XGMutableData.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRScript.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/helper data types/GoDDataTable.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/textures/XGPNGBlock.swift" spm/virt/PBR-CLI/Sources/
