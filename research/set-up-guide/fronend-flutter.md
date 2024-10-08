# Flutter Set-up

## Mac

### Android Studio

Download Android Studio
https://developer.android.com/studio

<img width="1024" alt="Mac 1" src="https://github.com/user-attachments/assets/ff5bb705-6fed-4681-9e93-c7376457d25c">

<img width="552" alt="Mac 2" src="https://github.com/user-attachments/assets/9990850d-2a77-44df-a369-182443e6fb70">

<img width="1021" alt="Mac 3" src="https://github.com/user-attachments/assets/d207a7b9-3cad-4e3e-b476-1cc8b410177f">

<img width="1023" alt="Mac 4" src="https://github.com/user-attachments/assets/d42a8618-191a-4dc8-80a8-7e5df40b772b">

Agree to the two licenses, then click the Finish button to complete the installation.
<img width="1023" alt="Accpet two license Mac 5" src="https://github.com/user-attachments/assets/fc33e48e-5468-4cbe-8882-e9968c4f478e">

Open Android Studio
<img width="524" alt="Screenshot 2024-10-07 at 4 05 32 pm" src="https://github.com/user-attachments/assets/c065c5d7-15b8-4d90-83d8-faee0ac1502e">

On the left, go to Plugins and install Flutter
<img width="499" alt="Screenshot 2024-10-07 at 4 05 45 pm" src="https://github.com/user-attachments/assets/af4c71a6-1312-4970-be4e-728418b7f09d">

Click Accept, and since Flutter is based on Dart, install Dart as well.
<img width="1020" alt="Screenshot 2024-10-07 at 4 05 55 pm" src="https://github.com/user-attachments/assets/7c90f3d7-00b8-4703-98dd-a7826c16da8b">

Now go back to the Home screen, and navigate to SDK Manager located under More Actions.
<img width="531" alt="Screenshot 2024-10-07 at 4 06 03 pm" src="https://github.com/user-attachments/assets/8246c312-529d-4ef3-b994-7c6c30f72934">

Go to the SDK Tools tab and install Android SDK Command-line Tools.
<img width="1025" alt="Screenshot 2024-10-07 at 4 06 12 pm" src="https://github.com/user-attachments/assets/661e8b05-04cf-4dad-8462-6b16a38a018a">

Once you complete these steps, the setup for Android Studio is finished
<img width="512" alt="Screenshot 2024-10-07 at 4 06 29 pm" src="https://github.com/user-attachments/assets/00c2c5cc-146c-48e1-9de1-c5cfb8388bab">


### Xcode

Xcode installation is easier than Android Studio because it’s an IDE created by Apple. 
First, open the default App Store app and search for Xcode.
<img width="501" alt="Screenshot 2024-10-07 at 4 06 40 pm" src="https://github.com/user-attachments/assets/65835658-2d0c-41ad-a80c-023425965924">

Since we are not covering watchOS or tvOS, just install the two built-in options.
<img width="551" alt="Screenshot 2024-10-07 at 4 06 52 pm" src="https://github.com/user-attachments/assets/450053a2-9bbf-44c5-9a46-8ff2f29ee9aa">

Once installation is complete, relaunch Xcode. It will display new features, indicating the installation is finished.
<img width="763" alt="Screenshot 2024-10-07 at 4 07 07 pm" src="https://github.com/user-attachments/assets/d346c652-0b08-4d28-b8a3-19ca3f732955">


### VScode

We’ll use VS Code as the IDE for app development with Flutter.

Why use VS Code when Xcode is available?
Xcode only supports Swift, C, C++, and Objective-C. Since there are no plugins for Dart and Flutter, we use VS Code.

Then why install Xcode?
Xcode includes essential developer tools and the iOS simulator, which are required for iOS development. Without Xcode, using the simulator and developer tools becomes challenging.


Click the Extensions icon on the left. Then, search for Flutter and the extension will appear. Go ahead and install it.
Installing the Flutter Widget Snippets extension is also recommended.
<img width="301" alt="Screenshot 2024-10-07 at 4 08 04 pm" src="https://github.com/user-attachments/assets/c8501208-6e2f-4c41-b31f-2d0cc22cf63f">

With this, the installation and setup of VS Code are complete.
At this point, all necessary apps are installed and configured.

### Flutter SDK

The next step is to download the Flutter SDK. 
Since Flutter isn’t built into the operating system by default, this is a necessary step.

You’ll find a link to download the Flutter SDK. Download the Apple Silicon version.

https://docs.flutter.dev/get-started/install/macos/desktop

<img width="624" alt="Screenshot 2024-10-07 at 5 20 40 pm" src="https://github.com/user-attachments/assets/7cf617a7-60cd-4bf7-9957-cf2480e0eee6">

