from pbxproj import XcodeProject
import sys, os
import stat

# Target names
GoDCLITargetName = "GoD-CLI"
GoDGUITargetName = "GoD Tool"
ColoCLITargetName = "Colosseum-CLI"
ColoGUITargetName = "Colosseum Tool"
PBRCLITargetName = "PBR-CLI"
PBRGUITargetName = "PBR Tool"

# exclude files
ignoredFiles = ["OSXExtensions.swift", "WindowsExtensions.swift"]
resourceFileTypes = [".json", ".sublime"] # .png excluded until there is a use for it

# Get path to project files
scriptpath = os.path.dirname(os.path.realpath(__file__))
dirpath = os.path.realpath(os.path.join(scriptpath, "..", ".."))
projpath = os.path.join(dirpath, "GoD Tool.xcodeproj", "project.pbxproj")

# open Xcode project
project = XcodeProject.load(projpath)
groups = project.objects.get_objects_in_section('PBXGroup')

# helper functions
def getFilePath(file):
    ref = project.get_object(file).fileRef 
    child_group = next(filter(lambda group: ref in group.children, groups))
    parent_group = [g for g in groups if child_group.get_id() in g.children]
    child_path = child_group.path if 'path' in child_group else ''
    parent_path = parent_group[0].path if len(parent_group) and 'path' in parent_group[0] else ''
    if parent_path != '' and not os.path.isdir(parent_path):
        parent_path = ''
    if parent_path in child_path:
        parent_path = ''
    return os.path.join(parent_path, child_path, ref._get_comment()) # add for abs: dirpath, 

def getBuildPhase(buildPhases, name):
    phaseId = next(filter(lambda phase: phase._get_comment() == name, buildPhases))
    return project.get_object(phaseId)

def getFiles(target, phase):
    buildPhase = getBuildPhase(target.buildPhases, phase)
    allFiles = map(getFilePath, buildPhase.files)
    if phase == "Sources":
        files = [path for path in allFiles if os.path.basename(path) not in ignoredFiles]
    else:
        files = [path for path in allFiles if os.path.splitext(path)[-1] in resourceFileTypes]
    return files

# get project targets
GoDTarget = project.get_target_by_name(GoDCLITargetName)
GoDAssetTarget = project.get_target_by_name(GoDGUITargetName)
ColoTarget = project.get_target_by_name(ColoCLITargetName)
ColoAssetTarget = project.get_target_by_name(ColoGUITargetName)
PBRTarget = project.get_target_by_name(PBRCLITargetName)
PBRAssetTarget = project.get_target_by_name(PBRGUITargetName)

# Read XD Source files
GoDSources = getFiles(GoDTarget, "Sources")
# Read Colosseum Source files
ColoSources = getFiles(ColoTarget, "Sources")
# Read PBR Source files
PBRSources = getFiles(PBRTarget, "Sources")

# Read XD Assets
GoDAssets = getFiles(GoDAssetTarget, "Resources")
# Read Colosseum Assets
ColoAssets = getFiles(ColoAssetTarget, "Resources")
# Read PBR Assets
PBRAssets = getFiles(PBRAssetTarget, "Resources")

# Generate symlink scripts Unix (Linux + Darwin)
unix_link_preamble = f"""
rm -rf spm/virt/{GoDCLITargetName}/Sources
mkdir -p spm/virt/{GoDCLITargetName}/Sources

rm -rf spm/virt/{ColoCLITargetName}/Sources
mkdir -p spm/virt/{ColoCLITargetName}/Sources

rm -rf spm/virt/{PBRCLITargetName}/Sources
mkdir -p spm/virt/{PBRCLITargetName}/Sources

case "$(uname -s)" in
   Darwin)
     ln -s "$PWD/extensions/OSXExtensions.swift" spm/virt/{GoDCLITargetName}/Sources/
     ln -s "$PWD/extensions/OSXExtensions.swift" spm/virt/{ColoCLITargetName}/Sources/
     ln -s "$PWD/extensions/OSXExtensions.swift" spm/virt/{PBRCLITargetName}/Sources/
     ;;

   Linux)
     ln -s "$PWD/extensions/LinuxExtensions.swift" spm/virt/{GoDCLITargetName}/Sources/
     ln -s "$PWD/extensions/LinuxExtensions.swift" spm/virt/{ColoCLITargetName}/Sources/
     ln -s "$PWD/extensions/LinuxExtensions.swift" spm/virt/{PBRCLITargetName}/Sources/
     ;;
esac
"""
unix_link_lines = [unix_link_preamble]

