#!/usr/bin/env bash

## 计时
cd ..
env=${SET_ENV}

app="app/android"
env=release

version=$(grep 'version:' pubspec.yaml)
version=${version#version: }

mkdir -p "$app/${env}/"
echo "android===$env====$version"

echo "清理 build"
flutter clean
rm -rf build

echo "开始获取 packages 插件资源"
flutter packages get

echo "开始打包apk"
flutter build apk --"${env}" --target-platform android-arm -t lib/main_local.dart   #--no-codesign
echo "打包apk已完成"

mv ./build/app/outputs/apk/${env}/app-${env}.apk ./$app/${env}/聚砼v${version}.$(date "+%Y%m%d%H%M").apk

echo "打包完成😄"
