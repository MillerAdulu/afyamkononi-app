emu:
		flutter emulators --launch Nexus_5X_API_29_x86

run:
		flutter run

fmt:
		flutter format lib

apk:
		flutter build apk --target-platform android-arm,android-arm64 --split-per-abi
