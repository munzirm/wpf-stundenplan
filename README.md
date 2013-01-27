#### WORK IN PROCESS

## Run in xcode

This project uses [CocoaPods](http://cocoapods.org/).
After installing dependency manager and the dependencies work only
with xcode workspace!

    [sudo] gem update --system
    [sudo] gem install cocoapods
    pod install   # first time
    pod update    # if Pods project is created already
    open stundenplan.xcworkspace

After installing or updating the dependencies it was required that you use the Xcode workspace.

## Was soll er können?

* Liste der nächsten Termine zum eigenem Stundenplan (z.B. nächsten 14 Tage).
* Liste der Fächer (eigener Stundenplan).
* Suche nach Studienfach und Semester:
* Zeigt Liste von Fächern an.
* Jedes Fach kann favorisiert werden -> in den eigenen Stundenplan übernehmen.
* Pro Fach kann auch die Liste der Termine eingesehen werden.
* Kann auch benutzt werden um mal eben nachzuschauen für Freunde.

## Sonstige Funktionen

* Beachtet die Semesterzeiten (Termine sollen danach nicht angezeigt werden) - Kann ggf. fest hinterlegt werden für die nächsten zwei Semester.
* Notifications für Start von (individuell) Fächern, (de)aktivierbar (UILocalNotification)

## Netzwerk-Anbindungen

* Für das holen der Termine überlegen wir noch ob wir die REST-Schnittstelle von Nils Becker verwenden können. Z.B. http://nils-becker.com/calendar/branches
* Eine alternative dazu wäre evtl. die ical Schnittstelle von der FH.
* Hast du da eine Präferenz oder einen Tipp für uns?


