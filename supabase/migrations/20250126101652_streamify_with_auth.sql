-- Location: supabase/migrations/20250126101652_streamify_with_auth.sql
-- Schema Analysis: Fresh Streamify streaming platform with authentication and content management
-- Integration Type: Complete streaming platform with authentication, video content, and admin functionality
-- Dependencies: None (fresh project)

-- 1. Types and Core Tables
CREATE TYPE public.user_role AS ENUM ('admin', 'user');
CREATE TYPE public.content_type AS ENUM ('movie', 'series', 'documentary');
CREATE TYPE public.content_status AS ENUM ('active', 'inactive', 'coming_soon');
CREATE TYPE public.video_quality AS ENUM ('360p', '480p', '720p', '1080p', '4k');

-- Critical intermediary table for user management
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    role public.user_role DEFAULT 'user'::public.user_role,
    avatar_url TEXT,
    subscription_status TEXT DEFAULT 'active',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Content categories for organization
CREATE TABLE public.categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    thumbnail_url TEXT,
    is_featured BOOLEAN DEFAULT false,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Main content table for videos/movies/series
CREATE TABLE public.content (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT,
    thumbnail_url TEXT NOT NULL,
    video_url TEXT,
    trailer_url TEXT,
    content_type public.content_type NOT NULL,
    status public.content_status DEFAULT 'active'::public.content_status,
    duration_minutes INTEGER,
    release_year INTEGER,
    rating DECIMAL(2,1) DEFAULT 0.0,
    genre TEXT[],
    director TEXT,
    cast_members TEXT[],
    category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
    is_featured BOOLEAN DEFAULT false,
    view_count INTEGER DEFAULT 0,
    created_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- User watch history and progress tracking
CREATE TABLE public.user_watch_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    content_id UUID REFERENCES public.content(id) ON DELETE CASCADE,
    watch_progress DECIMAL(5,2) DEFAULT 0.0, -- Progress percentage (0-100)
    watch_duration_seconds INTEGER DEFAULT 0,
    completed BOOLEAN DEFAULT false,
    last_watched_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, content_id)
);

-- User watchlist for saved content
CREATE TABLE public.user_watchlist (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    content_id UUID REFERENCES public.content(id) ON DELETE CASCADE,
    added_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, content_id)
);

-- Content quality/resolution options
CREATE TABLE public.content_quality_options (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content_id UUID REFERENCES public.content(id) ON DELETE CASCADE,
    quality public.video_quality NOT NULL,
    video_url TEXT NOT NULL,
    file_size_mb INTEGER,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(content_id, quality)
);

-- 2. Essential Indexes
CREATE INDEX idx_user_profiles_user_id ON public.user_profiles(id);
CREATE INDEX idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX idx_content_category_id ON public.content(category_id);
CREATE INDEX idx_content_type ON public.content(content_type);
CREATE INDEX idx_content_status ON public.content(status);
CREATE INDEX idx_content_featured ON public.content(is_featured);
CREATE INDEX idx_user_watch_history_user_id ON public.user_watch_history(user_id);
CREATE INDEX idx_user_watch_history_content_id ON public.user_watch_history(content_id);
CREATE INDEX idx_user_watchlist_user_id ON public.user_watchlist(user_id);
CREATE INDEX idx_content_quality_content_id ON public.content_quality_options(content_id);

-- 3. RLS Setup
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_watch_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_watchlist ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_quality_options ENABLE ROW LEVEL SECURITY;

-- 4. Safe Helper Functions
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER AS $$
SELECT EXISTS (
    SELECT 1 FROM public.user_profiles up
    WHERE up.id = auth.uid() AND up.role = 'admin'
)
$$;

CREATE OR REPLACE FUNCTION public.owns_watch_history(history_uuid UUID)
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER AS $$
SELECT EXISTS (
    SELECT 1 FROM public.user_watch_history uwh
    WHERE uwh.id = history_uuid AND uwh.user_id = auth.uid()
)
$$;

