call git -C %~dp0 submodule update --init
if %errorlevel% neq 0 exit /b %errorlevel%
call "%~dp0Engine\Binaries\DotNET\GitDependencies.exe" %PROMPT_ARGUMENT% --exclude=Samples --exclude=Templates --exclude=FeaturePacks --exclude=Engine/Documentation --exclude=Engine/Saved %*
if %errorlevel% neq 0 exit /b %errorlevel%
rem This represents 9.5 GB of cached files that we probably don't want to  keep.
rmdir /s /q "%~dp0.git\ue4-gitdeps"
if %errorlevel% neq 0 exit /b %errorlevel%
call "%~dp0Engine\Extras\Redist\en-us\UE4PrereqSetup_x64.exe" /quiet
if %errorlevel% neq 0 exit /b %errorlevel%
pushd "%~dp0Engine\Source"
rem TODO: This duplicate command is not the best but it's an easy way to make the build work on both people's boxes and runners.
rem On people's box we install a specific version of MSVC. On runners we leverage what's already there and rely on vswhere to find the binaries.
IF EXIST "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe" (
  call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe" /nologo /verbosity:quiet Programs\UnrealBuildTool\UnrealBuildTool.csproj /property:Configuration=Development /property:Platform=AnyCPU /target:Build
) ELSE (
  call MSBuild /nologo /verbosity:quiet Programs\UnrealBuildTool\UnrealBuildTool.csproj /property:Configuration=Development /property:Platform=AnyCPU /target:Build
)
call "%~dp0Engine\Binaries\DotNET\UnrealBuildTool.exe" ShaderCompileWorker Win64 Development -WaitMutex -FromMsBuild
call "%~dp0Engine\Binaries\DotNET\UnrealBuildTool.exe" UnrealLightmass Win64 Development -WaitMutex -FromMsBuild
popd