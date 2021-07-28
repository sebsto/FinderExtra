#  <#Title#>
How to install FinderUtilities

Just download the application from releses (or compile it from the sources), copy it to your /Applications directory and run it once to install the containing Finder Extension. The first time you run the application, it opens up System Preferences > Extensions so that you can enable it. See the picture below:



Alternative way of installing the App Extension

You can also install and remove the extension using the actual extension bundled into the app.

To install and approve the extension, run this:

pluginkit -a FinderUtilities.app/Contents/PlugIns/RightClickExtension.appex/

To remove it, run this:

pluginkit -r FinderUtilities.app/Contents/PlugIns/RightClickExtension.appex/

For more information on distributing and installing application extensions in macOS, read Apple's App Extension Guide.
https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionCreation.html#//apple_ref/doc/uid/TP40014214-CH5-SW1 
