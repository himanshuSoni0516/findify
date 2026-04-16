class AppConstants {
  static const String supabaseUrl = 'https://oaslejwijhxydfpouqrq.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_Pl1u7PDGe5SorOeH3sFf2A_iKSWH1Md';
  static const String notificationsUrl = '$supabaseUrl/rest/v1/notifications';
  // Auth endpoints
  static const String signUpUrl = '$supabaseUrl/auth/v1/signup';
  static const String signInUrl = '$supabaseUrl/auth/v1/token?grant_type=password';
  static const String signOutUrl = '$supabaseUrl/auth/v1/logout';
  // Supabase token refresh endpoint
  static const refreshTokenUrl = '$supabaseUrl/auth/v1/token?grant_type=refresh_token';

  // DB endpoints
  static const String profilesUrl = '$supabaseUrl/rest/v1/profiles';
  static const String postsUrl = '$supabaseUrl/rest/v1/posts';

  // Storage
  static const String storageUrl = '$supabaseUrl/storage/v1/object/post-images';
  static const String storagePublicUrl = '$supabaseUrl/storage/v1/object/public/post-images';
}