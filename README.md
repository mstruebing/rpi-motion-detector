# README #

## ZIELE ##

Unsere Ziele persoenlichen Ziele fuer dieses Projekt sind der Einsatz von C sowie Elm anhand eines echten Projekts.
Dazu wollen wir sehen wie die Kombination des Bewegungsmelders mit der Webcam funktionieren kann und wird.

## PROJEKTBESCHREIBUNG ##

Wir werden einen Rasperry PI benutzen um mittels eines Bewegungsmelders Bewegung zu erkennen
und dann eine Webcam ansteuern die ein Bild macht (spaeter, falls noch Zeit, optional Videos).
Diese Bilder werden an einen Server uebertragen und dort in eine bestimmte Ordnerstruktur gebracht.
Dann wird es ein Web-basiertes Frontend geben was beim Server alle verfuegbaren Bilder anfragt und darstellt.

## CHECKLISTE ##

### Must haves ###
- [ ] RPI erstellt Bilder bei Bewegung
- [ ] RPI sendet Daten an Server
- [ ] Server sortiert Bilder in passende Ordnerstruktur
- [ ] API gibt auf Anfrage ein JSON mit den gesammelten Bild-Daten
- [ ] Frontend stellt diese Bilder in einer Listansicht dar


### Nive to haves ###

- [ ] Thumbnail Generierung der Bilder
- [ ] Frontend stellt "das grosse Bild" nur bei Bedarf dar
- [ ] Bilder loeschen ueber das Frontend
- [ ] Videoaufzeichnung anstatt Bilder