import http from 'k6/http';
import { check } from 'k6';
import { Trend } from 'k6/metrics';

// Definir una métrica personalizada
let responseTimeTrend = new Trend('response_time');

export default function () {
  // Hacer una solicitud GET a /users
  let res = http.get('http://0.0.0.0:8080/users'); // Cambia esto por la URL correcta

  // Verificar que la respuesta sea 200 OK
  check(res, {
    'is status 200': (r) => r.status === 200,
  });

  // Registrar la métrica de tiempo de respuesta
  responseTimeTrend.add(res.timings.duration);
}
