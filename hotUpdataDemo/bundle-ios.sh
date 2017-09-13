#!/bin/bash
if [[ $1 = '-h' || $1 = '' ]]; then
  echo '>>'
  echo '>> bundle-ios.sh <iOSProjectFile>     生成api'
  echo '>> bundle-ios.sh <iOSProjectFile> zip   只打包bundle.zip'
  echo '>>'
  exit 0;
fi

PROJECT_NAME=$(basename $1 .xcodeproj);
echo ">> 项目名: $PROJECT_NAME";

if [[ $PROJECT_NAME = '' ]]; then
  echo ">> 未找到项目名, 请正确选择 .xcodeproj 文件!"
fi

if [[ ! -d "./bundle-ios" ]]; then
  mkdir ./bundle-ios
  echo '>> 创建 bundle-ios 目录'
fi

if [[ -f "./bundle-ios/bundle.zip" ]]; then
    rm -rf ./bundle-ios/*
    echo '>> 清空 bundle-ios 目录'
fi

echo '>> 开始 RN 打包...'
react-native bundle --platform ios --dev false --entry-file index.ios.js --bundle-output ./bundle-ios/main.jsbundle  --assets-dest ./bundle-ios/
echo '>> RN 打包完成.'

if [[ -f "./bundle-ios/main.jsbundle" ]]; then
    echo '>> 开始压缩...'
    cd ./bundle-ios
    zip -r -D ./bundle.zip ./assets* ./main.jsbundle
    rm ./main.jsbundle*
    rm -rf ./assets*
    # md5 ./bundle.zip > ./bundle.md5
    cd ..
    echo '>> 压缩完成.'
    if [[ -f "./bundle-ios/bundle.zip" ]]; then
      if [[ $2 = 'zip' ]]; then
        echo '>> bundle.zip 已保存至 ./bundle-ios'
      else
        echo '>> 复制 bundle.zip 至 ios 目录...'
        cp ./bundle-ios/bundle.zip ./ios/
        echo ">> 开始打包。。。"
        echo ">> xcodebuild clean -project ./ios/$PROJECT_NAME.xcodeproj -configuration ${CONFIGURATION} -alltargets"
        xcodebuild clean -project ./ios/$PROJECT_NAME.xcodeproj -configuration ${CONFIGURATION} -alltargets
        echo ">> xcodebuild archive -project ./ios/$PROJECT_NAME.xcodeproj -scheme $PROJECT_NAME -archivePath ./bundle-ios/$PROJECT_NAME.xcarchive"
        xcodebuild archive -project ./ios/$PROJECT_NAME.xcodeproj -scheme $PROJECT_NAME -archivePath ./bundle-ios/$PROJECT_NAME.xcarchive
        echo ">> xcodebuild -exportArchive -archivePath ./bundle-ios/$PROJECT_NAME.xcarchive -exportPath ./bundle-ios -exportOptionsPlist bundle.plist"
        xcodebuild -exportArchive -archivePath ./bundle-ios/$PROJECT_NAME.xcarchive -exportPath ./bundle-ios -exportOptionsPlist bundle.plist
        if [[ -f "./bundle-ios/$PROJECT_NAME.ipa" ]]; then
          echo ">> 打包完成。。。"
          rm -rf ./bundle-ios/$PROJECT_NAME.xcarchive
        else
          echo ">> 打包失败。。。"
        fi
        
      fi
    else
      echo ">> 无法找到bundle.zip，确保RN打包成功"
    fi
fi