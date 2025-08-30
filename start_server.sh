#!/usr/bin/env bash
set -euo pipefail

# cwagecraft Dedicated Server Startup Script
# This script sets up and runs a headless Minecraft server with the cwagecraft modpack

PACK_NAME="cwagecraft"
MC_VERSION="1.20.1"
FORGE_VERSION="47.3.22"
SERVER_DIR="server"
SERVER_JAR="forge-${MC_VERSION}-${FORGE_VERSION}.jar"
FORGE_INSTALLER="forge-${MC_VERSION}-${FORGE_VERSION}-installer.jar"
FORGE_DOWNLOAD_URL="https://maven.minecraftforge.net/net/minecraftforge/forge/${MC_VERSION}-${FORGE_VERSION}/forge-${MC_VERSION}-${FORGE_VERSION}-installer.jar"

# JVM arguments optimized for server operation
JVM_ARGS="-Xms4G -Xmx8G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check Java
    if ! command -v java &> /dev/null; then
        log_error "Java is not installed. Please install Java 17 or later:"
        log_error "  sudo apt update && sudo apt install openjdk-17-jre-headless"
        exit 1
    fi
    
    # Check Java version
    java_version=$(java -version 2>&1 | head -n1 | cut -d'"' -f2 | cut -d'.' -f1)
    if [[ "$java_version" -lt 17 ]]; then
        log_error "Java 17 or later is required. Current version: $java_version"
        log_error "Please upgrade Java: sudo apt install openjdk-17-jre-headless"
        exit 1
    fi
    
    log_success "Java $java_version found"
    
    # Check if packwiz is available (for mod export)
    if ! command -v packwiz &> /dev/null; then
        log_error "packwiz is not installed. Please install it first:"
        log_error "  go install github.com/packwiz/packwiz@latest"
        exit 1
    fi
    
    log_success "packwiz found"
}

# Download Forge installer if needed
download_forge_installer() {
    log_info "Checking Forge installer..."
    
    if [[ ! -f "$SERVER_DIR/$FORGE_INSTALLER" ]]; then
        log_info "Downloading Forge installer..."
        mkdir -p "$SERVER_DIR"
        
        # Try downloading with retries and better error handling
        download_success=false
        for attempt in 1 2 3; do
            if curl -L --fail --connect-timeout 30 --max-time 120 -o "$SERVER_DIR/$FORGE_INSTALLER" "$FORGE_DOWNLOAD_URL"; then
                download_success=true
                break
            else
                if [[ $attempt -lt 3 ]]; then
                    log_warning "Download failed, retrying in 3s... (attempt $attempt/3)"
                    sleep 3
                else
                    log_error "Failed to download Forge installer after 3 attempts"
                    log_error "Please manually download the installer:"
                    log_error "  URL: $FORGE_DOWNLOAD_URL"
                    log_error "  Save as: $SERVER_DIR/$FORGE_INSTALLER"
                    log_error "Then run this script again."
                fi
            fi
        done
        
        if [[ "$download_success" != "true" ]]; then
            exit 1
        fi
        
        log_success "Forge installer downloaded"
    else
        log_success "Forge installer already exists"
    fi
}

# Install Forge server
install_forge_server() {
    log_info "Installing Forge server..."
    
    cd "$SERVER_DIR"
    
    if [[ ! -f "$SERVER_JAR" ]]; then
        log_info "Running Forge installer..."
        
        if ! java -jar "$FORGE_INSTALLER" --installServer; then
            log_error "Failed to install Forge server"
            exit 1
        fi
        
        log_success "Forge server installed"
    else
        log_success "Forge server already installed"
    fi
    
    cd ..
}