Rosetta 2 is needed to run Intel-based programs on M1 chips, as they use a different architecture (ARM).
To update or install Rosetta 2, enter the following command in Terminal.
Rosetta is usually pre-installed, but if you encounter errors, running this command can help.
```sudo softwareupdate --install-rosetta --agree-to-license```

After downloading the file, unzip it to your desired location.
To extract the Flutter SDK file to the development folder, use the command shown on the site.
You can extract it anywhere, but if you’re unsure about the path, using this command will place it in the recommended directory.

<img width="642" alt="Screenshot 2024-10-07 at 5 20 54 pm" src="https://github.com/user-attachments/assets/4c01bed1-b109-4ad3-95e5-7861f180ee11">

All necessary files have been downloaded. However, the system doesn’t know where these files are located, so you’ll need to set the environment variables.
<img width="651" alt="Screenshot 2024-10-07 at 5 21 42 pm" src="https://github.com/user-attachments/assets/afa91cbb-2d79-4569-bd07-e8a4e23684b8">

### Checking Installation

To check if the installation was successful, enter the following command in the terminal.
```flutter doctor```

A detailed specification will appear, and you may see errors marked with [!] or [x]. Let’s address each issue step-by-step.
<img width="683" alt="Screenshot 2024-10-07 at 5 23 39 pm" src="https://github.com/user-attachments/assets/31a46a89-997e-4ffb-ae57-f57f96a443ee">

If running ```flutter doctor``` returns an ‘unknown command’ error, it’s likely that there’s an issue with the path set during export. Double-check to ensure the correct file path for the Flutter installation is specified.

# Fixing errors

## Error 1

On Mac is usually due to Rosetta 2 not being installed. As previously mentioned, the M1 chip is ARM-based and can’t run x64-based programs directly. However, Rosetta 2 translates x64 CPU instructions to ARM instructions, allowing the Flutter SDK to run. The warning appears because Rosetta isn’t installed.

Run the following command to resolve this issue easily.
```sudo softwareupdate --install-rosetta --agree-to-license```


## Error 2

Occurs because you haven’t accepted the Android licenses. To fix it, simply agree to the licenses.

Run the following command in the terminal to resolve this issue.
```flutter doctor --android-licenses```

A list of licenses will appear on the screen. Press y to accept each one.
<img width="531" alt="Screenshot 2024-10-07 at 5 27 42 pm" src="https://github.com/user-attachments/assets/c67bfc74-aba2-4c8e-a8cb-51f90860766a">
Enter yyyyyyyyyyyyyyyy

## Error 3

Error 3 is related to Xcode. Although Flutter has a package system, some packages require Xcode’s CocoaPods to function properly. This error message indicates that CocoaPods is missing, so you’ll need to install it.
You can visit the CocoaPods official site(https://guides.cocoapods.org/using/getting-started.html) and follow the installation guide provided there.

As mentioned on the site, you can install CocoaPods by entering the following command in the terminal.
```sudo gem install cocoapods```

Since you’re using the sudo command, you’ll need to enter your Mac password.
<img width="689" alt="Screenshot 2024-10-07 at 5 31 23 pm" src="https://github.com/user-attachments/assets/a4c7bc7f-8242-4abc-a4c5-5708dbe0572e">

If the installation completes as shown below, then it was successful.
<img width="505" alt="Screenshot 2024-10-07 at 5 31 53 pm" src="https://github.com/user-attachments/assets/e75757a6-4b1c-403f-8d98-c7d0004c7b35">

## Error 4
Although Error 4 may seem serious, it’s actually quite simple: it indicates that Chrome is not installed. Since Flutter uses Chrome for simulation, you’ll need to download and install it.

# Double Check
Finally, type ```flutter doctor``` and ```flutter -v```(check flutter version) to confirm that the installation was successful.

## Window

Install Android Studio the same way as on a Mac
https://developer.android.com/studio

Run the installer to proceed with the setup wizard. During installation, select Android Virtual Device to install it. Otherwise, simply click Next throughout the process to complete the installation.
<img width="719" alt="Screenshot 2024-10-07 at 5 50 35 pm" src="https://github.com/user-attachments/assets/3e754c2f-f5bf-411c-abf4-2eeb99aedd42">

## Flutter SDK

Now, you need to install the Flutter SDK for use in Android Studio. Go to the official Flutter website.
https://docs.flutter.dev/release/archive?tab=windows

The downloaded file is a compressed file (*.zip), not an installer. Extract the contents and move them to your desired path, such as *C:\flutter* or *D:\flutter*.

### Windows environment variable setup URL
https://www.dhiwise.com/post/how-to-install-flutter-on-windows-everything-need-to-know

# Verify Installation

To ensure Flutter has been installed correctly and the PATH is set, open a new command prompt or PowerShell window and run:
```flutter doctor```
