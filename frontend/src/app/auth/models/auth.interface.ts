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
  user_identifier: string;
}

export interface AuthUser {
  email: string;
  profile: Profile;
  cars: Array<Car>;
  groups: Array<{ name: string }>;
  is_superuser: boolean;
}

export interface Profile {
  first_name: string;
  last_name: string;
  phone_number: string;
  avatar: string;
  id_card: string;
}

export interface Car {
  registration_plate: string;
  id: number;
}
