import http from 'k6/http';
import { check } from 'k6';
import { Trend } from 'k6/metrics';

// Definir métricas personalizadas
let responseTimeTrendUsers = new Trend('response_time_users');  // Métrica para el endpoint /users
let responseTimeTrendCategories = new Trend('response_time_categories');  // Métrica para el endpoint /categories
let responseTimeTrendAssignments = new Trend('response_time_assignments');  // Métrica para el endpoint /assignments
let responseTimeTrendAssignmentsProx = new Trend('response_time_assignments_prox');  // Métrica para el endpoint /assignmentsProx
let responseTimeTrendRoles = new Trend('response_time_roles');  // Métrica para el endpoint /roles
let responseTimeTrendSections = new Trend('response_time_sections');  // Métrica para el endpoint /secciones
let responseTimeTrendCombined = new Trend('response_time_combined');  // Métrica combinada para todos los endpoints

// Definir opciones de carga
export let options = {
  vus: 20,        // Número de usuarios virtuales
  duration: '30s', // Duración de la prueba
};

export default function () {
  // Hacer solicitudes GET a los endpoints
  let res = http.get('http://rust_api:8080/users'); // Endpoint para obtener usuarios
  let cat = http.get('http://rust_api:8080/categories'); // Endpoint para obtener categorías
  let assignments = http.get('http://rust_api:8080/assignments/1'); // Endpoint para obtener una asignación por ID
  let assignmentsProx = http.get('http://rust_api:8080/assignmentsProx'); // Endpoint para obtener asignaciones próximas
  let roles = http.get('http://rust_api:8080/roles'); // Endpoint para obtener roles
  let sections = http.get('http://rust_api:8080/secciones'); // Endpoint para obtener secciones

  // Verificar que las respuestas sean 200 OK para todos los endpoints
  check(res, {
    'users endpoint is status 200': (r) => r.status === 200,
  });

  check(cat, {
    'categories endpoint is status 200': (r) => r.status === 200,
  });

  check(assignments, {
    'assignments endpoint is status 200': (r) => r.status === 200,
  });

  check(assignmentsProx, {
    'assignmentsProx endpoint is status 200': (r) => r.status === 200,
  });

  check(roles, {
    'roles endpoint is status 200': (r) => r.status === 200,
  });

  check(sections, {
    'sections endpoint is status 200': (r) => r.status === 200,
  });

  // Registrar las métricas de tiempo de respuesta para cada endpoint
  responseTimeTrendUsers.add(res.timings.duration);
  responseTimeTrendCategories.add(cat.timings.duration);
  responseTimeTrendAssignments.add(assignments.timings.duration);
  responseTimeTrendAssignmentsProx.add(assignmentsProx.timings.duration);
  responseTimeTrendRoles.add(roles.timings.duration);
  responseTimeTrendSections.add(sections.timings.duration);

  // Registrar la métrica combinada de tiempo de respuesta (todos los endpoints)
  responseTimeTrendCombined.add(res.timings.duration);
  responseTimeTrendCombined.add(cat.timings.duration);
  responseTimeTrendCombined.add(assignments.timings.duration);
  responseTimeTrendCombined.add(assignmentsProx.timings.duration);
  responseTimeTrendCombined.add(roles.timings.duration);
  responseTimeTrendCombined.add(sections.timings.duration);
}
