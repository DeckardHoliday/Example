call "%~dp0Engine\Build\BatchFiles\RunUAT.bat" BuildCookRun -project="%~dp0Example/Example.uproject" -noP4 -clientconfig=Development -serverconfig=Development -nocompileeditor -ue4exe="%~dp0\Engine\Binaries\Win64\UE4Editor-Cmd.exe" -utf8output -platform=Win64 -targetplatform=Win64 -build -cook -map=FirstPersonExampleMap -unversionedcookedcontent -pak -distribution -SkipCookingEditorContent -compressed -stage -package -stagingdirectory="%~dp0Dist" -cmdline="Splash -Messaging"