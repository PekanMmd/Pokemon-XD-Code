rm -rf spm/virt/GoD-CLI/Sources
mkdir -p spm/virt/GoD-CLI/Sources

rm -rf spm/virt/Colosseum-CLI/Sources
mkdir -p spm/virt/Colosseum-CLI/Sources

rm -rf spm/virt/PBR-CLI/Sources
mkdir -p spm/virt/PBR-CLI/Sources

case "$(uname -s)" in
   Darwin)
     ln -s "$PWD/extensions/OSXExtensions.swift" spm/virt/GoD-CLI/Sources/
     ln -s "$PWD/extensions/OSXExtensions.swift" spm/virt/Colosseum-CLI/Sources/
     ln -s "$PWD/extensions/OSXExtensions.swift" spm/virt/PBR-CLI/Sources/
     ;;

   Linux)
     ln -s "$PWD/extensions/LinuxExtensions.swift" spm/virt/GoD-CLI/Sources/
     ln -s "$PWD/extensions/LinuxExtensions.swift" spm/virt/Colosseum-CLI/Sources/
     ln -s "$PWD/extensions/LinuxExtensions.swift" spm/virt/PBR-CLI/Sources/
     ;;
esac


# GoD Sources
ln -s "$PWD/Objects/textures/GoDTextureImporter.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGEvolutionMethods.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGTrainerClass.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XDSFlags.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/textures/XGTextureBlock.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XDSMacroTypes.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/textures/XGColour.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/GoDToolOSX/Objects/GoDKeyCodes.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/extensions/GoDToolCLExtensions.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/XGBattleBingoPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/GoDTexturesContaining.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGNatures.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/textures/XGPNGBlock.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGStatusEffects.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/GoDShellManager.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGContestCategories.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/helper data types/XGStack.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGBattleBingoPanel.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XGScriptOps.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGResources.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGRoom.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGBattleCD.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/textures/GoDTexture.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGDoor.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGLZSS.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGTrainerModels.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGTHP.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/extensions/XGExtensions.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/GoDTextureFormats.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGExpRate.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGPokeSpotPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGAssemblyCode.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/extensions/XGOSXExtensions.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGDecks.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGBagSlots.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGItems.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGInteractionPoint.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XDSExpr.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/textures/XGTexturePalette.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGSpecialStringCharacters.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/XGRandomiser.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/XGDolPatcher.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGAssemblyCodeExtensions.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGGenders.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGColosseumRounds.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGBattleBingoCard.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGStringTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/XGGiftPokemonManager.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGMaps.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGShinyValues.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGMoveTargets.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGCollisionData.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/protocols/EnumerableDocumentable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/XGStringManager.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGDemoStarterPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGTreasure.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/XGCharacter.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGMtBattlePokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGTrainerContoller.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XDSConstant.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/DummyThreadManager.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XGScript.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/XGString.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/XGSettings.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGGenderRatios.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGStoryProgress.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGType.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGDeckPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGTradePokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/XDRelIndexes.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGMoveEffectTypes.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGMoves.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/extensions/GoDImageExtensions.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGGSWTextures.swift" spm/virt/GoD-CLI/Sources/
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
ln -s "$PWD/Objects/data types/enumerable/XGMusic.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/helper data types/XGMutableData.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGASM.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/textures/XGTextureMetaData.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGFileTypes.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGFiles.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGCharacterModel.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGWeather.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGBattleField.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGUnicodeCharacters.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGEffectivenessValues.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/extensions/XDExtensions.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/managers/XGUtility.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGEvolutionConditionType.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGBattleTypes.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGTrainerPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGStarterPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGPokemonStats.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/extensions/XDSExtensions.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGAbilities.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGRelocationTable.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGGiftPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/GoD-CLI/main.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGMoveTypes.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/XGEvolution.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XGScriptInstruction.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/CMGiftPokemon.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGFsys.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGBattleStyles.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XGScriptClass.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/extensions/GoDOSXExtensions.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/GoDToolOSX/Objects/XGVertex.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGBattle.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/scripts/XD/XDSScriptCompiler.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGItem.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGPokeSpots.swift" spm/virt/GoD-CLI/Sources/
ln -s "$PWD/enums/XGTMs.swift" spm/virt/GoD-CLI/Sources/
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
ln -s "$PWD/Objects/textures/GoDTexture.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGAbilities.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/XGLevelUpMove.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGUnicodeCharacters.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/XGSaveManager.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/scripts/Colosseum/CMScriptStandardFunctions.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/CMFiles.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/XGCharacter.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGResources.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/DummyThreadManager.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGContestCategories.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/scripts/Colosseum/CMScript.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/textures/XGTexturePalette.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/CMGiftPokemon.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/helper data types/XGStack.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/extensions/CMOSXExtensions.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGTreasure.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGStatusEffects.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGStatBoosts.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/CMTrainerPokemon.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGMoveTypes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGCollisionData.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/XGStringManager.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/CMType.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/CMPokemonStats.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGGenderRatios.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGTrainerClass.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/XGDolPatcher.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGFontColours.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/extensions/ColosseumToolCLExtensions.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGBattleTypes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGRelocationTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGStringTable.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGMoveEffectTypes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/scripts/Colosseum/CMScriptValueTypes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/CMItem.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/extensions/ColosseumExtensions.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGDoor.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/CMColosseumRounds.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/textures/GoDTextureImporter.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/extensions/GoDImageExtensions.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGStarterPokemon.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGLZSS.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGFsys.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/CMBattle.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGNatures.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/helper data types/XGMutableData.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/GoDToolOSX/Objects/GoDKeyCodes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/textures/XGPNGBlock.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/GoDToolOSX/Objects/XGVertex.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGTrainerContoller.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/CMTrainerModels.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/CMGiftPokemonManager.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/GoDTexturesContaining.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/textures/XGTextureBlock.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGWeather.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/CMItems.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGMoves.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGNature.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGRoom.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/CMTrainer.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/extensions/GoDOSXExtensions.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/GoDShellManager.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGExpRate.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGISO.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/CMTMs.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/scripts/Colosseum/CMScriptOps.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGGenders.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/CMRelIndexes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/XGString.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/scripts/Colosseum/CMScriptCompiler.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGPokemon.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGDemoStarterPokemon.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGAssemblyCodeExtensions.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGShinyValues.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGGSWTextures.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGInteractionPoint.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGFileTypes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGBattleField.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/extensions/XGExtensions.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/CMRandomiser.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/XGSettings.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGBattleStyles.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGEvolutionMethods.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Colosseum-CLI/main.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/textures/XGImage.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/GoDTextureFormats.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/managers/XGUtility.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGCharacterModel.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGASM.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGDeoxysFormes.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGMaps.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/XGSpecialStringCharacters.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/textures/XGColour.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGAssemblyCode.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGGiftPokemon.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/enums/CMTrainerClasses.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/Objects/data types/enumerable/XGMove.swift" spm/virt/Colosseum-CLI/Sources/
ln -s "$PWD/protocols/EnumerableDocumentable.swift" spm/virt/Colosseum-CLI/Sources/

