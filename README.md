<!DOCTYPE html>

<body>

<h1>LobbosShop</h1>

<p>LobbosShop ist eine E-Commerce-App, die Benutzern das Durchsuchen, Favorisieren, Kaufen und Verwalten von Produkten ermöglicht. Die App integriert PayPal für Zahlungen und nutzt Firebase für die Verwaltung von Benutzerdaten und Bestellungen. Zusätzlich werden Produktdaten von einer externen API abgerufen und MapKit wird zur Unterstützung bei der korrekten Adresseingabe verwendet. Firebase Crashlytics wird für das Crash-Reporting genutzt.</p>

<h2>Inhaltsverzeichnis</h2>
<ul>
    <li><a href="#funktionen">Funktionen</a></li>
    <li><a href="#geplantes-design">Geplantes Design</a></li>
    <li><a href="#technischer-aufbau">Technischer Aufbau</a>
        <ul>
            <li><a href="#projektaufbau">Projektaufbau</a></li>
            <li><a href="#datenspeicherung">Datenspeicherung</a></li>
            <li><a href="#technologien">Technologien</a></li>
        </ul>
    </li>
</ul>

<h2 id="funktionen">Funktionen</h2>
<ul>
    <li>Benutzerfreundliches Interface für das Durchsuchen und Kaufen von Artikeln</li>
    <li>Abrufen von Produktdaten von einer externen API</li>
    <li>Integration der PayPal API für Zahlungen</li>
    <li>Benutzerprofile und Einstellungen über Firebase Authentication</li>
    <li>Produktbewertung: Nutzer können Produkte bewerten und Bewertungen anderer einsehen über Firestore</li>
    <li>Warenkorb und Bestellverwaltung über Firestore</li>
    <li>Favoritenfunktion für Produkte</li>
    <li>Produktfilter und Suchfunktion</li>
    <li>Nutzung von MapKit wird zur Unterstützung bei der korrekten Adresseingabe verwendet</li>
    
    
</ul>

<h2 id="geplantes-design">Geplantes Design</h2>
<img src="https://github.com/user-attachments/assets/4d99d566-1857-414f-a66f-6a3f7133d522" alt="anmelden" width="200">
<img src="https://github.com/user-attachments/assets/9929947c-fdc1-4f2c-a9e2-a95857f89816" alt="anmelden" width="200">
<img src="https://github.com/user-attachments/assets/808a8c45-446c-4bd8-a05a-de4c337dcd24" alt="anmelden" width="200">
<img src="https://github.com/user-attachments/assets/ce3c7067-bba5-44c2-a3e1-5d9f399419c9" alt="anmelden" width="200">
<img src="https://github.com/user-attachments/assets/f80331c3-81b8-4787-ab2f-988ab309e9f1" alt="anmelden" width="200">
<img src="https://github.com/user-attachments/assets/cabb76f2-374a-483a-8c10-2d63a6db4d07" alt="anmelden" width="200">
<img src="https://github.com/user-attachments/assets/ca732d99-5824-4731-ace8-acf560391a05" alt="anmelden" width="200">
<img src="https://github.com/user-attachments/assets/30670b92-4cf7-47e0-9a1f-2d68e7650f6f" alt="anmelden" width="200">

<h2 id="technischer-aufbau">Technischer Aufbau</h2>

<h3 id="projektaufbau">Projektaufbau</h3>
<p>Die Architektur der App ist so konzipiert, dass sie effizient und wartbar ist:</p>
<ul>
    <li><code>src</code>
        <ul>
            <li><code>models</code> - Datenmodelle und Logik für die Artikel- und Benutzerverwaltung</li>
            <li><code>views</code> - Benutzeroberflächenkomponenten für die Darstellung der Artikel und Bestellprozesse</li>
            <li><code>viewmodels</code> - Verwaltung der Geschäftslogik und Interaktionen zwischen Benutzeroberfläche und Daten</li>
            <li><code>assets</code> - Statische Ressourcen wie Bilder und Icons für die Darstellung der Produkte</li>
        </ul>
    </li>
</ul>

<h3 id="datenspeicherung">Datenspeicherung</h3>
<p>Die App nutzt Firebase für die Speicherung von Daten:</p>
<ul>
    <li><strong>Firebase Firestore</strong>: Zur Verwaltung von Produktinformationen, Benutzerdaten, Bestellungen und Bewertungen</li>
    <li><strong>Firebase Authentication</strong>: Für die Anmeldung und Authentifizierung der Benutzer</li>
    <li><strong>Firebase Crashlytics</strong>: Für das Crash-Reporting</li>
</ul>

<h3 id="api-calls">Technologien</h3>
<ul>
    <li><strong>Externe Produkt-API</strong>: Zum Abrufen von Produktinformationen.</li>
    <li><strong>PayPal API</strong>: Zur Bereitstellung von Zahlungsdiensten und Durchführung von Transaktionen.</li>
    <li><strong>Google Translate API</strong>: Nutzung der Google Translate API, um Bewertungen aus allen Sprachen ins Englische zu übersetzen.</li>
    <li><strong>Map Kit</strong>: Unterstützung der Benutzer bei der Eingabe ihrer Adressen durch die Verwendung von Map Kit.</li>
    <li><strong>PDF Kit</strong>: Erstellung von PDF-Dokumenten für Rechnungen mithilfe des PDF Kits.</li>
</ul>

<p>Vielen Dank für Ihr Interesse an LoboShop. Bei Fragen oder Anregungen stehe ich Ihnen gerne zur Verfügung.</p>
<p>Mit freundlichen Grüßen,<br>
Michel Lobbos</p>
</body>
</html>
