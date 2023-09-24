class ApiConstant {
  static const mainUrl = "http://192.168.102.70:3000";
  static const baseUrl = "$mainUrl/api";

  //Auth routes
  static const getUsers = "/auth";
  static const login = "/auth/login";
  static const signUp = "/auth/signUp";
  static const googleSigin = "/auth/google-signin";
  static const verifyOtp = "/auth/verify";
  static const updateProfile = "/auth/update-profile";
  static const updatePassword = "/auth/update-password";
  static const sendOtp = "/auth/send-otp";

  //chat routes
  static const createRoom = "/chat/create-room";
  static const roomChats = "/chat";
}
