#!/bin/sh

info()
{
  echo "info: $1" 1>&2
}

fatal()
{
  echo "fatal: $1" 1>&2
  exit 1
}

if [ -z "${ANDROID_NDK_HOME}" ]
then
  fatal "\$ANDROID_NDK_HOME is not defined; please set this environment variable"
fi

if [ -z "${ANDROID_SDK_ROOT}" ]
then
  fatal "\$ANDROID_SDK_ROOT is not defined; please set this environment variable"
fi

CURRENT_DIRECTORY=$(pwd)

#------------------------------------------------------------------------
# Copy all of the required headers

info "copying headers"

copyDirectoryHierarchy()
{
  SOURCE="$1"
  TARGET="$2"

  mkdir -p "${TARGET}" ||
    fatal "could not create directory: ${TARGET}"
  rsync -azi "${SOURCE}" "${TARGET}" ||
    fatal "could not copy headers"
}

mkdir -p ./readium-sdk/Platform/Android/epub3/include/libxml/ || fatal "could not create directory"
mkdir -p ./readium-sdk/Platform/Android/epub3/include/sha1/   || fatal "could not create directory"
mkdir -p ./readium-sdk/Platform/Android/epub3/include/libzip/ || fatal "could not create directory"

copyDirectoryHierarchy \
  ./readium-sdk/ePub3/ThirdParty/libxml2-android/include/libxml/ \
  ./readium-sdk/Platform/Android/epub3/include/libxml/

copyDirectoryHierarchy \
  ./readium-sdk/ePub3/ThirdParty/sha1/ \
  ./readium-sdk/Platform/Android/epub3/include/sha1/

copyDirectoryHierarchy \
  ./readium-sdk/ePub3/ThirdParty/libzip/ \
  ./readium-sdk/Platform/Android/epub3/include/libzip/

copyDirectoryHierarchy \
  ./readium-sdk/ePub3/ThirdParty/libxml2-android/include/libxml/ \
  ./readium-sdk/Platform/Android/epub3/include/libxml/

copyDirectoryHierarchy \
  ./readium-sdk/ePub3/ThirdParty/sha1/ \
  ./readium-sdk/Platform/Android/epub3/include/sha1/

copyDirectoryHierarchy \
  ./readium-sdk/ePub3/ThirdParty/icu4c/include/ \
  ./readium-sdk/Platform/Android/epub3/include/icu4c/

copyDirectoryHierarchy \
  ./readium-sdk/ePub3/ThirdParty/utf8-cpp/include/ \
  ./readium-sdk/Platform/Android/epub3/include/utf8/

copyDirectoryHierarchy \
  ./readium-sdk/ePub3/ThirdParty/google-url/base/ \
  ./readium-sdk/Platform/Android/epub3/include/google-url/

copyDirectoryHierarchy \
  ./readium-sdk/ePub3/ThirdParty/google-url/src/ \
  ./readium-sdk/Platform/Android/epub3/include/google-url/

copyDirectoryHierarchy \
  ./readium-sdk/ePub3/ThirdParty/libzip/ \
  ./readium-sdk/Platform/Android/epub3/include/libzip/

copyDirectoryHierarchy \
  ./readium-sdk/ePub3/xml/tree/ \
  ./readium-sdk/Platform/Android/epub3/include/ePub3/xml/

copyDirectoryHierarchy \
  ./readium-sdk/ePub3/xml/utilities/ \
  ./readium-sdk/Platform/Android/epub3/include/ePub3/xml/

copyDirectoryHierarchy \
  ./readium-sdk/ePub3/xml/validation/ \
  ./readium-sdk/Platform/Android/epub3/include/ePub3/xml/

copyDirectoryHierarchy \
  ./readium-sdk/ePub3/utilities/ \
  ./readium-sdk/Platform/Android/epub3/include/ePub3/utilities/

copyDirectoryHierarchy \
  ./readium-sdk/ePub3/ \
  ./readium-sdk/Platform/Android/epub3/include/ePub3/

copyDirectoryHierarchy \
  ./readium-sdk/ePub3/ePub/ \
  ./readium-sdk/Platform/Android/epub3/include/ePub3/

#------------------------------------------------------------------------
# Build the code

info "building native code"

cd readium-sdk/Platform/Android/epub3 ||
  fatal "could not switch to epub3 directory"

export NDK_PROJECT_PATH=$(realpath .) || fatal "could not determine project path"

"${ANDROID_NDK_HOME}/ndk-build" \
  APP_BUILD_SCRIPT=Stable.mk \
  NDK_APPLICATION_MK=Application.mk \
  NDK_DEBUG=1 \
  READIUM_CLANG=true \
  || fatal "could not build code"

#------------------------------------------------------------------------
# Extract the native libraries

info "copying native code"

cd "${CURRENT_DIRECTORY}" ||
  fatal "could not restore directory"

copyFile()
{
  SOURCE="$1"
  TARGET="$2"

  cp -v "${SOURCE}" "${TARGET}" || fatal "could not copy ${SOURCE} -> ${TARGET}"
}

mkdir -p lib/armeabi-v7a || fatal "could not create directory"
mkdir -p lib/x86         || fatal "could not create directory"
mkdir -p lib/arm64-v8a   || fatal "could not create directory"

copyFile ./readium-sdk/Platform/Android/epub3/libs/armeabi-v7a/libc++_shared.so lib/armeabi-v7a/
copyFile ./readium-sdk/Platform/Android/epub3/libs/armeabi-v7a/libepub3.so      lib/armeabi-v7a/
copyFile ./readium-sdk/Platform/Android/epub3/libs/x86/libc++_shared.so         lib/x86/
copyFile ./readium-sdk/Platform/Android/epub3/libs/x86/libepub3.so              lib/x86/
copyFile ./readium-sdk/Platform/Android/epub3/libs/arm64-v8a/libc++_shared.so   lib/arm64-v8a/
copyFile ./readium-sdk/Platform/Android/epub3/libs/arm64-v8a/libepub3.so        lib/arm64-v8a/

ln -s armeabi-v7a lib/armv7a ||
  fatal "could not symlink lib/armeabi-v7a <- lib/armv7a"

#------------------------------------------------------------------------
# Compile the shared JS

info "compiling js"

cd "${CURRENT_DIRECTORY}" ||
  fatal "could not restore directory"

cd readium-shared-js ||
  fatal "could not switch directory"

npm run prepare:all ||
  fatal "could not 'run prepare:all' with npm"

npm run build ||
  fatal "could not 'run build' with npm"

cd "${CURRENT_DIRECTORY}" ||
  fatal "could not restore directory"

copyDirectoryHierarchy \
  readium-shared-js/build-output/_single-bundle/ \
  java/org.librarysimplified.readium.shared_js/src/main/resources/

copyDirectoryHierarchy \
  readium-shared-js/build-output/css/ \
  java/org.librarysimplified.readium.shared_js/src/main/resources/

#------------------------------------------------------------------------
# Compile the Java code

info "compiling java code"

cd "${CURRENT_DIRECTORY}" ||
  fatal "could not restore directory"

copyDirectoryHierarchy \
  ./readium-sdk/Platform/Android/lib/src/ \
  java/org.librarysimplified.readium/src/

copyDirectoryHierarchy \
  ./lib/ \
  java/org.librarysimplified.readium/src/main/jniLibs/

cd java || fatal "could not switch directories"

./gradlew clean assemble || fatal "could not build code"

