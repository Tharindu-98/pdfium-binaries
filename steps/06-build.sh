#!/bin/bash -eux

SOURCE=${PDFium_SOURCE_DIR:-pdfium}
BUILD_DIR=${PDFium_BUILD_DIR:-$SOURCE/out}
TARGET_CPU=${PDFium_TARGET_CPU:?}

ninja -C "$BUILD_DIR" pdfium

if [ "$TARGET_CPU" == "wasm" ]; then
  emnm -C pdfium/out/obj/libpdfium.a > libpdfium.a.txt
  em++ -s LLD_REPORT_UNDEFINED -s WASM=1 -s EXPORTED_FUNCTIONS="_FPDF_InitLibraryWithConfig" -s EXPORTED_RUNTIME_METHODS='["cwrap"]' "$BUILD_DIR/obj/libpdfium.a"  "$BUILD_DIR/obj/libpdfium.a" -o "$BUILD_DIR/pdfium"
fi