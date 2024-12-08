export interface LoginRequest {
  email: string;
  password: string;
}

export interface LoginTokensResponse {
  access: string;
  refresh: string;
}

export interface UserJwt {
  exp: number;
  user_id: number;
}

export interface AuthUser {
  email: string;
  name: string;
  surname: string;
  isAdmin: boolean;
}
