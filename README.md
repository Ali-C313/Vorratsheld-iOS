# Vorratsheld (iOS)

Vorratsheld behält den Vorrat zu Hause im Blick: Produkte per Barcode scannen, das Mindesthaltbarkeitsdatum mit der Kamera ablesen und kurz vor Ablauf eine Erinnerung bekommen. Dazu gibt es eine Einkaufsliste, auf der gelöschte Favoriten automatisch landen.

Native iOS-Version in Swift und SwiftUI, aufgebaut wie im iOS-Modul: MVVM mit `@Observable`, Repository Pattern mit Dependency Injection (Protokoll + Impl + Mock) und Firebase über den `FirebaseManager`. Firestore-Collections und Felder sind gleich wie in der Kotlin-Multiplatform-Version, beide Apps nutzen dieselben Daten.

## Funktionen

- Barcode-Scan: AVFoundation, Name und Bild kommen von Open Food Facts
- MHD-Scan: Texterkennung mit Apple Vision, Taschenlampe für dunkle Umgebungen
- Übersicht: Kühlschrank/Kammer, Ablauf-Farben, Wischen zum Bearbeiten oder Löschen (mit Rückgängig)
- Live-Daten: Vorrat und Einkaufsliste über Snapshot-Listener
- Erinnerungen: lokale Benachrichtigung um 9 Uhr, 3 Tage vor Ablauf
- Einkaufsliste: Abhaken, Menge ändern, Wischen zum Löschen, Fortschritt im Kopf
- App-Sperre: Face ID / Touch ID mit eigenem PIN als Ersatz, Sperrzeit einstellbar
- Konto: Login, Registrierung, Profilbild, E-Mail und Passwort ändern, Konto löschen
- Hilfe-Formular: Anfragen landen in Firestore und optional per Mail (EmailJS)
- 10 Sprachen: direkt in der App umschaltbar, Arabisch von rechts nach links

## Aufbau

```
Vorratsheld/
  VorratsheldApp.swift      Firebase starten
  ContentView.swift         Splash, Onboarding, Login oder Home + Sperrbildschirm
  Enums/                    Lagerort, Sprachen, Routen, Fehler, ...
  Models/                   Product, ShoppingItem, FireUser, API-Antworten
  Repositories/
    Auth/                   AuthRepository, AuthRepositoryImpl, AuthRepositoryMock
    User/                   Profil
    Product/                Vorrat
    Shopping/               Einkaufsliste
    Support/                Hilfe-Formular
    ProductInfo/            Open Food Facts
  Viewmodels/               @Observable-Klassen
  Views/
    Components/             Wiederverwendbare Views (Pin/ für das Ziffernfeld)
    Auth/ Home/ Scan/ ...   Ein Ordner pro Bereich
  Preview/                  ViewModels mit Mock-Repositories für die Previews
  Util/
    Config/                 Secrets.swift (nicht im Git)
    Date/                   Datum, MHD-Parser
    Firebase/               FirebaseManager, Collection-Namen
    Localization/           Texte in 10 Sprachen
    Network/                WebService, HTTPError
    Settings/               Lokale Einstellungen, App-Sperre
    Theme/                  Farben
  Resources/                Localizable.xcstrings, GoogleService-Info.plist (nicht im Git)
```

## Architektur

- MVVM: ViewModels sind `@MainActor @Observable` Klassen. Die View, die ein ViewModel zuerst erstellt, hält es als `@State`
- Shared ViewModel: `AppViewModel`, `UserViewModel`, `ProductViewModel` und `LockViewModel` werden in `ContentView` erstellt, mit `.environment(...)` weitergegeben und in den Screens mit `@Environment` geholt
- Repository Pattern: Jedes Repository besteht aus dem Protokoll (`ProductRepository`), der Umsetzung mit Firebase (`ProductRepositoryImpl`) und Testdaten für die Previews (`ProductRepositoryMock`)
- Dependency Injection: Die ViewModels bekommen ihre Repositories im `init`: in der App die Impl, in den Previews die Mocks aus `PreviewData`

## Installation

1. Projekt klonen und `Vorratsheld.xcodeproj` in Xcode 16 oder neuer öffnen (iOS 18)
2. `GoogleService-Info.plist` aus der Firebase-Konsole nach `Vorratsheld/Resources/` legen
3. `Secrets.swift.example` nach `Vorratsheld/Util/Config/Secrets.swift` kopieren und die EmailJS-Daten eintragen (ohne EmailJS bleiben die Platzhalter drin)
4. Unter *Signing & Capabilities* das Team prüfen
5. Auf einem echten iPhone starten, im Simulator gibt es keine Kamera

Beide Dateien aus Schritt 2 und 3 stehen in der `.gitignore` und werden nicht hochgeladen.

## Verwendung

1. Beim ersten Start zeigt die App ein kurzes Onboarding
2. Registrieren oder mit einem bestehenden Konto der Android-Version einloggen
3. Auf "Scannen" tippen, Barcode in den Rahmen halten, danach das MHD scannen oder im Kalender wählen
4. Produkte in der Übersicht nach links wischen zum Bearbeiten oder Löschen, antippen für die Details
5. In den Einstellungen Sprache, App-Sperre und Profil anpassen

## Autor

Ali Chehab
