# Android ROM Build Environment - Docker

A Docker image based on Ubuntu 22.04 for building Android custom ROMs with all necessary build tools and dependencies pre-installed.

## Features

- **Base**: Ubuntu 22.04 (jammy)
- **Shell**: Zsh with minimal configuration
- **User**: Non-root `builder` user (UID 1000) with passwordless sudo
- **Ccache**: Pre-configured with 50GB cache limit at `/ccache`
- **Repo tool**: Google's repo tool pre-installed
- **Build packages**: All essential Android build dependencies included

## Building the Image

```bash
docker build -t android-builder:jammy .
```

## Usage

### Basic Interactive Shell

```bash
docker run --rm -it android-builder:jammy
```

### Mount Your Source and Ccache (Recommended)

```bash
docker run --rm -it \
  -v ~/android:/home/builder/android \
  -v ~/ccache:/ccache \
  android-builder:jammy
```

### Full Build Example

```bash
# Create directories for persistent data
mkdir -p ~/android ~/ccache

# Run container with mounts
docker run --rm -it \
  -v ~/android:/home/builder/android \
  -v ~/ccache:/ccache \
  android-builder:jammy

# Inside container:
cd android
repo init -u <manifest-url> -b <branch>
repo sync
source build/envsetup.sh
breakfast <device>
brunch <device>
```

## Installed Packages

Core build tools:

- bc, bison, build-essential, ccache, curl, flex
- g++-multilib, gcc-multilib, git, git-lfs, gnupg, gperf
- imagemagick, lzop, pngcrush, rsync, schedtool
- squashfs-tools, xsltproc, zip

Libraries:

- lib32ncurses-dev, lib32readline-dev, lib32z1-dev
- liblz4-tool, libncurses6, libncurses-dev
- libsdl1.2-dev, libssl-dev, libwxgtk3.2-dev
- libxml2, libxml2-utils, zlib1g-dev

## Configuration

### Ccache

The ccache directory is located at `/ccache` with a default size of 50GB. You can adjust this by:

```bash
ccache -M 100G  # Set to 100GB
ccache -s       # View stats
```

### Zsh Configuration

A minimal `.zshrc` is included with:

- Vi keybindings
- History search (Ctrl+P/Ctrl+N)
- Basic completion
- Android build aliases (breakfast, brunch, mka)
- Git aliases

## Known Issues

### libwxgtk3.2-dev

If the build fails due to `libwxgtk3.2-dev` not being available in Ubuntu 22.04 repositories, you can:

1. Use an alternative package: `libwxgtk3.0-gtk3-dev`
2. Add a PPA before building
3. Remove this package if your ROM doesn't require it

To modify the Dockerfile, edit the package list in the `RUN apt-get install` section.

## Environment Variables

- `CCACHE_DIR=/ccache` - Ccache directory location
- `CCACHE_MAXSIZE=50G` - Maximum ccache size
- `TZ=Asia/Manila` - Timezone (adjust as needed)
- `USE_CCACHE=1` - Enable ccache for builds
- `ANDROID_JACK_VM_ARGS` - Jack compiler memory settings

## Tips

1. **Persistent storage**: Always mount your source code and ccache directories as volumes
2. **Memory**: Ensure your Docker daemon has at least 8GB RAM allocated for building
3. **Disk space**: Allow at least 200GB for a full ROM build
4. **Build user**: The default user is `builder` with UID 1000 (modify `BUILD_UID` build arg if needed)

## Customization

### Change UID

```bash
docker build --build-arg BUILD_UID=1001 -t android-builder:jammy .
```

### Change timezone

Edit the `TZ` environment variable in the Dockerfile.

## License

This Dockerfile is provided as-is for building Android ROMs. Respect the licenses of all included packages and Android source code.
