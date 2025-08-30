# cwagecraft

A comprehensive Minecraft 1.20.1 Forge modpack focused on technology, magic, exploration, and quality of life improvements.

## Features

- **Technology**: Create, Applied Energistics 2, Mekanism, RFTools suite, Thermal series
- **Magic**: Botania, Tinkers' Construct, Draconic Evolution, Mystical Agriculture
- **Exploration**: Biomes O' Plenty, Advanced Mining Dimension, Iron Jetpacks
- **Storage & Automation**: Refined Storage, Industrial Foregoing, Pipez
- **Quality of Life**: JEI, Waystones, Sophisticated Backpacks, FTB suite

## Included Shader Pack

This modpack includes **Complementary Unbound r5.5.1** shader pack by Complementary Development.

- **Website**: https://www.complementary.dev/shaders/
- **License**: Custom license allowing redistribution in modpacks with attribution
- **Compatibility**: Works with Oculus + Embeddium (included in this pack)

## Installation

### Client Installation

1. Download the `.mrpack` file from releases
2. Import into Prism Launcher, MultiMC, or similar launcher
3. Launch and enjoy!

### Dedicated Server Installation

#### Prerequisites

**Java Installation (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install openjdk-17-jre-headless
java -version  # Verify installation shows Java 17+
```

**System Requirements:**
- **RAM**: Minimum 6GB, recommended 8GB or more
- **CPU**: 4+ cores recommended for optimal performance
- **Storage**: At least 10GB free space for world and mods
- **Network**: Port 25565 open for Minecraft connections

#### Server Setup

1. **Clone or download this repository**
2. **Install packwiz** (required for mod management):
   ```bash
   # Install Go if not present
   sudo apt install golang-go
   
   # Install packwiz
   go install github.com/packwiz/packwiz@latest
   
   # Add Go bin to PATH if needed
   echo 'export PATH=$PATH:~/go/bin' >> ~/.bashrc
   source ~/.bashrc
   ```

3. **Setup and start the server**:
   ```bash
   # Setup only (prepare server without starting)
   ./start_server.sh setup
   
   # Or setup and start in one command
   ./start_server.sh
   ```

#### Firewall Configuration

**Ubuntu/Debian with UFW:**
```bash
sudo ufw allow 25565/tcp
sudo ufw reload
```

**Manual iptables:**
```bash
sudo iptables -A INPUT -p tcp --dport 25565 -j ACCEPT
sudo iptables-save > /etc/iptables/rules.v4
```

#### Server Management

**Starting the server:**
```bash
./start_server.sh        # Setup and start
./start_server.sh start  # Same as above
```

**Setup only (no start):**
```bash
./start_server.sh setup
```

**Clean server files:**
```bash
./start_server.sh clean
```

**Manual server start (after setup):**
```bash
cd server
java -Xms4G -Xmx8G -XX:+UseG1GC [... other JVM args] -jar forge-1.20.1-47.3.22.jar nogui
```

#### Troubleshooting

**Common Issues:**

1. **Server won't start - Java version**
   - Ensure Java 17+ is installed: `java -version`
   - Update if needed: `sudo apt install openjdk-17-jre-headless`

2. **Out of memory errors**
   - Increase RAM allocation in the script's `JVM_ARGS`
   - Ensure your system has enough available RAM

3. **Mod compatibility issues**
   - Check `server/logs/latest.log` for mod loading errors
   - Some mods may be client-only and will be automatically excluded

4. **Port already in use**
   - Change `server-port` in `server/server.properties`
   - Or stop the conflicting service: `sudo lsof -i :25565`

5. **Performance issues**
   - Reduce `view-distance` and `simulation-distance` in server.properties
   - Allocate more RAM if available
   - Consider reducing loaded chunks with FTB Chunks mod

**Logs and Monitoring:**
- Server logs: `server/logs/latest.log`
- Check server status: Look for "Done" message in logs
- Monitor performance: Use `htop` or `top` to watch CPU/RAM usage

## Custom Configurations

### Tinkers' Construct Early Levelling
This modpack includes a custom datapack that provides an early-game recipe for making tools improvable:
- **Recipe**: 5 Flint + Tinker Anvil → Improvable modifier
- **Purpose**: Allows tool levelling progression without requiring expensive materials
- **Location**: `config/openloader/data/tla_early_leveling/`

## Attribution

- **Complementary Unbound Shaders**: Created by Complementary Development (https://www.complementary.dev/shaders/)
- **Tinkers' Construct Slime Island Configuration**: Modified generation frequency via datapack

## License

This modpack is distributed for non-profit use only. Individual mods retain their respective licenses.