CREATE OR REPLACE FUNCTION public.owns_watchlist_item(watchlist_uuid UUID)
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER AS $$
SELECT EXISTS (
    SELECT 1 FROM public.user_watchlist uw
    WHERE uw.id = watchlist_uuid AND uw.user_id = auth.uid()
)
$$;

-- Function for automatic profile creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO public.user_profiles (id, email, full_name, role)
  VALUES (
    NEW.id, 
    NEW.email, 
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.raw_user_meta_data->>'role', 'user')::public.user_role
  );
  RETURN NEW;
END;
$$;

-- Trigger for new user creation
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to update content view count
CREATE OR REPLACE FUNCTION public.increment_view_count(content_uuid UUID)
RETURNS VOID
LANGUAGE sql
SECURITY DEFINER
AS $$
UPDATE public.content 
SET view_count = view_count + 1, updated_at = CURRENT_TIMESTAMP
WHERE id = content_uuid
$$;

-- 5. RLS Policies
CREATE POLICY "users_own_profile" ON public.user_profiles FOR ALL
USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

CREATE POLICY "public_read_categories" ON public.categories FOR SELECT
TO public USING (true);

CREATE POLICY "admin_manage_categories" ON public.categories FOR ALL
USING (public.is_admin()) WITH CHECK (public.is_admin());

CREATE POLICY "public_read_active_content" ON public.content FOR SELECT
TO public USING (status = 'active'::public.content_status);

CREATE POLICY "admin_manage_content" ON public.content FOR ALL
USING (public.is_admin()) WITH CHECK (public.is_admin());

CREATE POLICY "users_own_watch_history" ON public.user_watch_history FOR ALL
USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

CREATE POLICY "users_own_watchlist" ON public.user_watchlist FOR ALL
USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

CREATE POLICY "public_read_quality_options" ON public.content_quality_options FOR SELECT
TO public USING (true);

CREATE POLICY "admin_manage_quality_options" ON public.content_quality_options FOR ALL
USING (public.is_admin()) WITH CHECK (public.is_admin());

-- 6. Complete Mock Data
DO $$
DECLARE
    admin_uuid UUID := gen_random_uuid();
    user_uuid UUID := gen_random_uuid();
    category1_uuid UUID := gen_random_uuid();
    category2_uuid UUID := gen_random_uuid();
    category3_uuid UUID := gen_random_uuid();
    content1_uuid UUID := gen_random_uuid();
    content2_uuid UUID := gen_random_uuid();
    content3_uuid UUID := gen_random_uuid();
    content4_uuid UUID := gen_random_uuid();
