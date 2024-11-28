export interface LoginRequest {
  email: string;
  password: string;
}

export interface ForgotPasswordRequest {
  email: string;
}

export interface LoginTokensResponse {
  access: string;
  refresh: string;
}
