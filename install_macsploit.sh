main() {
    # Create a directory to install everything
    INSTALL_DIR="$HOME/MacSploit"
    mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR" || exit

    clear
    echo -e "Welcome to the MacSploit Experience!"
    echo -e "Install Script Version 2.3"

    # Removed license check section

    echo -e "Downloading Latest Roblox..."
    [ -f ./RobloxPlayer.zip ] && rm ./RobloxPlayer.zip
    local version=$(curl -s "https://clientsettingscdn.roblox.com/v2/client-version/MacPlayer" | ./jq -r ".clientVersionUpload")
    curl "http://setup.rbxcdn.com/mac/$version-RobloxPlayer.zip" -o "./RobloxPlayer.zip"
    rm ./jq

    echo -n "Installing Latest Roblox... "
    unzip -o -q "./RobloxPlayer.zip"
    rm ./RobloxPlayer.zip
    echo -e "Done."

    echo -e "Downloading MacSploit..."
    curl "https://git.abyssdigital.xyz/main/macsploit.zip" -o "./MacSploit.zip"

    echo -n "Installing MacSploit... "
    unzip -o -q "./MacSploit.zip"
    rm ./MacSploit.zip
    echo -e "Done."

    echo -n "Updating Dylib..."
    if [ "$version" == "version-88b4e5cd14654499" ]; then
        curl -Os "https://git.abyssdigital.xyz/preview/macsploit.dylib"
    else
        curl -Os "https://git.abyssdigital.xyz/main/macsploit.dylib"
    fi
    
    echo -e " Done."
    echo -e "Patching Roblox..."
    mv ./macsploit.dylib "./RobloxPlayer.app/Contents/MacOS/macsploit.dylib"
    mv ./libdiscord-rpc.dylib "./RobloxPlayer.app/Contents/MacOS/libdiscord-rpc.dylib"
    ./insert_dylib "./RobloxPlayer.app/Contents/MacOS/macsploit.dylib" "./RobloxPlayer.app/Contents/MacOS/RobloxPlayer" --strip-codesig --all-yes
    mv "./RobloxPlayer.app/Contents/MacOS/RobloxPlayer_patched" "./RobloxPlayer.app/Contents/MacOS/RobloxPlayer"
    rm -r "./RobloxPlayer.app/Contents/MacOS/RobloxPlayerInstaller.app"
    rm ./insert_dylib

    echo -n "Installing MacSploit App... "
    mv ./MacSploit.app "./RobloxPlayer.app/Contents/MacOS/MacSploit.app"
    echo -e "Done."

    echo -e "Install Complete! Developed by Nexus42!"
    exit
}

main