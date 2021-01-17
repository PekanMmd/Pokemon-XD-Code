from pbxproj import XcodeProject
import sys, os

# Target names
GoDCLITargetName = "GoD-CLI"
GoDGUITargetName = "GoD Tool"
ColoCLITargetName = "Colosseum-CLI"
ColoGUITargetName = "Colosseum Tool"
PBRCLITargetName = "PBR-CLI"
PBRGUITargetName = "PBR Tool"

# exclude files
ignoredFiles = ["OSXExtensions.swift", "WindowsExtensions.swift"]
resourceFileTypes = [".png", ".json", ".sublime"]

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
unix_preamble = f"""
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
unix_lines = [unix_preamble]

win_preamble = f"""
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
win_lines = [win_preamble]

unix_lines.append("\n# GoD Sources")
for source in GoDSources:
    unix_line = f'ln -s "$PWD/{source}" spm/virt/{GoDCLITargetName}/Sources/'
    unix_lines.append(unix_line)

    fixed = source.replace('/', '\\')
    win_line = f'mklink "spm\\virt\\{GoDCLITargetName}\\Sources\\{os.path.basename(source)}" "%cd%\\{fixed}" > NUL'
    win_lines.append(win_line)

unix_lines.append("\n# Colo Sources")
for source in ColoSources:
    line = f'ln -s "$PWD/{source}" spm/virt/{ColoCLITargetName}/Sources/'
    unix_lines.append(line)

    fixed = source.replace('/', '\\')
    win_line = f'mklink "spm\\virt\\{ColoCLITargetName}\\Sources\\{os.path.basename(source)}" "%cd%\\{fixed}" > NUL'
    win_lines.append(win_line)

unix_lines.append("\n# PBR Sources")
for source in PBRSources:
    line = f'ln -s "$PWD/{source}" spm/virt/{PBRCLITargetName}/Sources/'
    unix_lines.append(line)

    fixed = source.replace('/', '\\')
    win_line = f'mklink "spm\\virt\\{PBRCLITargetName}\\Sources\\{os.path.basename(source)}" "%cd%\\{fixed}" > NUL'
    win_lines.append(win_line)

unix_script = open("CLI Compilers/link.sh", 'w')
unix_script.write("\n".join(unix_lines)[1:])
unix_script.close()

win_script = open("CLI Compilers/link.bat", 'w')
win_script.write("\n".join(win_lines)[1:])
win_script.close()

# TODO: add asset copying

# import code
# code.interact(local=dict(globals(), **locals()))
