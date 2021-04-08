setlocal enableextensions

rmdir /s /q spm\virt\GoD-CLI\Sources
md spm\virt\GoD-CLI\Sources

rmdir /s /q spm\virt\Colosseum-CLI\Sources
md spm\virt\Colosseum-CLI\Sources

rmdir /s /q spm\virt\PBR-CLI\Sources
md spm\virt\PBR-CLI\Sources

endlocal


REM GoD Sources
mklink "spm\virt\GoD-CLI\Sources\GoDTextureImporter.swift" "%cd%\Objects\textures\GoDTextureImporter.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGGeneralExtensions.swift" "%cd%\extensions\XGGeneralExtensions.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGEvolutionMethods.swift" "%cd%\enums\XGEvolutionMethods.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGTrainerClass.swift" "%cd%\Objects\data types\enumerable\XGTrainerClass.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\GoDDataTableEntry.swift" "%cd%\Objects\helper data types\GoDDataTableEntry.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XDSFlags.swift" "%cd%\Objects\scripts\XD\XDSFlags.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGTextureBlock.swift" "%cd%\Objects\textures\XGTextureBlock.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XDSMacroTypes.swift" "%cd%\enums\XDSMacroTypes.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGColour.swift" "%cd%\Objects\textures\XGColour.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\MovesTable.swift" "%cd%\Objects\struct tables\MovesTable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\GoDKeyCodes.swift" "%cd%\GoDToolOSX\Objects\GoDKeyCodes.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGBattleBingoPokemon.swift" "%cd%\Objects\data types\XGBattleBingoPokemon.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\TypesTable.swift" "%cd%\Objects\struct tables\TypesTable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\GoDTexturesContaining.swift" "%cd%\Objects\file formats\GoDTexturesContaining.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGNatures.swift" "%cd%\enums\XGNatures.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGPNGBlock.swift" "%cd%\Objects\textures\XGPNGBlock.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGStatusEffects.swift" "%cd%\enums\XGStatusEffects.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\GoDShellManager.swift" "%cd%\Objects\managers\GoDShellManager.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\TexturesTable.swift" "%cd%\Objects\struct tables\TexturesTable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGContestCategories.swift" "%cd%\enums\XGContestCategories.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGStack.swift" "%cd%\Objects\helper data types\XGStack.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\DeckTables.swift" "%cd%\Objects\struct tables\DeckTables.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGBattleBingoPanel.swift" "%cd%\enums\XGBattleBingoPanel.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGScriptOps.swift" "%cd%\Objects\scripts\XD\XGScriptOps.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGResources.swift" "%cd%\enums\XGResources.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGRoom.swift" "%cd%\Objects\data types\enumerable\XGRoom.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\TreasureTable.swift" "%cd%\Objects\struct tables\TreasureTable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGBattleCD.swift" "%cd%\Objects\data types\enumerable\XGBattleCD.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\GoDTexture.swift" "%cd%\Objects\textures\GoDTexture.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGDoor.swift" "%cd%\Objects\data types\enumerable\XGDoor.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGLZSS.swift" "%cd%\Objects\file formats\XGLZSS.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGTrainerModels.swift" "%cd%\enums\XGTrainerModels.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGTHP.swift" "%cd%\Objects\file formats\XGTHP.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGFoundationExtensions.swift" "%cd%\extensions\XGFoundationExtensions.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\GoDTextureFormats.swift" "%cd%\enums\GoDTextureFormats.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGExpRate.swift" "%cd%\enums\XGExpRate.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGPokeSpotPokemon.swift" "%cd%\Objects\data types\enumerable\XGPokeSpotPokemon.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGAssemblyCode.swift" "%cd%\Objects\file formats\XGAssemblyCode.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\Battles.swift" "%cd%\Objects\struct tables\Battles.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\GoDGameInit.swift" "%cd%\GoDGameInit.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGDecks.swift" "%cd%\enums\XGDecks.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGBagSlots.swift" "%cd%\enums\XGBagSlots.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGItems.swift" "%cd%\enums\XGItems.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGMapRel.swift" "%cd%\Objects\file formats\XGMapRel.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGInteractionPoint.swift" "%cd%\Objects\data types\enumerable\XGInteractionPoint.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\StructTablesList.swift" "%cd%\Objects\struct tables\StructTablesList.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XDSExpr.swift" "%cd%\Objects\scripts\XD\XDSExpr.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGTexturePalette.swift" "%cd%\Objects\textures\XGTexturePalette.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGSpecialStringCharacters.swift" "%cd%\enums\XGSpecialStringCharacters.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGRandomiser.swift" "%cd%\Objects\managers\XGRandomiser.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGPatcher.swift" "%cd%\Objects\managers\XGPatcher.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGAssemblyCodeExtensions.swift" "%cd%\Objects\file formats\XGAssemblyCodeExtensions.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGGenders.swift" "%cd%\enums\XGGenders.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGColosseumRounds.swift" "%cd%\enums\XGColosseumRounds.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGBattleBingoCard.swift" "%cd%\Objects\data types\enumerable\XGBattleBingoCard.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\CommandLineArgs.swift" "%cd%\GoDToolCL\CommandLineArgs.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGStringTable.swift" "%cd%\Objects\file formats\XGStringTable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGGiftPokemonManager.swift" "%cd%\Objects\managers\XGGiftPokemonManager.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGMaps.swift" "%cd%\enums\XGMaps.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGShinyValues.swift" "%cd%\enums\XGShinyValues.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\CommonStructTable.swift" "%cd%\Objects\struct parsing\CommonStructTable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGMoveTargets.swift" "%cd%\enums\XGMoveTargets.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGCollisionData.swift" "%cd%\Objects\file formats\XGCollisionData.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\EnumerableDocumentable.swift" "%cd%\Objects\protocols\EnumerableDocumentable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGStringManager.swift" "%cd%\Objects\managers\XGStringManager.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGDemoStarterPokemon.swift" "%cd%\Objects\data types\enumerable\XGDemoStarterPokemon.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGTreasure.swift" "%cd%\Objects\data types\enumerable\XGTreasure.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGCharacter.swift" "%cd%\Objects\data types\XGCharacter.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGMtBattlePokemon.swift" "%cd%\Objects\data types\enumerable\XGMtBattlePokemon.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGTrainerContoller.swift" "%cd%\enums\XGTrainerContoller.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XDSConstant.swift" "%cd%\Objects\scripts\XD\XDSConstant.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\PokespotsTables.swift" "%cd%\Objects\struct tables\PokespotsTables.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\DummyThreadManager.swift" "%cd%\Objects\managers\DummyThreadManager.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\BattleBingoTable.swift" "%cd%\Objects\struct tables\BattleBingoTable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGScript.swift" "%cd%\Objects\scripts\XD\XGScript.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\AbilitiesTable.swift" "%cd%\Objects\struct tables\AbilitiesTable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\SmallStructTables.swift" "%cd%\Objects\struct tables\SmallStructTables.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGString.swift" "%cd%\Objects\data types\XGString.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGSettings.swift" "%cd%\Objects\managers\XGSettings.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGGenderRatios.swift" "%cd%\enums\XGGenderRatios.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGStoryProgress.swift" "%cd%\Objects\scripts\XD\XGStoryProgress.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\DATNodes.swift" "%cd%\Objects\file formats\DATNodes.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGType.swift" "%cd%\Objects\data types\enumerable\XGType.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGDeckPokemon.swift" "%cd%\enums\XGDeckPokemon.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\GoDLogManager.swift" "%cd%\GoDLogManager.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\GoDStruct.swift" "%cd%\Objects\struct parsing\GoDStruct.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGTradePokemon.swift" "%cd%\Objects\data types\enumerable\XGTradePokemon.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XDRelIndexes.swift" "%cd%\XDRelIndexes.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGMoveEffectTypes.swift" "%cd%\enums\XGMoveEffectTypes.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\RoomsTable.swift" "%cd%\Objects\struct tables\RoomsTable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\GoDStructTable.swift" "%cd%\Objects\struct parsing\GoDStructTable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGMoves.swift" "%cd%\enums\XGMoves.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\GoDImageExtensions.swift" "%cd%\extensions\GoDImageExtensions.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGGSWTextures.swift" "%cd%\Objects\file formats\XGGSWTextures.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGBattleModeRulesets.swift" "%cd%\Objects\data types\enumerable\XGBattleModeRulesets.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGTradeShadowPokemon.swift" "%cd%\Objects\data types\enumerable\XGTradeShadowPokemon.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGMove.swift" "%cd%\Objects\data types\enumerable\XGMove.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGLevelUpMove.swift" "%cd%\Objects\data types\XGLevelUpMove.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGFontColours.swift" "%cd%\enums\XGFontColours.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGISO.swift" "%cd%\Objects\file formats\XGISO.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGImage.swift" "%cd%\Objects\textures\XGImage.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGDeoxysFormes.swift" "%cd%\enums\XGDeoxysFormes.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGNature.swift" "%cd%\Objects\data types\enumerable\XGNature.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGScriptClassFunctionsData.swift" "%cd%\Objects\scripts\XD\XGScriptClassFunctionsData.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGPokemart.swift" "%cd%\Objects\data types\enumerable\XGPokemart.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\GoDOpenGL.swift" "%cd%\GoDToolOSX\Objects\GoDOpenGL.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGMusic.swift" "%cd%\Objects\data types\enumerable\XGMusic.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\EncodableTableTypes.swift" "%cd%\Objects\struct parsing\EncodableTableTypes.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGMutableData.swift" "%cd%\Objects\helper data types\XGMutableData.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGASM.swift" "%cd%\enums\XGASM.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGTextureMetaData.swift" "%cd%\Objects\textures\XGTextureMetaData.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGFileTypes.swift" "%cd%\enums\XGFileTypes.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGFiles.swift" "%cd%\enums\XGFiles.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGCharacterModel.swift" "%cd%\Objects\data types\enumerable\XGCharacterModel.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGWeather.swift" "%cd%\enums\XGWeather.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGBattleField.swift" "%cd%\Objects\data types\enumerable\XGBattleField.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGUnicodeCharacters.swift" "%cd%\enums\XGUnicodeCharacters.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\PKXTables.swift" "%cd%\Objects\struct tables\PKXTables.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGEffectivenessValues.swift" "%cd%\enums\XGEffectivenessValues.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XDExtensions.swift" "%cd%\extensions\XDExtensions.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGPokemon.swift" "%cd%\enums\XGPokemon.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGUtility.swift" "%cd%\Objects\managers\XGUtility.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGEvolutionConditionType.swift" "%cd%\enums\XGEvolutionConditionType.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGEggGroups.swift" "%cd%\enums\XGEggGroups.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\GSFsys.swift" "%cd%\Objects\file formats\GSFsys.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGBattleTypes.swift" "%cd%\enums\XGBattleTypes.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGTrainerPokemon.swift" "%cd%\Objects\data types\enumerable\XGTrainerPokemon.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\PokemonTable.swift" "%cd%\Objects\struct tables\PokemonTable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGStarterPokemon.swift" "%cd%\Objects\data types\enumerable\XGStarterPokemon.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGPokemonStats.swift" "%cd%\Objects\data types\enumerable\XGPokemonStats.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XDSExtensions.swift" "%cd%\Objects\scripts\XD\XDSExtensions.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\InteractionPointTable.swift" "%cd%\Objects\struct tables\InteractionPointTable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGAbilities.swift" "%cd%\enums\XGAbilities.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\GoDDataTable.swift" "%cd%\Objects\helper data types\GoDDataTable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGRelocationTable.swift" "%cd%\Objects\file formats\XGRelocationTable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGGiftPokemon.swift" "%cd%\Objects\data types\enumerable\XGGiftPokemon.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\main.swift" "%cd%\GoD-CLI\main.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\CharacterModelTable.swift" "%cd%\Objects\struct tables\CharacterModelTable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGMoveTypes.swift" "%cd%\enums\XGMoveTypes.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGEvolution.swift" "%cd%\Objects\data types\XGEvolution.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGScriptInstruction.swift" "%cd%\Objects\scripts\XD\XGScriptInstruction.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\CMGiftPokemon.swift" "%cd%\Objects\data types\enumerable\CMGiftPokemon.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGFsys.swift" "%cd%\Objects\file formats\XGFsys.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\DATModel.swift" "%cd%\Objects\file formats\DATModel.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGBattleStyles.swift" "%cd%\enums\XGBattleStyles.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGScriptClass.swift" "%cd%\Objects\scripts\XD\XGScriptClass.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGVertex.swift" "%cd%\GoDToolOSX\Objects\XGVertex.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\ItemsTable.swift" "%cd%\Objects\struct tables\ItemsTable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGBattle.swift" "%cd%\Objects\data types\enumerable\XGBattle.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XDSScriptCompiler.swift" "%cd%\Objects\scripts\XD\XDSScriptCompiler.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\GoDStructData.swift" "%cd%\Objects\struct parsing\GoDStructData.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGItem.swift" "%cd%\Objects\data types\enumerable\XGItem.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGPokeSpots.swift" "%cd%\enums\XGPokeSpots.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGTMs.swift" "%cd%\enums\XGTMs.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\NatureTable.swift" "%cd%\Objects\struct tables\NatureTable.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGMoveCategory.swift" "%cd%\enums\XGMoveCategory.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGTrainer.swift" "%cd%\Objects\data types\enumerable\XGTrainer.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGStatBoosts.swift" "%cd%\enums\XGStatBoosts.swift" > NUL
mklink "spm\virt\GoD-CLI\Sources\XGTrainerClasses.swift" "%cd%\enums\XGTrainerClasses.swift" > NUL

