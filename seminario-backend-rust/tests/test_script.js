import http from 'k6/http';
import { check } from 'k6';
import { Trend } from 'k6/metrics';

// Definir métricas personalizadas
let responseTimeTrendUsers = new Trend('response_time_users');  // Métrica para el endpoint /users
let responseTimeTrendCategories = new Trend('response_time_categories');  // Métrica para el endpoint /categories
let responseTimeTrendCombined = new Trend('response_time_combined');  // Métrica combinada para ambos endpoints

// Definir opciones de carga
export let options = {
  vus: 20,        // Número de usuarios virtuales
  duration: '30s', // Duración de la prueba
};

export default function () {
  // Hacer una solicitud GET a /users
  let res = http.get('http://rust_api:8080/users'); // Cambia esto por la URL correcta
  let cat = http.get('http://rust_api:8080/categories'); // Cambia esto por la URL correcta 

  // Verificar que la respuesta sea 200 OK para ambos endpoints
  check(res, {
    'users endpoint is status 200': (r) => r.status === 200,
  });

  check(cat, {
    'categories endpoint is status 200': (r) => r.status === 200,
  });

  // Registrar la métrica de tiempo de respuesta para el endpoint /users
  responseTimeTrendUsers.add(res.timings.duration);

  // Registrar la métrica de tiempo de respuesta para el endpoint /categories
  responseTimeTrendCategories.add(cat.timings.duration);

  // Registrar la métrica combinada de tiempo de respuesta (ambos endpoints)
  responseTimeTrendCombined.add(res.timings.duration);
  responseTimeTrendCombined.add(cat.timings.duration);
}
