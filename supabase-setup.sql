-- ================================================================
-- DAMMY ALIMI PORTFOLIO — SUPABASE SETUP SCRIPT
-- Run this entire script in your Supabase SQL Editor:
-- Dashboard → SQL Editor → New query → Paste → Run
-- ================================================================

-- 1. TABLES

CREATE TABLE IF NOT EXISTS portfolio_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  category TEXT DEFAULT 'photography',
  image_url TEXT,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS skills (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  percentage INTEGER DEFAULT 80 CHECK (percentage >= 0 AND percentage <= 100),
  display_order INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS services (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  icon TEXT DEFAULT 'bi-camera',
  display_order INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS about (
  id INTEGER PRIMARY KEY DEFAULT 1,
  full_name TEXT DEFAULT 'Alimi Deborah Damilola',
  tagline TEXT DEFAULT 'Photographer, Videographer, Media Producer, Content Creator, Broadcaster',
  bio TEXT DEFAULT 'Film and Multimedia Production graduate with hands-on experience in television and radio operations, photography, videography, and studio coordination.',
  summary TEXT DEFAULT 'A creative and detail-driven media professional with a strong foundation in broadcast production, photography, and visual storytelling.',
  profile_image_url TEXT,
  hero_image_url TEXT,
  location TEXT DEFAULT 'Ibadan, Oyo State, Nigeria',
  phone TEXT DEFAULT '07083114554',
  email TEXT DEFAULT 'alimideborahdamilola978@gmail.com',
  instagram TEXT DEFAULT '@dammyalimimedia',
  degree TEXT DEFAULT 'HND Film & Multimedia Production',
  school TEXT DEFAULT 'Fed. Poly Offa, Kwara State',
  freelance_available BOOLEAN DEFAULT true
);

CREATE TABLE IF NOT EXISTS resume_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  type TEXT NOT NULL CHECK (type IN ('education', 'experience')),
  title TEXT NOT NULL,
  subtitle TEXT,
  period TEXT,
  description TEXT,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. ROW LEVEL SECURITY

ALTER TABLE portfolio_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE about ENABLE ROW LEVEL SECURITY;
ALTER TABLE resume_items ENABLE ROW LEVEL SECURITY;

-- Public can read everything
CREATE POLICY "Public read portfolio"  ON portfolio_items FOR SELECT USING (true);
CREATE POLICY "Public read skills"     ON skills          FOR SELECT USING (true);
CREATE POLICY "Public read services"   ON services        FOR SELECT USING (true);
CREATE POLICY "Public read about"      ON about           FOR SELECT USING (true);
CREATE POLICY "Public read resume"     ON resume_items    FOR SELECT USING (true);

-- Only logged-in admin can write
CREATE POLICY "Auth write portfolio"   ON portfolio_items FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Auth write skills"      ON skills          FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Auth write services"    ON services        FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Auth write about"       ON about           FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Auth write resume"      ON resume_items    FOR ALL USING (auth.role() = 'authenticated');

-- 3. DEFAULT ABOUT ROW
INSERT INTO about (id) VALUES (1) ON CONFLICT (id) DO NOTHING;

-- 4. SEED SKILLS
INSERT INTO skills (name, percentage, display_order) VALUES
  ('Photography & Videography', 90, 1),
  ('Video Editing (CapCut)', 85, 2),
  ('Adobe Photoshop', 75, 3),
  ('Television Studio Production', 80, 4),
  ('Radio Programme Logging', 85, 5),
  ('Guest Coordination', 80, 6),
  ('Communication & Client Relations', 90, 7),
  ('Camera & Smartphone Operation', 92, 8)
ON CONFLICT DO NOTHING;

-- 5. SEED SERVICES
INSERT INTO services (title, description, icon, display_order) VALUES
  ('Photography', 'Professional photography for portraits, events, weddings, birthdays, religious gatherings, and products.', 'bi-camera', 1),
  ('Videography', 'Video shooting and editing for events, content creation and social media.', 'bi-camera-video', 2),
  ('Video Editing', 'Professional video editing using CapCut, creating polished, engaging content.', 'bi-scissors', 3),
  ('Photo Editing & Design', 'Image retouching, colour correction and graphic design using Adobe Photoshop.', 'bi-image', 4),
  ('Media Production Support', 'Studio preparation, props setup, programme logging, and production coordination.', 'bi-tv', 5),
  ('Guest & Event Coordination', 'Coordinating guests, planning sessions, and ensuring smooth operations for broadcasts.', 'bi-people', 6)
ON CONFLICT DO NOTHING;

-- 6. SEED RESUME
INSERT INTO resume_items (type, title, subtitle, period, description, display_order) VALUES
  ('education', 'Higher National Diploma (HND) — Film and Multimedia Production', 'Federal Polytechnic Offa, Kwara State', '2024 – 2026', 'Building on a strong foundation in broadcast media, camera operations, studio production and digital content creation.', 1),
  ('education', 'National Diploma (ND) — Mass Communication', 'Federal Polytechnic Offa, Kwara State', '2019 – 2021', 'Studying Mass Communication covering broadcasting, media writing, journalism, radio and television production.', 2),
  ('experience', 'Freelance Photographer & Videographer', 'Self-employed', '2024 – Present', 'Creates photo and video content for portraits, weddings, birthdays, religious gatherings, events and products.', 1),
  ('experience', 'Studio Manager & Photographer', 'Bob Pixels Photo Studio, Offa, Kwara State', '2022 – 2024', 'Managed day-to-day studio activities and photographed portraits, events and products.', 2),
  ('experience', 'Radio Studio Intern – Industrial Training', 'Voice FM 89.9, Ado-Ekiti', '2022', 'Logged radio programmes, coordinated guests, and assisted with broadcast preparation.', 3),
  ('experience', 'Television Production Intern – SIWES', 'Africa Independent Television (AIT), Cocoa House, Ibadan', 'Jan 2020 – Mar 2020', 'Helped prepare television studio spaces and gained exposure to television studio operations.', 4)
ON CONFLICT DO NOTHING;

-- ================================================================
-- STORAGE BUCKETS — IMPORTANT: 2-step process
-- ----------------------------------------------------------------
-- STEP A (Supabase Dashboard UI):
--   1. Go to Storage → click "New bucket"
--   2. Name: portfolio-images  → toggle "Public bucket" ON → Save
--   3. Click "New bucket" again
--   4. Name: profile-images    → toggle "Public bucket" ON → Save
--
-- STEP B (run the SQL below in SQL Editor):
--   After creating both buckets above, run this entire block.
-- ================================================================

-- Storage read (public)
CREATE POLICY "Public read portfolio images" ON storage.objects FOR SELECT USING (bucket_id = 'portfolio-images');
CREATE POLICY "Public read profile images"   ON storage.objects FOR SELECT USING (bucket_id = 'profile-images');

-- Storage write & delete (authenticated admin only)
CREATE POLICY "Auth upload portfolio images" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'portfolio-images' AND auth.role() = 'authenticated');
CREATE POLICY "Auth update portfolio images" ON storage.objects FOR UPDATE USING   (bucket_id = 'portfolio-images' AND auth.role() = 'authenticated');
CREATE POLICY "Auth delete portfolio images" ON storage.objects FOR DELETE USING   (bucket_id = 'portfolio-images' AND auth.role() = 'authenticated');
CREATE POLICY "Auth upload profile images"   ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'profile-images'   AND auth.role() = 'authenticated');
CREATE POLICY "Auth update profile images"   ON storage.objects FOR UPDATE USING   (bucket_id = 'profile-images'   AND auth.role() = 'authenticated');
CREATE POLICY "Auth delete profile images"   ON storage.objects FOR DELETE USING   (bucket_id = 'profile-images'   AND auth.role() = 'authenticated');