# PBR Sources
ln -s "$PWD/enums/XGResources.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGFsys.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/GoDToolOSX/Objects/GoDKeyCodes.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRType.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/GoDToolOSX/Objects/XGVertex.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/extensions/GoDImageExtensions.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRTMs.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRMoveTypes.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/data types/XGEvolution.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRDataTableEntry.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRMove.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGWormadamForms.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRScriptOps.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRMoveCategory.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRDecks.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGNatures.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRFiles.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRPokemonStats.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRUnicodeCharacters.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRTrainerModels.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGTHP.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRTypeManager.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRScriptInstruction.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRISO.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGGenders.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRPokemonSprite.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRTrainer.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRContestAppeals.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/extensions/XGExtensions.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/extensions/PBRExtensions.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRScriptClass.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBREffectivenessValues.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/extensions/PBRCLExtensions.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRFileTypes.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/data types/XGString.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRAbilities.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGExpRate.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRExpr.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGASM.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/textures/XGTextureBlock.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/managers/GoDShellManager.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRDolPatcher.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/GoDTextureFormats.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRPokemon.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/managers/DummyThreadManager.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRDeckTrainer.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGGSWTextures.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRSpecialStringCharacters.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRMoves.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGShinyValues.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGWeather.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRScriptCompiler.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGEvolutionConditionType.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGLZSS.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBREvolutionMethods.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGBattleStyles.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/data types/XGLevelUpMove.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/textures/GoDTextureImporter.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/textures/XGTexturePalette.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGContestCategories.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/protocols/EnumerableDocumentable.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/managers/XGSettings.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRMoveTargets.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRDeckPokemon.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRItem.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRConstant.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGGenderRatios.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRStringTable.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/PBR-CLI/main.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRTextureContainingFormats.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRTrainerPokemon.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/textures/GoDTexture.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/file formats/XGAssemblyCode.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRScriptClassData.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRItems.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/enums/XGDeoxysFormes.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/file formats/GoDTexturesContaining.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/textures/XGImage.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/textures/XGColour.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/helper data types/XGStack.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/enums/PBRMoveEffectTypes.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/extensions/GoDOSXExtensions.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/helper data types/XGMutableData.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRScript.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Revolution Tool CL/objects/PBRDataTable.swift" spm/virt/PBR-CLI/Sources/
ln -s "$PWD/Objects/textures/XGPNGBlock.swift" spm/virt/PBR-CLI/Sources/