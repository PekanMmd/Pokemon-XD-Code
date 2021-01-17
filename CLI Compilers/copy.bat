echo "Copying Assets..."
setlocal enableextensions

md out\Assets\XD\wiimm
md out\Assets\Colosseum\wiimm
md out\Assets\PBR\wiimm

endlocal


REM GoD Assets
copy "%cd%\JSON\XD\Move Categories.json" "out\Assets\XD\Move Categories.json"
copy "%cd%\JSON\XD\Move Effects.json" "out\Assets\XD\Move Effects.json"
copy "%cd%\JSON\XD\Original Pokemon.json" "out\Assets\XD\Original Pokemon.json"
copy "%cd%\JSON\XD\Moves raw.json" "out\Assets\XD\Moves raw.json"
copy "%cd%\JSON\XD\Pokemon Stats raw.json" "out\Assets\XD\Pokemon Stats raw.json"
copy "%cd%\JSON\XD\Room IDs.json" "out\Assets\XD\Room IDs.json"
copy "%cd%\JSON\XD\Original Moves.json" "out\Assets\XD\Original Moves.json"
copy "%cd%\JSON\XD\Items.json" "out\Assets\XD\Items.json"

REM Colo Assets
copy "%cd%\JSON\XD\Moves raw.json" "out\Assets\Colosseum\Moves raw.json"
copy "%cd%\JSON\XD\Pokemon Stats raw.json" "out\Assets\Colosseum\Pokemon Stats raw.json"
copy "%cd%\JSON\Colosseum\Original Moves.json" "out\Assets\Colosseum\Original Moves.json"
copy "%cd%\JSON\XD\Original Pokemon.json" "out\Assets\Colosseum\Original Pokemon.json"
copy "%cd%\JSON\XD\Items.json" "out\Assets\Colosseum\Items.json"
copy "%cd%\JSON\Colosseum\Move Effects.json" "out\Assets\Colosseum\Move Effects.json"
copy "%cd%\JSON\Colosseum\Room IDs.json" "out\Assets\Colosseum\Room IDs.json"
copy "%cd%\JSON\Colosseum\Move Categories.json" "out\Assets\Colosseum\Move Categories.json"

REM PBR Assets
copy "%cd%\JSON\PBR\Original Moves.json" "out\Assets\PBR\Original Moves.json"
copy "%cd%\JSON\PBR\Original Items.json" "out\Assets\PBR\Original Items.json"
copy "%cd%\JSON\PBR\Original Pokemon.json" "out\Assets\PBR\Original Pokemon.json"
copy "%cd%\JSON\PBR\Move Effects.json" "out\Assets\PBR\Move Effects.json"
copy tools\Windows\wiimm\* out\Assets\PBR\wiimm
copy tools\Windows\other\* out\Assets\PBR
