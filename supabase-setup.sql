-- ═══════════════════════════════════════════════════════════
-- wing.back — Setup de Supabase
-- Ejecutar en: Supabase Dashboard → SQL Editor → New query
-- ═══════════════════════════════════════════════════════════

-- 1. TABLA DE PRODUCTOS
CREATE TABLE IF NOT EXISTS products (
  id          BIGSERIAL PRIMARY KEY,
  name        TEXT    NOT NULL,
  liga        TEXT    DEFAULT '',
  cat         TEXT    DEFAULT 'argentina',
  icon        TEXT    DEFAULT '⚽',
  price       INTEGER DEFAULT 0,
  stock       INTEGER DEFAULT 0,
  badge       TEXT    DEFAULT '',
  description TEXT    DEFAULT '',
  image       TEXT,
  active      BOOLEAN DEFAULT TRUE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- 2. TABLA DE PEDIDOS
CREATE TABLE IF NOT EXISTS orders (
  id          BIGSERIAL PRIMARY KEY,
  customer    TEXT    DEFAULT '',
  status      TEXT    DEFAULT 'pendiente',
  notes       TEXT    DEFAULT '',
  items       JSONB   DEFAULT '[]',
  total       INTEGER DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- 3. ACTIVAR SEGURIDAD POR FILAS (RLS)
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders   ENABLE ROW LEVEL SECURITY;

-- 4. POLÍTICAS DE PRODUCTOS
-- Visitantes: pueden ver productos activos (la tienda pública)
CREATE POLICY "Tienda: leer productos activos" ON products
  FOR SELECT TO anon
  USING (active = TRUE);

-- Admin autenticado: control total
CREATE POLICY "Admin: gestionar productos" ON products
  FOR ALL TO authenticated
  USING (TRUE) WITH CHECK (TRUE);

-- 5. POLÍTICAS DE PEDIDOS
-- Visitantes: pueden crear pedidos (cuando compran desde la tienda)
CREATE POLICY "Tienda: crear pedido" ON orders
  FOR INSERT TO anon
  WITH CHECK (TRUE);

-- Admin autenticado: control total
CREATE POLICY "Admin: gestionar pedidos" ON orders
  FOR ALL TO authenticated
  USING (TRUE) WITH CHECK (TRUE);

-- ═══════════════════════════════════════════════════════════
-- 6. CATÁLOGO INICIAL (podés borrar esto si vas a cargar
--    los productos desde el panel admin manualmente)
-- ═══════════════════════════════════════════════════════════
INSERT INTO products (name, liga, cat, icon, price, stock, badge, description, active) VALUES
  ('Boca Juniors',        'Liga Profesional', 'argentina',   '⚽', 18000, 12, 'hot', 'Titular 2024/25 · Con detalles dorados',    TRUE),
  ('River Plate',         'Liga Profesional', 'argentina',   '🔴', 18000, 10, '',    'Titular 2024/25 · Franja clásica',          TRUE),
  ('Racing Club',         'Liga Profesional', 'argentina',   '🔵', 16500,  8, 'new', 'Campeón Copa Sudamericana 2024',            TRUE),
  ('Independiente',       'Liga Profesional', 'argentina',   '🔴', 15000,  6, '',    'Rey de copas · Rojo clásico',               TRUE),
  ('San Lorenzo',         'Liga Profesional', 'argentina',   '🔵', 15000,  5, '',    'Titular azulgrana 2024/25',                 TRUE),
  ('Selección Argentina', 'Selecciones',      'selecciones', '🇦🇷', 20000, 15, 'hot', 'Campeón del Mundo Qatar 2022',             TRUE),
  ('Brasil',              'Selecciones',      'selecciones', '🇧🇷', 18500,  8, '',    'Canarinha · Temporada 2024',               TRUE),
  ('Francia',             'Selecciones',      'selecciones', '🇫🇷', 18500,  7, '',    'Les Bleus · Mbappé edition',               TRUE),
  ('Real Madrid',         'La Liga',          'europa',      '⭐', 19000,  9, 'new', 'Champions League 2024 · Blanco',            TRUE),
  ('FC Barcelona',        'La Liga',          'europa',      '🔵', 19000,  7, '',    'Temporada 2024/25 · Blaugrana',             TRUE),
  ('Manchester City',     'Premier League',   'europa',      '🩵', 19000,  6, '',    'Etihad · Celeste clásico',                  TRUE),
  ('Manchester United',   'Premier League',   'europa',      '🔴', 19000,  4, '',    'Old Trafford · Rojo diabólico',             TRUE),
  ('PSG',                 'Ligue 1',          'europa',      '🗼', 18000,  5, '',    'Paris Saint-Germain 2024/25',               TRUE),
  ('Juventus',            'Serie A',          'europa',      '⚫', 17500,  4, '',    'Bianconeri · Clásico a rayas',              TRUE),
  ('River Retro 96',      'Retro',            'retro',       '🏆', 22000,  3, 'new', 'Subcampeón Libertadores 1996',             TRUE),
  ('Argentina Retro 86',  'Retro',            'retro',       '🌟', 25000,  2, 'hot', 'Maradona · México 86 · Mítica',            TRUE),
  ('Boca Retro 2000',     'Retro',            'retro',       '🏆', 22000,  3, '',    'Campeón Libertadores 2000',                TRUE),
  ('Colombia Retro 94',   'Retro',            'retro',       '🇨🇴', 20000,  2, '',   'Valderrama · USA 94 · Legendaria',         TRUE);
