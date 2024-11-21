export interface LoginRequest {
  email: string;
  password: string;
}

export interface ForgotPasswordRequest {
  email: string;
}

export interface LoginResponse {
  access: string;
  refresh: string;
}
