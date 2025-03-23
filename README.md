# seminario-backend-rust

Versión del backend de seminario de investigación en rust

### pasos para mostrar el templace k6

1) Ir a "Connections" y despues "Add ne connection"

2) Bucar en el buscador "InfluxDB"

3) Dar click en "Add new data source"

4) poner la url que es:

```
http://influxdb:8086
```

5) Ir al Database y poner "K6"

6) Poner el metodo GET en HTTP Method

7) Dar click en Save & Test

8) Nos vamos al Dashboard y le damo click en New y despues click en "Import"

9) Ponemos el codigo que es *2587*

10) Y por ultimo nos vamos donde dice K6 y selecionamos la unica opcion que no sale que es el "influxdb"

Comano para ejecutar

```powershell
$env:MAX_VUS=100; $env:DURATION="1m"; $env:RAMP_UP="20s"; docker-compose up k6
```
