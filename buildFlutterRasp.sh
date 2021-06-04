#!/bin/bash
flutterDir=/home/sitron/Apps/flutter
flutterRaspBinDir=/home/sitron/Apps/flutter-pi-binaries/arm64
appDir=/home/sitron/Proyects/ShowRoom;
appName="showroom";
cd $appDir;
flutter build bundle;
/home/sitron/snap/flutter/common/flutter/bin/dart
  C:\flutter\bin\cache\dart-sdk\bin\snapshots\frontend_server.dart.snapshot ^
  --sdk-root C:\flutter\bin\cache\artifacts\engine\common\flutter_patched_sdk_product ^
  --target=flutter ^
  --aot ^
  --tfa ^
  -Ddart.vm.product=true ^
  --packages .packages ^
  --output-dill build\kernel_snapshot.dill ^
  --verbose ^
  --depfile build\kernel_snapshot.d ^
  package:my_app_name/main.dart


$flutterDir/bin/dart $flutterDir/bin/cache/dart-sdk/bin/snapshots/frontend_server.dart.snapshot --sdk-root $flutterDir/bin/cache/artifacts/engine/common/flutter_patched_sdk_product --target=flutter --aot --tfa -Ddart.vm.product=true --packages .packages --output-dill build\kernel_snapshot.dill --verbose --depfile build\kernel_snapshot.d package:$appName/main.dart

$flutterRaspBinDir/gen_snapshot_linux_x64_release --deterministic --snapshot_kind=app-aot-elf --elf=build/flutter_assets/app.so --strip build/kernel_snapshot.dill


