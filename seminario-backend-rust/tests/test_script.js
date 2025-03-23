import http from 'k6/http';
import { check } from 'k6';
import { Trend } from 'k6/metrics';
import { sleep } from 'k6';

// Definir métricas personalizadas
let responseTimeTrendUsers = new Trend('response_time_users');
let responseTimeTrendCategories = new Trend('response_time_categories');
let responseTimeTrendCombined = new Trend('response_time_combined');

// Obtener parámetros de variables de entorno o usar valores predeterminados
const MAX_VUS = __ENV.MAX_VUS ? parseInt(__ENV.MAX_VUS) : 20;
const DURATION = __ENV.DURATION || '30s';
const RAMP_UP = __ENV.RAMP_UP || '10s';

// Configuración dinámica basada en parámetros
export let options = {
  stages: [
    { duration: RAMP_UP, target: MAX_VUS }, // Incremento gradual hasta MAX_VUS
    { duration: DURATION, target: MAX_VUS }, // Mantener MAX_VUS durante DURATION
    { duration: '10s', target: 0 }, // Reducción gradual
  ],
  
  thresholds: {
    http_req_duration: ['p(95)<500'], // Falla si el 95% de las solicitudes tardan más de 500ms
    'http_req_duration{type:users}': ['p(95)<400'],
    'http_req_duration{type:categories}': ['p(95)<300'],
  },
};

export default function () {
  // Grupo de usuarios para mejor organización de métricas
  let responses = http.batch([
    ['GET', 'http://rust_api:8080/users', null, { tags: { type: 'users' } }],
    ['GET', 'http://rust_api:8080/categories', null, { tags: { type: 'categories' } }]
  ]);
  
  // Verificaciones de estado
  check(responses[0], {
    'users endpoint is status 200': (r) => r.status === 200,
  });
  
  check(responses[1], {
    'categories endpoint is status 200': (r) => r.status === 200,
  });
  
  // Registrar métricas de tiempo de respuesta
  responseTimeTrendUsers.add(responses[0].timings.duration);
  responseTimeTrendCategories.add(responses[1].timings.duration);
  responseTimeTrendCombined.add(responses[0].timings.duration);
  responseTimeTrendCombined.add(responses[1].timings.duration);
  
  // Pequeña pausa para simular comportamiento de usuario real
  sleep(0.1);
}