win_link_preamble = f"""
setlocal enableextensions

rmdir /s /q spm\\virt\\{GoDCLITargetName}\\Sources
md spm\\virt\\{GoDCLITargetName}\\Sources

rmdir /s /q spm\\virt\\{ColoCLITargetName}\\Sources
md spm\\virt\\{ColoCLITargetName}\\Sources

rmdir /s /q spm\\virt\\{PBRCLITargetName}\\Sources
md spm\\virt\\{PBRCLITargetName}\\Sources

endlocal

mklink spm\\virt\\{GoDCLITargetName}\\Sources\\WindowsExtensions.swift "%cd%\\extensions\\WindowsExtensions.swift"
mklink spm\\virt\\{ColoCLITargetName}\\Sources\\WindowsExtensions.swift "%cd%\\extensions\\WindowsExtensions.swift"
mklink spm\\virt\\{PBRCLITargetName}\\Sources\\WindowsExtensions.swift "%cd%\\extensions\\WindowsExtensions.swift"
"""
win_link_lines = [win_link_preamble]

unix_link_lines.append("\n# GoD Sources")
win_link_lines.append("\nREM GoD Sources")
for source in GoDSources:
    unix_line = f'ln -s "$PWD/{source}" spm/virt/{GoDCLITargetName}/Sources/'
    unix_link_lines.append(unix_line)

    fixed = source.replace('/', '\\')
    win_line = f'mklink "spm\\virt\\{GoDCLITargetName}\\Sources\\{os.path.basename(source)}" "%cd%\\{fixed}" > NUL'
    win_link_lines.append(win_line)

unix_link_lines.append("\n# Colo Sources")
win_link_lines.append("\nREM Colo Sources")
for source in ColoSources:
    line = f'ln -s "$PWD/{source}" spm/virt/{ColoCLITargetName}/Sources/'
    unix_link_lines.append(line)

    fixed = source.replace('/', '\\')
    win_line = f'mklink "spm\\virt\\{ColoCLITargetName}\\Sources\\{os.path.basename(source)}" "%cd%\\{fixed}" > NUL'
    win_link_lines.append(win_line)

unix_link_lines.append("\n# PBR Sources")
win_link_lines.append("\nREM PBR Sources")
for source in PBRSources:
    unix_line = f'ln -s "$PWD/{source}" spm/virt/{PBRCLITargetName}/Sources/'
    unix_link_lines.append(unix_line)

    fixed = source.replace('/', '\\')
    win_line = f'mklink "spm\\virt\\{PBRCLITargetName}\\Sources\\{os.path.basename(source)}" "%cd%\\{fixed}" > NUL'
    win_link_lines.append(win_line)

unix_link_file = "CLI Compilers/link.sh"
unix_link_script = open(unix_link_file, 'w')
unix_link_script.write("\n".join(unix_link_lines)[1:]+"\n")
unix_link_script.close()
os.chmod(unix_link_file, os.stat(unix_link_file).st_mode | stat.S_IEXEC)

win_link_script = open("CLI Compilers/link.bat", 'w')
win_link_script.write("\n".join(win_link_lines)[1:]+"\n")
win_link_script.close()

# Asset copying

GoDAssetsSubFolder = "out/Assets"
ColoAssetsSubFolder = "out/Assets"
PBRAssetsSubFolder = "out/Assets"
GoDAssetsFolder = GoDAssetsSubFolder + "/XD"
ColoAssetsFolder = ColoAssetsSubFolder + "/Colosseum"
PBRAssetsFolder = PBRAssetsSubFolder + "/PBR"
GoDWiimmsAssetsFolder = GoDAssetsFolder + "/wiimm"
ColoWiimmsAssetsFolder = ColoAssetsFolder + "/wiimm"
PBRWiimmsAssetsFolder = PBRAssetsFolder + "/wiimm"


