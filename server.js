import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.static('public'));
app.set('view engine', 'ejs');
app.set('views', 'views');

// Load properties data
const dataPath = path.join(__dirname, 'data', 'properties.json');
let propertiesData = {};

try {
  const rawData = fs.readFileSync(dataPath, 'utf8');
  propertiesData = JSON.parse(rawData);
} catch (err) {
  console.error('Error loading properties:', err);
  propertiesData = { properties: {} };
}

// Calculate score (1-10) based on multiple criteria
function calculateScore(property) {
  let score = 5; // Base score
  
  const price = property.price || 0;
  const bedrooms = property.bedrooms || 0;
  const bathrooms = property.bathrooms || 0;
  const sizeM2 = property.size_m2 || 0;
  
  // PRECIO: Factor más importante - relación precio/m2
  // Ideal: < 2500€/m2 en Sierra Nevada
  if (sizeM2 > 0) {
    const pricePerM2 = price / sizeM2;
    if (pricePerM2 < 2000) score += 2.5;
    else if (pricePerM2 < 2500) score += 2;
    else if (pricePerM2 < 3000) score += 1.5;
    else if (pricePerM2 < 3500) score += 1;
    else score += 0.5;
  } else {
    // Si no tenemos m2, usar precio absoluto
    if (price < 150000) score += 2.5;
    else if (price < 250000) score += 2;
    else if (price < 350000) score += 1.5;
    else if (price < 500000) score += 1;
    else if (price < 700000) score += 0.5;
  }
  
  // DORMITORIOS: 3 es ideal para familias en zona de montaña
  if (bedrooms === 3) score += 1.5;
  else if (bedrooms === 4) score += 1.2;
  else if (bedrooms === 2) score += 0.8;
  else if (bedrooms >= 5) score += 1;
  
  // BAÑOS: Importante para comodidad
  if (bathrooms >= 3) score += 1;
  else if (bathrooms === 2) score += 0.5;
  
  // TAMAÑO: m2 útil - en zonas de montaña > 100m2 es muy bueno
  if (sizeM2 > 150) score += 1;
  else if (sizeM2 > 120) score += 0.8;
  else if (sizeM2 > 100) score += 0.5;
  
  // BONUS: Propiedades bien equilibradas
  if (bedrooms >= 2 && bathrooms >= 2 && sizeM2 > 80) {
    score += 0.5; // Bonus por ser una propiedad bien equilibrada
  }
  
  return Math.min(10, Math.max(1, Math.round(score * 10) / 10));
}

// Process properties
function getProcessedProperties() {
  const properties = propertiesData.properties || {};
  const processed = [];
  const seen = new Set();
  
  for (const [id, prop] of Object.entries(properties)) {
    if (!prop.url) continue;
    
    // Avoid duplicates by URL
    if (seen.has(prop.url)) continue;
    seen.add(prop.url);
    
    const score = calculateScore(prop);
    
    // Extract zone from location
    const zone = prop.location?.replace('Sierra Nevada ', '')?.replace('(Monachil)', '').trim() || 'Monachil';
    
    const mapQuery = encodeURIComponent(`${prop.title || ''} ${prop.location || 'Sierra Nevada Monachil'}`.trim());

    processed.push({
      id: prop.id,
      title: prop.title || 'Sin título',
      price: prop.price || 0,
      priceStr: `€${(prop.price || 0).toLocaleString('es-ES')}`,
      location: zone,
      bedrooms: prop.bedrooms || 0,
      bathrooms: prop.bathrooms || 0,
      size: prop.size_m2 || 0,
      score: score,
      url: prop.url,
      imageUrl: prop.imageUrl || '',
      mapUrl: `https://www.google.com/maps/search/?api=1&query=${mapQuery}`,
      portal: prop.portal || 'pisos.com',
      firstSeen: prop.firstSeen
    });
  }
  
  return processed;
}

// Routes
app.get('/', (req, res) => {
  const properties = getProcessedProperties();
  
  // Get filter values from query
  const minPrice = parseInt(req.query.minPrice) || 0;
  const maxPrice = parseInt(req.query.maxPrice) || 1000000;
  const minScore = parseFloat(req.query.minScore) || 0;
  const minBathrooms = parseInt(req.query.minBathrooms) || 2;
  const minBedrooms = parseInt(req.query.minBedrooms) || 0;
  const zone = req.query.zone || '';
  const sortBy = req.query.sortBy || 'score_desc';
  
  // Filter properties
  const filtered = properties.filter(p => {
    const priceMatch = p.price >= minPrice && p.price <= maxPrice;
    const scoreMatch = p.score >= minScore;
    const bathroomsMatch = p.bathrooms >= minBathrooms;
    const bedroomsMatch = p.bedrooms >= minBedrooms;
    const zoneMatch = !zone || p.location.includes(zone);
    return priceMatch && scoreMatch && bathroomsMatch && bedroomsMatch && zoneMatch;
  });
  
  // Sort
  const sorters = {
    score_desc: (a, b) => b.score - a.score,
    price_asc: (a, b) => a.price - b.price,
    price_desc: (a, b) => b.price - a.price,
    size_desc: (a, b) => b.size - a.size,
    bathrooms_desc: (a, b) => b.bathrooms - a.bathrooms,
    bedrooms_desc: (a, b) => b.bedrooms - a.bedrooms,
    newest_desc: (a, b) => new Date(b.firstSeen || 0) - new Date(a.firstSeen || 0),
  };
  filtered.sort(sorters[sortBy] || sorters.score_desc);
  
  // Get unique zones
  const zones = [...new Set(properties.map(p => p.location))].sort();
  
  res.render('index', {
    properties: filtered,
    zones: zones,
    totalProperties: properties.length,
    filteredCount: filtered.length,
    filters: { minPrice, maxPrice, minScore, minBathrooms, minBedrooms, zone, sortBy },
    avgPrice: Math.round(properties.reduce((sum, p) => sum + p.price, 0) / properties.length)
  });
});

app.get('/api/properties', (req, res) => {
  const properties = getProcessedProperties();
  res.json({
    total: properties.length,
    properties: properties.slice(0, 100)
  });
});

app.listen(PORT, () => {
  console.log(`🏠 Sierra Nevada Properties Dashboard running on port ${PORT}`);
  console.log(`📍 Open http://localhost:${PORT}`);
});
