-- ================================================================
-- SECTION TEXTS MIGRATION
-- Run this in Supabase SQL Editor to add editable section texts.
-- Dashboard → SQL Editor → New query → Paste → Run
-- Safe to run multiple times.
-- ================================================================

-- Add section subtitle/description columns to the about table
ALTER TABLE about ADD COLUMN IF NOT EXISTS skills_subtitle       TEXT DEFAULT 'A well-rounded skill set spanning broadcast production, visual content creation, client relations and creative tools.';
ALTER TABLE about ADD COLUMN IF NOT EXISTS services_subtitle     TEXT DEFAULT 'Professional media and content creation services tailored to individuals, businesses, and organisations.';
ALTER TABLE about ADD COLUMN IF NOT EXISTS portfolio_subtitle    TEXT DEFAULT 'A showcase of creative photography, videography and media production work across events, portraits, products and broadcast environments.';
ALTER TABLE about ADD COLUMN IF NOT EXISTS resume_subtitle       TEXT DEFAULT 'Film and Multimedia Production graduate with practical experience across television, radio, photography and studio management.';
ALTER TABLE about ADD COLUMN IF NOT EXISTS contact_subtitle      TEXT DEFAULT 'Ready to collaborate or discuss an opportunity? Reach out and let''s create something remarkable together.';
ALTER TABLE about ADD COLUMN IF NOT EXISTS about_summary_full    TEXT DEFAULT 'A creative and detail-driven media professional with a strong foundation in broadcast production, photography, and visual storytelling. Open to relocation, including Lagos, upon securing a suitable role.';

-- Add media_type column to portfolio_items (run once)
ALTER TABLE portfolio_items ADD COLUMN IF NOT EXISTS media_type TEXT DEFAULT 'image';
