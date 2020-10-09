echo "Building 1.43 (release version)..."

echo "::group::Prepare for compilation"
echo "Preparing..."

echo "Removing temporary files..."
bash modules/clean.sh
echo "Copying translations and other required files..."
bash modules/copy-base.sh

echo "Creating compile config file..."
VERSION_NUM="$(cat ../version.txt)"
BUILD_DATE=$(date +'%Y%m%d%H%M%S')
echo ::set-output name=BUILD_DATE::"$(date +%Y%m%d)"
echo ::set-output name=BUILD_DATE_FULL::"$(date +'%Y/%m/%d %H:%M:%S')"
echo ::set-output name=VERSION_NUM::"$(cat version.txt)"
cat >temp/compile-config.json <<EOL
{
	"resourceVersion": "1,43,$VERSION_NUM,0",
	"fullVersion": "1.43-en.$VERSION_NUM-dev.$BUILD_DATE",
	"buildVersion": "$VERSION_NUM",
	"executableName": "Domino.exe",
	"compilePath": "temp/_compile",
	"supplyTranslationReadme": "true"
}
EOL

echo "Preparation done!"
echo "::endgroup::"

echo "::group::Compilation"
echo "Compiling..."
bash compile-2.sh temp/compile-config.json
echo "Compile done!"
echo "::endgroup::"

echo "::group::Pack distributable"
echo "Packing distributable..."
mkdir dist
cd temp/_compile/
7z a ../../dist/Domino143_Translated.zip *
cd ../../
mv -v temp/_compile/Domino.exe dist/Domino143_Translated.exe
echo "Packing done!"
echo "::endgroup::"

echo "Building done!"