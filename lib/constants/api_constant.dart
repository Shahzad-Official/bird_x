class ApiConstant {
  // static const mainUrl = "http://192.168.102.70:3000";
  static const mainUrl = "http://api.hexon.online:8080";
  static const baseUrl = "$mainUrl/api";

  //Auth routes
  static const getUsers = "/auth/all";
  static const login = "/auth/login";
  static const signUp = "/auth/signUp";
  static const googleSigin = "/auth/google-signin";
  static const verifyOtp = "/auth/verify";
  static const updateProfile = "/auth/update-profile";
  static const updatePassword = "/auth/update-password";
  static const sendOtp = "/auth/send-otp";
  static const getUserData = "/auth/";
  static const updateFcm = "/auth/update-fcm";

  //chat routes
  static const createRoom = "/chat/create-room";
  static const roomChats = "/chat";
  static const lastMessage = "/chat/last-message";
}
