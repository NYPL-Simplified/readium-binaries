readium-binaries
===

![readium-binaries](./readium-binaries.jpg?raw=true)

[Tea Time by ThoughtCatalog](https://pixabay.com/photos/tea-time-poetry-coffee-reading-3240766/)

# Building

```
$ export ANDROID_NDK_HOME=/path/to/android/ndk
$ export ANDROID_SDK_ROOT=/path/to/android/sdk
$ ./make.sh
```

The `make.sh` script will compile Readium for `x86`, `armv7`,
and `arm64`. It will then compile all of the Readium `shared-js`
code. Finally, it compiles the Java code and packages all of the
above into an Android `aar` and `jar` file.

# Publishing

```
$ cd java
$ ./gradlew publishToMavenLocal
$ ./gradlew publish
```

The `publishToMavenLocal` task publishes the components to your
local Maven repository. The `publish` task publishes the components
to Maven Central (assuming that you have the correct credentials and
PGP set up - doing so is outside of the scope of this documentation).

# Credits

Thanks to @kyles-ep for the initial `arm64` setup!