REM Colo Sources
mklink "spm\virt\Colosseum-CLI\Sources\XGEvolution.swift" "%cd%\Objects\data types\XGEvolution.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGMoveTargets.swift" "%cd%\enums\XGMoveTargets.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGEvolutionConditionType.swift" "%cd%\enums\XGEvolutionConditionType.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGEffectivenessValues.swift" "%cd%\enums\XGEffectivenessValues.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGBagSlots.swift" "%cd%\enums\XGBagSlots.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGMoveCategory.swift" "%cd%\enums\XGMoveCategory.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGTHP.swift" "%cd%\Objects\file formats\XGTHP.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\StructTablesList.swift" "%cd%\Objects\struct tables\StructTablesList.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\InteractionPointTable.swift" "%cd%\Objects\struct tables\InteractionPointTable.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\GoDStructData.swift" "%cd%\Objects\struct parsing\GoDStructData.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\GoDTexture.swift" "%cd%\Objects\textures\GoDTexture.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGAbilities.swift" "%cd%\enums\XGAbilities.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGLevelUpMove.swift" "%cd%\Objects\data types\XGLevelUpMove.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGUnicodeCharacters.swift" "%cd%\enums\XGUnicodeCharacters.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGSaveManager.swift" "%cd%\Objects\managers\XGSaveManager.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMScriptStandardFunctions.swift" "%cd%\Objects\scripts\Colosseum\CMScriptStandardFunctions.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGCharacter.swift" "%cd%\Objects\data types\XGCharacter.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\GoDStructTable.swift" "%cd%\Objects\struct parsing\GoDStructTable.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\AbilitiesTable.swift" "%cd%\Objects\struct tables\AbilitiesTable.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGResources.swift" "%cd%\enums\XGResources.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\DummyThreadManager.swift" "%cd%\Objects\managers\DummyThreadManager.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\GoDStruct.swift" "%cd%\Objects\struct parsing\GoDStruct.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGColosseumRounds.swift" "%cd%\enums\XGColosseumRounds.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\TreasureTable.swift" "%cd%\Objects\struct tables\TreasureTable.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGContestCategories.swift" "%cd%\enums\XGContestCategories.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMScript.swift" "%cd%\Objects\scripts\Colosseum\CMScript.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGTexturePalette.swift" "%cd%\Objects\textures\XGTexturePalette.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMGiftPokemon.swift" "%cd%\Objects\data types\enumerable\CMGiftPokemon.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGStack.swift" "%cd%\Objects\helper data types\XGStack.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGTreasure.swift" "%cd%\Objects\data types\enumerable\XGTreasure.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGStatusEffects.swift" "%cd%\enums\XGStatusEffects.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGStatBoosts.swift" "%cd%\enums\XGStatBoosts.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMTrainerPokemon.swift" "%cd%\Objects\data types\enumerable\CMTrainerPokemon.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGMoveTypes.swift" "%cd%\enums\XGMoveTypes.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGCollisionData.swift" "%cd%\Objects\file formats\XGCollisionData.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\DATNodes.swift" "%cd%\Objects\file formats\DATNodes.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGStringManager.swift" "%cd%\Objects\managers\XGStringManager.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMType.swift" "%cd%\Objects\data types\enumerable\CMType.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMPokemonStats.swift" "%cd%\Objects\data types\enumerable\CMPokemonStats.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGGenderRatios.swift" "%cd%\enums\XGGenderRatios.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGTrainerClass.swift" "%cd%\Objects\data types\enumerable\XGTrainerClass.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGPatcher.swift" "%cd%\Objects\managers\XGPatcher.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGFontColours.swift" "%cd%\enums\XGFontColours.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGBattleTypes.swift" "%cd%\enums\XGBattleTypes.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGRelocationTable.swift" "%cd%\Objects\file formats\XGRelocationTable.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\TexturesTable.swift" "%cd%\Objects\struct tables\TexturesTable.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGStringTable.swift" "%cd%\Objects\file formats\XGStringTable.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGMapRel.swift" "%cd%\Objects\file formats\XGMapRel.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\MovesTable.swift" "%cd%\Objects\struct tables\MovesTable.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGMoveEffectTypes.swift" "%cd%\enums\XGMoveEffectTypes.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMScriptValueTypes.swift" "%cd%\Objects\scripts\Colosseum\CMScriptValueTypes.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGBattleStyles.swift" "%cd%\enums\XGBattleStyles.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMItem.swift" "%cd%\Objects\data types\enumerable\CMItem.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\ColosseumExtensions.swift" "%cd%\extensions\ColosseumExtensions.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGDoor.swift" "%cd%\Objects\data types\enumerable\XGDoor.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\GoDTextureImporter.swift" "%cd%\Objects\textures\GoDTextureImporter.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGEggGroups.swift" "%cd%\enums\XGEggGroups.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\RoomsTable.swift" "%cd%\Objects\struct tables\RoomsTable.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMDecks.swift" "%cd%\enums\CMDecks.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CommonStructTable.swift" "%cd%\Objects\struct parsing\CommonStructTable.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\PokemonTable.swift" "%cd%\Objects\struct tables\PokemonTable.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGStarterPokemon.swift" "%cd%\Objects\data types\enumerable\XGStarterPokemon.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGLZSS.swift" "%cd%\Objects\file formats\XGLZSS.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\TypesTable.swift" "%cd%\Objects\struct tables\TypesTable.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGFsys.swift" "%cd%\Objects\file formats\XGFsys.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\EncodableTableTypes.swift" "%cd%\Objects\struct parsing\EncodableTableTypes.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMBattle.swift" "%cd%\Objects\data types\enumerable\CMBattle.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CommandLineArgs.swift" "%cd%\GoDToolCL\CommandLineArgs.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGNatures.swift" "%cd%\enums\XGNatures.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGMutableData.swift" "%cd%\Objects\helper data types\XGMutableData.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\GoDKeyCodes.swift" "%cd%\GoDToolOSX\Objects\GoDKeyCodes.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGPNGBlock.swift" "%cd%\Objects\textures\XGPNGBlock.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CharacterModelTable.swift" "%cd%\Objects\struct tables\CharacterModelTable.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGVertex.swift" "%cd%\GoDToolOSX\Objects\XGVertex.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGTrainerContoller.swift" "%cd%\enums\XGTrainerContoller.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMTrainerModels.swift" "%cd%\enums\CMTrainerModels.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMGiftPokemonManager.swift" "%cd%\Objects\managers\CMGiftPokemonManager.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\GoDTexturesContaining.swift" "%cd%\Objects\file formats\GoDTexturesContaining.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGTextureBlock.swift" "%cd%\Objects\textures\XGTextureBlock.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\GoDImageExtensions.swift" "%cd%\extensions\GoDImageExtensions.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGWeather.swift" "%cd%\enums\XGWeather.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMItems.swift" "%cd%\enums\CMItems.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\GoDGameInit.swift" "%cd%\GoDGameInit.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGMoves.swift" "%cd%\enums\XGMoves.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGNature.swift" "%cd%\Objects\data types\enumerable\XGNature.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGRoom.swift" "%cd%\Objects\data types\enumerable\XGRoom.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMTrainer.swift" "%cd%\Objects\data types\enumerable\CMTrainer.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\GoDDataTableEntry.swift" "%cd%\Objects\helper data types\GoDDataTableEntry.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\GoDShellManager.swift" "%cd%\Objects\managers\GoDShellManager.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\ItemsTable.swift" "%cd%\Objects\struct tables\ItemsTable.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGExpRate.swift" "%cd%\enums\XGExpRate.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGISO.swift" "%cd%\Objects\file formats\XGISO.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMTMs.swift" "%cd%\enums\CMTMs.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMScriptOps.swift" "%cd%\Objects\scripts\Colosseum\CMScriptOps.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGGenders.swift" "%cd%\enums\XGGenders.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\SmallStructTables.swift" "%cd%\Objects\struct tables\SmallStructTables.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGGeneralExtensions.swift" "%cd%\extensions\XGGeneralExtensions.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGRandomiser.swift" "%cd%\Objects\managers\XGRandomiser.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMRelIndexes.swift" "%cd%\CMRelIndexes.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGString.swift" "%cd%\Objects\data types\XGString.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMScriptCompiler.swift" "%cd%\Objects\scripts\Colosseum\CMScriptCompiler.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\GoDLogManager.swift" "%cd%\GoDLogManager.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGPokemon.swift" "%cd%\enums\XGPokemon.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGDemoStarterPokemon.swift" "%cd%\Objects\data types\enumerable\XGDemoStarterPokemon.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGBattleModeRulesets.swift" "%cd%\Objects\data types\enumerable\XGBattleModeRulesets.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGAssemblyCodeExtensions.swift" "%cd%\Objects\file formats\XGAssemblyCodeExtensions.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGShinyValues.swift" "%cd%\enums\XGShinyValues.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGGSWTextures.swift" "%cd%\Objects\file formats\XGGSWTextures.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGInteractionPoint.swift" "%cd%\Objects\data types\enumerable\XGInteractionPoint.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGFileTypes.swift" "%cd%\enums\XGFileTypes.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGBattleField.swift" "%cd%\Objects\data types\enumerable\XGBattleField.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGFoundationExtensions.swift" "%cd%\extensions\XGFoundationExtensions.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\GoDDataTable.swift" "%cd%\Objects\helper data types\GoDDataTable.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGSettings.swift" "%cd%\Objects\managers\XGSettings.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\GSFsys.swift" "%cd%\Objects\file formats\GSFsys.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGEvolutionMethods.swift" "%cd%\enums\XGEvolutionMethods.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\NatureTable.swift" "%cd%\Objects\struct tables\NatureTable.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGImage.swift" "%cd%\Objects\textures\XGImage.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\GoDTextureFormats.swift" "%cd%\enums\GoDTextureFormats.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGUtility.swift" "%cd%\Objects\managers\XGUtility.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGCharacterModel.swift" "%cd%\Objects\data types\enumerable\XGCharacterModel.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGASM.swift" "%cd%\enums\XGASM.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGDeoxysFormes.swift" "%cd%\enums\XGDeoxysFormes.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGMaps.swift" "%cd%\enums\XGMaps.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\DATModel.swift" "%cd%\Objects\file formats\DATModel.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGSpecialStringCharacters.swift" "%cd%\enums\XGSpecialStringCharacters.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\PKXTables.swift" "%cd%\Objects\struct tables\PKXTables.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGColour.swift" "%cd%\Objects\textures\XGColour.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGAssemblyCode.swift" "%cd%\Objects\file formats\XGAssemblyCode.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGGiftPokemon.swift" "%cd%\Objects\data types\enumerable\XGGiftPokemon.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\CMTrainerClasses.swift" "%cd%\enums\CMTrainerClasses.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\Battles.swift" "%cd%\Objects\struct tables\Battles.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\main.swift" "%cd%\GoD-CLI\main.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGMove.swift" "%cd%\Objects\data types\enumerable\XGMove.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\XGFiles.swift" "%cd%\enums\XGFiles.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\GoDOpenGL.swift" "%cd%\GoDToolOSX\Objects\GoDOpenGL.swift" > NUL
mklink "spm\virt\Colosseum-CLI\Sources\EnumerableDocumentable.swift" "%cd%\Objects\protocols\EnumerableDocumentable.swift" > NUL

