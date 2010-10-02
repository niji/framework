rem ** CONFIG **
set FLEX3_SDK_PATH=c:\mydoc\flex_sdk_3.5.0
set COPY_TARGET_PATH=..\gunyarapaint\libs

rem ** BUILD **
%FLEX3_SDK_PATH%\bin\compc -benchmark=true -incremental=true -optimize=true -target-player=10.0.0 -verbose-stacktraces=true -include-sources src -source-path .\src -output .\bin\framework.swc
copy .\bin\framework.swc %COPY_TARGET_PATH%
