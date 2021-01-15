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
preamble = f"""set -x
# Link Source
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
lines = [preamble]

for source in GoDSources:
    line = f'ln -s "$PWD/{source}" spm/virt/{GoDCLITargetName}/Sources/'
    lines.append(line)

for source in ColoSources:
    line = f'ln -s "$PWD/{source}" spm/virt/{ColoCLITargetName}/Sources/'
    lines.append(line)

for source in PBRSources:
    line = f'ln -s "$PWD/{source}" spm/virt/{PBRCLITargetName}/Sources/'
    lines.append(line)

script = open("CLI Compilers/link.sh", 'w')
script.write("\n".join(lines))
script.close()

# TODO: add Windows batch script
# TODO: add asset copying

# import code
# code.interact(local=dict(globals(), **locals()))