REM PBR Sources
mklink "spm\virt\PBR-CLI\Sources\main.swift" "%cd%\GoD-CLI\main.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGResources.swift" "%cd%\enums\XGResources.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGFsys.swift" "%cd%\Objects\file formats\XGFsys.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\GoDKeyCodes.swift" "%cd%\GoDToolOSX\Objects\GoDKeyCodes.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRType.swift" "%cd%\Revolution Tool CL\objects\PBRType.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\GoDLogManager.swift" "%cd%\GoDLogManager.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGVertex.swift" "%cd%\GoDToolOSX\Objects\XGVertex.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRTMs.swift" "%cd%\Revolution Tool CL\enums\PBRTMs.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRMoveTypes.swift" "%cd%\Revolution Tool CL\enums\PBRMoveTypes.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGEvolution.swift" "%cd%\Objects\data types\XGEvolution.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\CommandLineArgs.swift" "%cd%\GoDToolCL\CommandLineArgs.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\GoDDataTableEntry.swift" "%cd%\Objects\helper data types\GoDDataTableEntry.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRMove.swift" "%cd%\Revolution Tool CL\objects\PBRMove.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGWormadamForms.swift" "%cd%\enums\XGWormadamForms.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\GSFsys.swift" "%cd%\Objects\file formats\GSFsys.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGUtility.swift" "%cd%\Objects\managers\XGUtility.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRMoveCategory.swift" "%cd%\Revolution Tool CL\enums\PBRMoveCategory.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGNatures.swift" "%cd%\enums\XGNatures.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGFiles.swift" "%cd%\enums\XGFiles.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRPokemonStats.swift" "%cd%\Revolution Tool CL\objects\PBRPokemonStats.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRUnicodeCharacters.swift" "%cd%\Revolution Tool CL\enums\PBRUnicodeCharacters.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRTrainerModels.swift" "%cd%\Revolution Tool CL\enums\PBRTrainerModels.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\ItemStatsTable.swift" "%cd%\Revolution Tool CL\structs\ItemStatsTable.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGTHP.swift" "%cd%\Objects\file formats\XGTHP.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRTypeManager.swift" "%cd%\Revolution Tool CL\objects\PBRTypeManager.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRScriptInstruction.swift" "%cd%\Revolution Tool CL\objects\PBRScriptInstruction.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGStringManager.swift" "%cd%\Objects\managers\XGStringManager.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGGenders.swift" "%cd%\enums\XGGenders.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRPokemonSprite.swift" "%cd%\Revolution Tool CL\enums\PBRPokemonSprite.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRCommonStructTable.swift" "%cd%\Objects\struct parsing\PBRCommonStructTable.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRTrainer.swift" "%cd%\Revolution Tool CL\objects\PBRTrainer.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\GoDGameInit.swift" "%cd%\GoDGameInit.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGFoundationExtensions.swift" "%cd%\extensions\XGFoundationExtensions.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\EncodableTableTypes.swift" "%cd%\Objects\struct parsing\EncodableTableTypes.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\GoDOpenGL.swift" "%cd%\GoDToolOSX\Objects\GoDOpenGL.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRExtensions.swift" "%cd%\extensions\PBRExtensions.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\GoDStructData.swift" "%cd%\Objects\struct parsing\GoDStructData.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRScriptClass.swift" "%cd%\Revolution Tool CL\objects\PBRScriptClass.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBREffectivenessValues.swift" "%cd%\Revolution Tool CL\enums\PBREffectivenessValues.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRFileTypes.swift" "%cd%\Revolution Tool CL\enums\PBRFileTypes.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGString.swift" "%cd%\Objects\data types\XGString.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRAbilities.swift" "%cd%\Revolution Tool CL\enums\PBRAbilities.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGExpRate.swift" "%cd%\enums\XGExpRate.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRStringManager.swift" "%cd%\Revolution Tool CL\structs\PBRStringManager.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRExpr.swift" "%cd%\Revolution Tool CL\enums\PBRExpr.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGASM.swift" "%cd%\enums\XGASM.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGTextureBlock.swift" "%cd%\Objects\textures\XGTextureBlock.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\GoDShellManager.swift" "%cd%\Objects\managers\GoDShellManager.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRPatcher.swift" "%cd%\Revolution Tool CL\objects\PBRPatcher.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\GoDTextureFormats.swift" "%cd%\enums\GoDTextureFormats.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRPokemon.swift" "%cd%\Revolution Tool CL\enums\PBRPokemon.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\GoDStruct.swift" "%cd%\Objects\struct parsing\GoDStruct.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGAssemblyCodeExtensions.swift" "%cd%\Objects\file formats\XGAssemblyCodeExtensions.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGGeneralExtensions.swift" "%cd%\extensions\XGGeneralExtensions.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\DummyThreadManager.swift" "%cd%\Objects\managers\DummyThreadManager.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGGSWTextures.swift" "%cd%\Objects\file formats\XGGSWTextures.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGEggGroups.swift" "%cd%\enums\XGEggGroups.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRSpecialStringCharacters.swift" "%cd%\Revolution Tool CL\enums\PBRSpecialStringCharacters.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRMoves.swift" "%cd%\Revolution Tool CL\enums\PBRMoves.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGShinyValues.swift" "%cd%\enums\XGShinyValues.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGWeather.swift" "%cd%\enums\XGWeather.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRScriptCompiler.swift" "%cd%\Revolution Tool CL\objects\PBRScriptCompiler.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGEvolutionConditionType.swift" "%cd%\enums\XGEvolutionConditionType.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\DeckStructTable.swift" "%cd%\Revolution Tool CL\structs\DeckStructTable.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGLZSS.swift" "%cd%\Objects\file formats\XGLZSS.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBREvolutionMethods.swift" "%cd%\Revolution Tool CL\enums\PBREvolutionMethods.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\MoveStatsTable.swift" "%cd%\Revolution Tool CL\structs\MoveStatsTable.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGBattleStyles.swift" "%cd%\enums\XGBattleStyles.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGLevelUpMove.swift" "%cd%\Objects\data types\XGLevelUpMove.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\GoDTextureImporter.swift" "%cd%\Objects\textures\GoDTextureImporter.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PokemonStatsTable.swift" "%cd%\Revolution Tool CL\structs\PokemonStatsTable.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGTexturePalette.swift" "%cd%\Objects\textures\XGTexturePalette.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XDSConstant.swift" "%cd%\Objects\scripts\XD\XDSConstant.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGContestCategories.swift" "%cd%\enums\XGContestCategories.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\EnumerableDocumentable.swift" "%cd%\Objects\protocols\EnumerableDocumentable.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGSettings.swift" "%cd%\Objects\managers\XGSettings.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGISO.swift" "%cd%\Objects\file formats\XGISO.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\GoDImageExtensions.swift" "%cd%\extensions\GoDImageExtensions.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRMoveTargets.swift" "%cd%\Revolution Tool CL\enums\PBRMoveTargets.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRItem.swift" "%cd%\Revolution Tool CL\objects\PBRItem.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGGenderRatios.swift" "%cd%\enums\XGGenderRatios.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRStringTable.swift" "%cd%\Revolution Tool CL\objects\PBRStringTable.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRTextureContainingFormats.swift" "%cd%\Revolution Tool CL\objects\PBRTextureContainingFormats.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRTrainerPokemon.swift" "%cd%\Revolution Tool CL\objects\PBRTrainerPokemon.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\GoDTexture.swift" "%cd%\Objects\textures\GoDTexture.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\StructTablesList.swift" "%cd%\Revolution Tool CL\structs\StructTablesList.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGAssemblyCode.swift" "%cd%\Objects\file formats\XGAssemblyCode.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRScriptClassData.swift" "%cd%\Revolution Tool CL\objects\PBRScriptClassData.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRItems.swift" "%cd%\Revolution Tool CL\enums\PBRItems.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGDeoxysFormes.swift" "%cd%\enums\XGDeoxysFormes.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\GoDTexturesContaining.swift" "%cd%\Objects\file formats\GoDTexturesContaining.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGImage.swift" "%cd%\Objects\textures\XGImage.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\GoDStructTable.swift" "%cd%\Objects\struct parsing\GoDStructTable.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGColour.swift" "%cd%\Objects\textures\XGColour.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGStack.swift" "%cd%\Objects\helper data types\XGStack.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGScriptOps.swift" "%cd%\Objects\scripts\XD\XGScriptOps.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRMoveEffectTypes.swift" "%cd%\Revolution Tool CL\enums\PBRMoveEffectTypes.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGMutableData.swift" "%cd%\Objects\helper data types\XGMutableData.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\PBRScript.swift" "%cd%\Revolution Tool CL\objects\PBRScript.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\GoDDataTable.swift" "%cd%\Objects\helper data types\GoDDataTable.swift" > NUL
mklink "spm\virt\PBR-CLI\Sources\XGPNGBlock.swift" "%cd%\Objects\textures\XGPNGBlock.swift" > NUL