unix_copy_preamble = f"""
echo "Copying Assets..."
mkdir -p {GoDWiimmsAssetsFolder}
mkdir -p {ColoWiimmsAssetsFolder}
mkdir -p {PBRWiimmsAssetsFolder}

cp .build/debug/Colosseum-CLI out/
cp .build/debug/GoD-CLI out/
cp .build/debug/PBR-CLI out/
"""
unix_copy_lines = [unix_copy_preamble]


win_GoDWiimmsAssetsFolder = GoDWiimmsAssetsFolder.replace('/', '\\')
win_ColoWiimmsAssetsFolder = ColoWiimmsAssetsFolder.replace('/', '\\')
win_PBRWiimmsAssetsFolder = PBRWiimmsAssetsFolder.replace('/', '\\')
win_copy_preamble = f"""
echo "Copying Assets..."
setlocal enableextensions

md {win_GoDWiimmsAssetsFolder}
md {win_ColoWiimmsAssetsFolder}
md {win_PBRWiimmsAssetsFolder}

endlocal

copy .build\debug\Colosseum-CLI.exe out
copy .build\debug\GoD-CLI.exe out
copy .build\debug\PBR-CLI.exe out

"""
win_copy_lines = [win_copy_preamble]

unix_copy_lines.append("\n# GoD Assets")
win_copy_lines.append("\nREM GoD Assets")
win_copy_dest = GoDAssetsFolder.replace('/', '\\')
for asset in GoDAssets:
    unix_line = f'cp "$PWD/{asset}" {GoDAssetsFolder}/'
    unix_copy_lines.append(unix_line)

    fixed = asset.replace('/', '\\')
    win_line = f'copy "%cd%\\{fixed}" "{win_copy_dest}\\{os.path.basename(asset)}"'
    win_copy_lines.append(win_line)

unix_copy_lines.append("\n# Colo Assets")
win_copy_lines.append("\nREM Colo Assets")
win_copy_dest = ColoAssetsFolder.replace('/', '\\')
for asset in ColoAssets:
    unix_line = f'cp "$PWD/{asset}" {ColoAssetsFolder}/'
    unix_copy_lines.append(unix_line)

    fixed = asset.replace('/', '\\')
    win_line = f'copy "%cd%\\{fixed}" "{win_copy_dest}\\{os.path.basename(asset)}"'
    win_copy_lines.append(win_line)

unix_copy_lines.append("\n# PBR Assets")
win_copy_lines.append("\nREM PBR Assets")
win_copy_dest = PBRAssetsFolder.replace('/', '\\')
for asset in PBRAssets:
    unix_line = f'cp "$PWD/{asset}" {PBRAssetsFolder}/'
    unix_copy_lines.append(unix_line)

    fixed = asset.replace('/', '\\')
    win_line = f'copy "%cd%\\{fixed}" "{win_copy_dest}\\{os.path.basename(asset)}"'
    win_copy_lines.append(win_line)

unix_copy_lines.append("cp tools/OSX/wiimm/* " + PBRWiimmsAssetsFolder)
unix_copy_lines.append("cp tools/OSX/other/* " + PBRAssetsFolder)

win_copy_lines.append("copy tools\\Windows\\wiimm\\* " + PBRWiimmsAssetsFolder.replace('/', '\\'))
win_copy_lines.append("copy tools\\Windows\\other\\* " + PBRAssetsFolder.replace('/', '\\'))

unix_copy_file = "CLI Compilers/copy.sh"
unix_copy_script = open(unix_copy_file, 'w')
unix_copy_script.write("\n".join(unix_copy_lines)[1:]+"\n")
unix_copy_script.close()
os.chmod(unix_copy_file, os.stat(unix_copy_file).st_mode | stat.S_IEXEC)

win_copy_script = open("CLI Compilers/copy.bat", 'w')
win_copy_script.write("\n".join(win_copy_lines)[1:]+"\n")
win_copy_script.close()