# Export modpack and extract server mods
setup_mods() {
    log_info "Setting up server mods..."
    
    # Create server mods directory
    mkdir -p "$SERVER_DIR/mods"
    
    # Download server-compatible mods directly from packwiz configuration
    log_info "Downloading server-compatible mods..."
    
    mod_count=0
    failed_count=0
    client_excluded=0
    
    if [[ -d "$PACK_NAME/mods" ]]; then
        for mod_toml in "$PACK_NAME/mods"/*.pw.toml; do
            if [[ -f "$mod_toml" ]]; then
                mod_name=$(grep "name = " "$mod_toml" | cut -d'"' -f2)
                side=$(grep "side = " "$mod_toml" | cut -d'"' -f2)
                
                # Check if mod is server-compatible
                if [[ "$side" == "both" || "$side" == "server" ]]; then
                    # Extract download URL and filename
                    url=$(grep "url = " "$mod_toml" | cut -d'"' -f2)
                    filename=$(grep "filename = " "$mod_toml" | cut -d'"' -f2)
                    
                    if [[ -n "$url" && -n "$filename" ]]; then
                        if [[ ! -f "$SERVER_DIR/mods/$filename" ]]; then
                            log_info "Downloading: $mod_name"
                            
                            # Try downloading with retries
                            download_success=false
                            for attempt in 1 2 3; do
                                if curl -L --fail --connect-timeout 30 --max-time 120 -o "$SERVER_DIR/mods/$filename" "$url"; then
                                    download_success=true
                                    break
                                else
                                    if [[ $attempt -lt 3 ]]; then
                                        log_warning "Download failed, retrying in 2s... (attempt $attempt/3)"
                                        sleep 2
                                    fi
                                fi
                            done
                            
                            if [[ "$download_success" == "true" ]]; then
                                ((mod_count++))
                            else
                                log_warning "Failed to download $mod_name after 3 attempts"
                                ((failed_count++))
                            fi
                        else
                            log_info "Already exists: $mod_name"
                            ((mod_count++))
                        fi
                    fi
                elif [[ "$side" == "client" ]]; then
                    log_info "Excluding client-only mod: $mod_name"
                    ((client_excluded++))
                fi
            fi
        done
    fi
    
    log_success "Server mods setup complete!"
    log_info "  Downloaded/verified: $mod_count mods"
    log_info "  Client-only excluded: $client_excluded mods"
    if [[ $failed_count -gt 0 ]]; then
        log_warning "  Failed downloads: $failed_count mods"
    fi
}

# Copy server configurations
setup_configs() {
    log_info "Setting up server configurations..."
    
    # Copy config files if they exist
    if [[ -d "$PACK_NAME/config" ]]; then
        cp -r "$PACK_NAME/config" "$SERVER_DIR/"
        log_success "Config files copied"
    fi
    
    # Copy defaultconfigs if they exist
    if [[ -d "$PACK_NAME/defaultconfigs" ]]; then
        cp -r "$PACK_NAME/defaultconfigs" "$SERVER_DIR/"
        log_success "Default config files copied"
    fi
}

# Configure server properties
configure_server() {
    log_info "Configuring server properties..."
    
    # Accept EULA
    cat > "$SERVER_DIR/eula.txt" << EOF
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Generated by cwagecraft start_server.sh
eula=true
EOF
    
    # Create server.properties if it doesn't exist
    if [[ ! -f "$SERVER_DIR/server.properties" ]]; then
        cat > "$SERVER_DIR/server.properties" << EOF
#Minecraft server properties
#Generated by cwagecraft start_server.sh
allow-flight=true
allow-nether=true
broadcast-console-to-ops=true
broadcast-rcon-to-ops=true
difficulty=normal
enable-command-block=true
enable-jmx-monitoring=false
enable-rcon=false
enable-status=true
enforce-secure-profile=true
enforce-whitelist=false
entity-broadcast-range-percentage=100
force-gamemode=false
function-permission-level=2
gamemode=survival
generate-structures=true
generator-settings={}
hardcore=false
hide-online-players=false
initial-disabled-packs=
initial-enabled-packs=vanilla
level-name=world
level-seed=
level-type=minecraft\:normal
max-chained-neighbor-updates=1000000
max-players=20
max-tick-time=60000
max-world-size=29999984
motd=cwagecraft server
network-compression-threshold=256
online-mode=true
op-permission-level=4
player-idle-timeout=0
prevent-proxy-connections=false
pvp=true
query.port=25565
rate-limit=0
rcon.password=
rcon.port=25575
require-resource-pack=false
resource-pack=
resource-pack-id=
resource-pack-prompt=
resource-pack-sha1=
server-ip=
server-port=25565
simulation-distance=10
spawn-animals=true
spawn-monsters=true
spawn-npcs=true
spawn-protection=16
sync-chunk-writes=true
text-filtering-config=
use-native-transport=true
view-distance=10
white-list=false
EOF
    fi
    
    log_success "Server configured"
}

# Start the server
start_server() {
    log_info "Starting cwagecraft server..."
    log_info "JVM Args: $JVM_ARGS"
    log_info "Server will start in 3 seconds..."
    sleep 3
    
    cd "$SERVER_DIR"
    
    # Start server with optimized JVM arguments
    exec java $JVM_ARGS -jar "$SERVER_JAR" nogui
}

# Main execution
main() {
    echo "================================================"
    echo "   cwagecraft Dedicated Server Setup & Start"
    echo "   MC $MC_VERSION | Forge $FORGE_VERSION"
    echo "================================================"
    echo
    
    check_prerequisites
    download_forge_installer
    install_forge_server
    setup_mods
    setup_configs
    configure_server
    
    echo
    log_success "Server setup complete!"
    echo
    log_info "Starting server..."
    log_info "Press Ctrl+C to stop the server"
    echo
    
    start_server
}

# Handle script arguments
case "${1:-start}" in
    "setup")
        check_prerequisites
        download_forge_installer
        install_forge_server
        setup_mods
        setup_configs
        configure_server
        log_success "Server setup complete! Run './start_server.sh' to start."
        ;;
    "start"|"")
        main
        ;;
    "clean")
        log_info "Cleaning server directory..."
        rm -rf "$SERVER_DIR"
        rm -f "${PACK_NAME}.mrpack"
        log_success "Server directory cleaned"
        ;;
    "test")
        set +e  # Disable exit on error for this section
        log_info "Testing mod compatibility (dry run)..."
        
        both_count=0
        client_count=0
        server_count=0
        
        echo "Analyzing mods in $PACK_NAME/mods/..."
        
        for mod_toml in "$PACK_NAME/mods"/*.pw.toml; do
            if [[ -f "$mod_toml" ]]; then
                side=$(grep "side = " "$mod_toml" | cut -d'"' -f2 || echo "unknown")
                case "$side" in
                    "both") ((both_count++)) ;;
                    "client") ((client_count++)) ;;
                    "server") ((server_count++)) ;;
                esac
            fi
        done
        
        echo
        log_info "Mod compatibility analysis:"
        echo "  Server-compatible (both): $both_count mods"
        echo "  Client-only (excluded): $client_count mods"
        echo "  Server-only: $server_count mods"
        echo "  Total for server: $((both_count + server_count)) mods"
        
        echo
        log_info "Client-only mods that will be excluded:"
        for mod_toml in "$PACK_NAME/mods"/*.pw.toml; do
            if [[ -f "$mod_toml" ]] && grep -q 'side = "client"' "$mod_toml"; then
                mod_name=$(grep "name = " "$mod_toml" | cut -d'"' -f2 || basename "$mod_toml" .pw.toml)
                echo "  - $mod_name"
            fi
        done
        
        echo
        log_success "Analysis complete"
        set -e  # Re-enable exit on error
        ;;
    *)
        echo "Usage: $0 [setup|start|clean|test]"
        echo "  setup  - Only setup the server, don't start it"
        echo "  start  - Setup (if needed) and start the server (default)"
        echo "  clean  - Remove server directory and exported modpack"
        echo "  test   - Show mod compatibility analysis (dry run)"
        exit 1
        ;;
esac