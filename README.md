# INUS - All You Need In Us

A mobile application for university students that organizes events, seminars, and competitions to assist students who experienced difficulties organizing and identifying relavant emails. 

Furthermore, it provides a platform for communication between students to allow easier bonding of university students within Hong Kong. 

Developed by APDI - Mobile application development team of HKUST.

## Repo Structure

```
├── README.md
├── analysis_options.yaml  # ignore; admin stuff
├── android/               # android related config files; might need to edit them in android studio
├── ios/                   # ios related config files; might need to edit them in XCode
├── macos/                 # macos related config files; might need to edit them in XCode
├── web/                   # web related config files; debug in chrome
├── build/                 # build cache; automatically generated; ignore
├── lib/                   # Our main place to write code!
│   ├── models/            # model of the data
│   ├── views/             # how we show the data; UI stuff.
│   ├── controllers/       # how we manipulate the data
│   ├── utils/             # some utility functions
│   └── main.dart          # the app's entry point.
├── aus.iml                # ignore; admin stuff
├── pubspec.lock           # ignore; automatically generated log of current version of dependencies
├── pubspec.yaml           # if we have any third-party dependency package, we write here
└── test                   # test the functionalities
    └── *_test.dart
```

### Some Notes

* We will use material library, which kinda looks like most android apps, but we can certainly
  customize them. Material library has much more resources online.
* We will use firebase heavily. We would use firestore as our main backend database,
  firebase auth for user authentication, firebase functions / cloud messaging for notifications.
* We will use MVC (Model - View - Controller) pattern.
  * However, since we use firestore a lot, this gets fuzzy a lot. The main principle I look for is
    **"Code Reusability"**. I don't want to see the same code copy-pasted to another file, when
    it can be simply imported from another source, if you have implemented it as a separate function.
* Always modularize. Make small functions.
* Make variable names / function / file names that make sense.
  * Also, use `CamelCase` for variable / function names and `snake_case` for file names.
* Try to abide by what the code completion tool / helper tells you to do. When there are
  yellow or blue underlines, it means it wants you to change something. This often leads
  you to higher quality code.
  * one example is putting `const` in the UI components that will not change.
* Dart language is very easy to make a widget tree very deeply neested; this is problematic
  since the autoformatter will force the code to be less than 80 characters per line, and
  make the code look very weird.
    * e.g. if you look at some of the content of `build` function of any `Widget`, it is
      likely that they are heavily nested.
    * To avoid this, again, you should **modularize**.
    * How? Consider you have following button:

    ```dart
    Container(
        child: Button(
            onPressed: (){ print("hello!"); },
            child: Center(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Hello!"),
                )
            )
        )
    )
    ```
    * This example is not that severe actually. However, you see where I'm going with this.
      What you can do is define a function or Widget class about some inner component:

    ```dart
    Widget CenteredPaddedText(String text, int pad) {
        return Center(
              child: Padding(
                  padding: EdgeInsets.all(pad),
                  child: Text(text),
              )
          )
    }

    ...
    Container(
        child: Button(
            onPressed: (){ print("hello!"); },
            child: CenteredPaddedText("Hello!", 10)  // use it here!
        )
    )

    ```
