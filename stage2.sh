#!/bin/bash
set -eux

gcs='git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules'

workdir=$(pwd)

export PYTHONPYCACHEPREFIX="$workdir"/pycache

ls -lahF

mkdir -p "$workdir"/ComfyUI_Windows_portable

# ComfyUI main app
git clone https://github.com/comfyanonymous/ComfyUI.git \
    "$workdir"/ComfyUI_Windows_portable/ComfyUI

# TAESD model for image on-the-fly preview
cd "$workdir"
$gcs https://github.com/madebyollin/taesd.git
cp taesd/*_decoder.pth \
    "$workdir"/ComfyUI_Windows_portable/ComfyUI/models/vae_approx/
rm -rf taesd

# CUSTOM NODES
cd "$workdir"/ComfyUI_Windows_portable/ComfyUI/custom_nodes
$gcs https://github.com/ltdrdata/ComfyUI-Manager.git

# Workspace
$gcs https://github.com/AIGODLIKE/AIGODLIKE-ComfyUI-Translation.git
$gcs https://github.com/crystian/ComfyUI-Crystools.git
$gcs https://github.com/crystian/ComfyUI-Crystools-save.git

# General
$gcs https://github.com/bash-j/mikey_nodes.git
$gcs https://github.com/chrisgoringe/cg-use-everywhere.git
$gcs https://github.com/cubiq/ComfyUI_essentials.git
$gcs https://github.com/Derfuu/Derfuu_ComfyUI_ModdedNodes.git
$gcs https://github.com/jags111/efficiency-nodes-comfyui.git
$gcs https://github.com/kijai/ComfyUI-KJNodes.git
$gcs https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git
$gcs https://github.com/rgthree/rgthree-comfy.git
$gcs https://github.com/shiimizu/ComfyUI_smZNodes.git
$gcs https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes.git

# Control
$gcs https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
$gcs https://github.com/Fannovel16/comfyui_controlnet_aux.git
$gcs https://github.com/florestefano1975/comfyui-portrait-master.git
$gcs https://github.com/huchenlei/ComfyUI-layerdiffuse.git
$gcs https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git
$gcs https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git
$gcs https://github.com/mcmonkeyprojects/sd-dynamic-thresholding.git
$gcs https://github.com/storyicon/comfyui_segment_anything.git
$gcs https://github.com/twri/sdxl_prompt_styler.git

# Video
$gcs https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git
$gcs https://github.com/FizzleDorf/ComfyUI_FizzNodes.git
$gcs https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git

# More
$gcs https://github.com/pythongosssss/ComfyUI-WD14-Tagger.git
$gcs https://github.com/SLAPaper/ComfyUI-Image-Selector.git
$gcs https://github.com/ssitu/ComfyUI_UltimateSDUpscale.git


cd "$workdir"
mv  python_embeded  ComfyUI_Windows_portable/python_embeded

cd "$workdir"/ComfyUI_Windows_portable
mkdir update
cp -r ComfyUI/.ci/update_windows/* ./update/
cp -r ComfyUI/.ci/windows_base_files/* ./

# Replace start script file
rm "$workdir"/ComfyUI_Windows_portable/run_nvidia_gpu.bat
cp "$workdir"/attachments/run_nvidia_gpu.bat \
    "$workdir"/ComfyUI_Windows_portable/run_nvidia_gpu.bat

du -hd1 "$workdir"

# Download Impact-Pack & Subpack & models
cd "$workdir"/ComfyUI_Windows_portable/ComfyUI/custom_nodes
$gcs https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
cd ComfyUI-Impact-Pack
$gcs https://github.com/ltdrdata/ComfyUI-Impact-Subpack.git impact_subpack
# Use its installer to download models
"$workdir"/ComfyUI_Windows_portable/python_embeded/python.exe -s -B install.py

# Run test, also let custom nodes download some models
cd "$workdir"/ComfyUI_Windows_portable
./python_embeded/python.exe -s -B ComfyUI/main.py --quick-test-for-ci --cpu

# Clean up
rm "$workdir"/ComfyUI_Windows_portable/*.log
# DO NOT clean pymatting cache, they are nbi/nbc files for Numba, and won't be regenerated.
#rm -rf "$workdir"/ComfyUI_Windows_portable/python_embeded/Lib/site-packages/pymatting

cd "$workdir"/ComfyUI_Windows_portable/ComfyUI/custom_nodes
rm ./ComfyUI-Manager/config.ini
rm ./ComfyUI-Impact-Pack/impact-pack.ini
rm ./ComfyUI-Custom-Scripts/pysssss.json

cd "$workdir"

ls -lahF