BEGIN
    -- Create auth users with required fields
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (admin_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'admin@streamify.com', crypt('admin123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Admin User", "role": "admin"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (user_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'user@streamify.com', crypt('user123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Regular User", "role": "user"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Create categories
    INSERT INTO public.categories (id, name, description, thumbnail_url, is_featured, sort_order) VALUES
        (category1_uuid, 'Action & Adventure', 'High-octane action and thrilling adventures', 'https://images.unsplash.com/photo-1489599162810-1e666c4b4b5e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3', true, 1),
        (category2_uuid, 'Drama & Thriller', 'Compelling dramas and edge-of-your-seat thrillers', 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3', true, 2),
        (category3_uuid, 'Sci-Fi & Fantasy', 'Science fiction and fantasy worlds', 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3', false, 3);

    -- Create content
    INSERT INTO public.content (id, title, description, thumbnail_url, video_url, content_type, status, duration_minutes, release_year, rating, genre, director, cast_members, category_id, is_featured, view_count, created_by) VALUES
        (content1_uuid, 'The Crown', 'A biographical drama series about the reign of Queen Elizabeth II', 'https://images.unsplash.com/photo-1489599162810-1e666c4b4b5e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3', 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'series', 'active', 55, 2016, 8.7, ARRAY['Drama', 'Biography', 'History'], 'Peter Morgan', ARRAY['Claire Foy', 'Olivia Colman', 'Imelda Staunton'], category2_uuid, true, 15420, admin_uuid),
        (content2_uuid, 'Stranger Things', 'A group of young friends witness supernatural forces and government conspiracies', 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3', 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4', 'series', 'active', 50, 2016, 8.9, ARRAY['Sci-Fi', 'Horror', 'Drama'], 'The Duffer Brothers', ARRAY['Millie Bobby Brown', 'Finn Wolfhard', 'David Harbour'], category3_uuid, true, 28340, admin_uuid),
        (content3_uuid, 'Breaking Bad', 'A high school chemistry teacher turned methamphetamine manufacturer', 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3', 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_5mb.mp4', 'series', 'active', 47, 2008, 9.5, ARRAY['Crime', 'Drama', 'Thriller'], 'Vince Gilligan', ARRAY['Bryan Cranston', 'Aaron Paul', 'Anna Gunn'], category2_uuid, true, 45230, admin_uuid),
        (content4_uuid, 'The Witcher', 'Geralt of Rivia, a solitary monster hunter, struggles to find his place in a world', 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3', 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'series', 'active', 60, 2019, 8.2, ARRAY['Fantasy', 'Action', 'Adventure'], 'Lauren Schmidt Hissrich', ARRAY['Henry Cavill', 'Anya Chalotra', 'Freya Allan'], category3_uuid, false, 12890, admin_uuid);

    -- Create quality options for content
    INSERT INTO public.content_quality_options (content_id, quality, video_url, file_size_mb) VALUES
        (content1_uuid, '720p', 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 250),
        (content1_uuid, '1080p', 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4', 500),
        (content2_uuid, '720p', 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 280),
        (content2_uuid, '1080p', 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4', 600),
        (content3_uuid, '720p', 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 320),
        (content3_uuid, '1080p', 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_5mb.mp4', 720);

    -- Create some watch history for the user
    INSERT INTO public.user_watch_history (user_id, content_id, watch_progress, watch_duration_seconds, completed, last_watched_at) VALUES
        (user_uuid, content1_uuid, 65.0, 2145, false, now() - interval '2 hours'),
        (user_uuid, content2_uuid, 23.0, 690, false, now() - interval '1 day'),
        (user_uuid, content3_uuid, 89.0, 2511, false, now() - interval '3 days');

    -- Create watchlist entries
    INSERT INTO public.user_watchlist (user_id, content_id, added_at) VALUES
        (user_uuid, content4_uuid, now() - interval '5 days'),
        (user_uuid, content1_uuid, now() - interval '1 week');

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key error: %', SQLERRM;
    WHEN unique_violation THEN
        RAISE NOTICE 'Unique constraint error: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error: %', SQLERRM;
END $$;

-- Cleanup function for testing
CREATE OR REPLACE FUNCTION public.cleanup_test_data()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    auth_user_ids_to_delete UUID[];
BEGIN
    -- Get auth user IDs first
    SELECT ARRAY_AGG(id) INTO auth_user_ids_to_delete
    FROM auth.users
    WHERE email LIKE '%@streamify.com';

    -- Delete in dependency order
    DELETE FROM public.content_quality_options WHERE content_id IN (SELECT id FROM public.content WHERE created_by = ANY(auth_user_ids_to_delete));
    DELETE FROM public.user_watchlist WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.user_watch_history WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.content WHERE created_by = ANY(auth_user_ids_to_delete);
    DELETE FROM public.categories;
    DELETE FROM public.user_profiles WHERE id = ANY(auth_user_ids_to_delete);
    DELETE FROM auth.users WHERE id = ANY(auth_user_ids_to_delete);

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key constraint prevents deletion: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Cleanup failed: %', SQLERRM;
END;
$$;