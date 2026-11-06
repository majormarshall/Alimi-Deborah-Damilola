-- ================================================================
-- RLS POLICY FIX — Run this in Supabase SQL Editor
-- Dashboard → SQL Editor → New query → Paste → Run
-- This fixes editing (UPDATE) on skills and services tables.
-- ================================================================

-- Drop the old combined policies that may be blocking UPDATEs
DROP POLICY IF EXISTS "Auth write skills"    ON skills;
DROP POLICY IF EXISTS "Auth write services"  ON services;
DROP POLICY IF EXISTS "Auth write portfolio" ON portfolio_items;
DROP POLICY IF EXISTS "Auth write about"     ON about;
DROP POLICY IF EXISTS "Auth write resume"    ON resume_items;

-- Recreate with explicit separate policies for each operation
-- SKILLS
CREATE POLICY "Auth insert skills" ON skills FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Auth update skills" ON skills FOR UPDATE USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Auth delete skills" ON skills FOR DELETE USING (auth.role() = 'authenticated');

-- SERVICES
CREATE POLICY "Auth insert services" ON services FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Auth update services" ON services FOR UPDATE USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Auth delete services" ON services FOR DELETE USING (auth.role() = 'authenticated');

-- PORTFOLIO ITEMS
CREATE POLICY "Auth insert portfolio" ON portfolio_items FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Auth update portfolio" ON portfolio_items FOR UPDATE USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Auth delete portfolio" ON portfolio_items FOR DELETE USING (auth.role() = 'authenticated');

-- ABOUT
CREATE POLICY "Auth insert about" ON about FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Auth update about" ON about FOR UPDATE USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Auth delete about" ON about FOR DELETE USING (auth.role() = 'authenticated');

-- RESUME ITEMS
CREATE POLICY "Auth insert resume" ON resume_items FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Auth update resume" ON resume_items FOR UPDATE USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Auth delete resume" ON resume_items FOR DELETE USING (auth.role() = 'authenticated');
