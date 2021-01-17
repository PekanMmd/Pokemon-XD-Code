echo "Copying Assets..."
mkdir -p out/Assets/XD/wiimm
mkdir -p out/Assets/Colosseum/wiimm
mkdir -p out/Assets/PBR/wiimm

cp .build/debug/Colosseum-CLI out/
cp .build/debug/GoD-CLI out/
cp .build/debug/PBR-CLI out/


# GoD Assets
cp "$PWD/JSON/XD/Move Categories.json" out/Assets/XD/
cp "$PWD/JSON/XD/Move Effects.json" out/Assets/XD/
cp "$PWD/JSON/XD/Original Pokemon.json" out/Assets/XD/
cp "$PWD/JSON/XD/Moves raw.json" out/Assets/XD/
cp "$PWD/JSON/XD/Pokemon Stats raw.json" out/Assets/XD/
cp "$PWD/JSON/XD/Room IDs.json" out/Assets/XD/
cp "$PWD/JSON/XD/Original Moves.json" out/Assets/XD/
cp "$PWD/JSON/XD/Items.json" out/Assets/XD/

# Colo Assets
cp "$PWD/JSON/XD/Moves raw.json" out/Assets/Colosseum/
cp "$PWD/JSON/XD/Pokemon Stats raw.json" out/Assets/Colosseum/
cp "$PWD/JSON/Colosseum/Original Moves.json" out/Assets/Colosseum/
cp "$PWD/JSON/XD/Original Pokemon.json" out/Assets/Colosseum/
cp "$PWD/JSON/XD/Items.json" out/Assets/Colosseum/
cp "$PWD/JSON/Colosseum/Move Effects.json" out/Assets/Colosseum/
cp "$PWD/JSON/Colosseum/Room IDs.json" out/Assets/Colosseum/
cp "$PWD/JSON/Colosseum/Move Categories.json" out/Assets/Colosseum/

# PBR Assets
cp "$PWD/JSON/PBR/Original Moves.json" out/Assets/PBR/
cp "$PWD/JSON/PBR/Original Items.json" out/Assets/PBR/
cp "$PWD/JSON/PBR/Original Pokemon.json" out/Assets/PBR/
cp "$PWD/JSON/PBR/Move Effects.json" out/Assets/PBR/
cp tools/OSX/wiimm/* out/Assets/PBR/wiimm
cp tools/OSX/other/* out/Assets/PBR
