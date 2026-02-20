# 🏔️ Sierra Nevada Properties Dashboard

Dashboard interactivo para visualizar y filtrar apartamentos en Sierra Nevada encontrados por Sierra Nevada Monitor.

## Características

✨ **Grid responsivo** de propiedades con tarjetas detalladas
🔍 **Filtros avanzados** por precio, score de valoración, zona/localidad
⭐ **Sistema de puntuación** (1-10) basado en:
  - Precio (mejor para menores precios)
  - Número de habitaciones (ideal 3)
  - Tamaño en m²
  - Número de baños

📱 **Diseño Mobile-First** totalmente responsive
🔗 **Enlaces directos** a Pisos.com e Inmobiliario.es

## Requisitos

- Node.js 18.x
- npm

## Instalación Local

```bash
# Instalar dependencias
npm install

# Iniciar en desarrollo
npm start

# Abrir navegador en http://localhost:3000
```

## Estructura

```
.
├── server.js              # App Express principal
├── views/
│   └── index.ejs         # Template HTML/CSS del dashboard
├── public/               # Archivos estáticos (si es necesario)
├── package.json
└── README.md
```

## Deployment en Railway

1. **Crear cuenta en Railway**: https://railway.app
2. **Conectar repositorio GitHub**
3. **Variables de entorno**:
   - `PORT`: Se establece automáticamente
   - `NODE_ENV`: production

El deployment se realiza automáticamente al hacer push a main.

## Cálculo de Score

La valoración (1-10) se calcula así:

```
Base: 5 puntos

+ Precio:
  - < €150k: +2
  - €150k-250k: +1.5
  - €250k-400k: +1
  - €400k-600k: +0.5

+ Habitaciones:
  - 3 habitaciones: +1
  - 2-4 habitaciones: +0.5

+ Tamaño:
  - > 150 m²: +1
  - > 100 m²: +0.5

+ Baños:
  - ≥ 3 baños: +0.5

Máximo: 10 puntos
Mínimo: 1 punto
```

## API

### GET /

Página principal con dashboard interactivo.

**Query parameters:**
- `minPrice`: Precio mínimo (€)
- `maxPrice`: Precio máximo (€)
- `minScore`: Score mínimo (1-10)
- `zone`: Zona/localidad a filtrar

### GET /api/properties

Retorna JSON con propiedades disponibles.

## Variables de Entorno

```env
PORT=3000
```

## Desarrollo

El dashboard se actualiza automáticamente al leer datos de:
`/home/alvaro/.openclaw/workspace/sierra-nevada-monitor/data/properties.json`

## Autor

Sebas (Asistente de Álvaro)

## Licencia

ISC
